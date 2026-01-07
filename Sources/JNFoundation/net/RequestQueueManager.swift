import Foundation
import RxSwift

typealias RequestCompletionHandler = (Result<APIable, Error>) -> Void

class RequestQueueManager {
    static let shared = RequestQueueManager()
    
    private let queue = DispatchQueue(label: "com.jn.request.queue", qos: .utility)
    private var cachedRequests: [RequestCacheItem] = []
    private let maxCacheCount = 100
    private let maxRetryCount = 3
    private let cacheExpiration: TimeInterval = 24 * 60 * 60 // 24小时
    private let retryDelay: TimeInterval = 1.0 // 重试延迟
    private let maxConcurrentRetries = 3 // 最大并发重试数
    
    private let requestAddedSubject = PublishSubject<RequestCacheItem>()
    private let requestRemovedSubject = PublishSubject<RequestCacheItem>()
    private let requestRetrySubject = PublishSubject<RequestCacheItem>()
    
    private let disposeBag = DisposeBag()
    private var isRetrying = false
    private let networkReachabilityService = SystemNetworkReachabilityService()
    
    var requestAdded: Observable<RequestCacheItem> {
        return requestAddedSubject.asObservable()
    }
    
    var requestRemoved: Observable<RequestCacheItem> {
        return requestRemovedSubject.asObservable()
    }
    
    var requestRetry: Observable<RequestCacheItem> {
        return requestRetrySubject.asObservable()
    }
    
    private init() {
        setupCleanupTimer()
        setupNetworkMonitoring()
    }
    
    // MARK: - 公共接口
    
    /// 添加请求到缓存队列（带回调）
    func addRequest(_ api: APIable, priority: Int = 0, completionHandler: RequestCompletionHandler? = nil) -> RequestCacheItem {
        return queue.sync {
            // 清理过期请求
            cleanupExpiredRequests()
            
            // 如果队列已满，移除优先级最低的请求
            if cachedRequests.count >= maxCacheCount {
                removeLowestPriorityRequest()
            }
            
            let item = RequestCacheItem(api: api, priority: priority, completionHandler: completionHandler)
            cachedRequests.append(item)
            
            // 按优先级排序
            cachedRequests.sort { $0.priority > $1.priority }
            
            requestAddedSubject.onNext(item)
            JPrint("请求已缓存: \(api.getUrl()), 缓存ID: \(item.id), 优先级: \(priority)")
            
            // 立即检查网络状态，如果网络可用则尝试重试
            if isNetworkReachable() {
                startRetryIfNeeded()
            }
            
            return item
        }
    }
    
    /// 为已存在的缓存请求添加回调
    func addCompletionHandler(forRequestId requestId: String, handler: @escaping RequestCompletionHandler) {
        return queue.sync {
            if let index = cachedRequests.firstIndex(where: { $0.id == requestId }) {
                let item = cachedRequests[index]
                let updatedItem = item.addingCompletionHandler(handler)
                cachedRequests[index] = updatedItem
                JPrint("为缓存请求 \(requestId) 添加回调处理器")
            }
        }
    }
    
    /// 手动触发重试（可用于调试或特殊场景）
    func manualRetry() -> Observable<Void> {
        return Observable.create { observer in
            self.startRetryIfNeeded()
            observer.onCompleted()
            return Disposables.create()
        }
    }
    
    /// 获取当前缓存请求数量
    func getCachedRequestCount() -> Int {
        return queue.sync {
            return cachedRequests.count
        }
    }
    
    /// 清空所有缓存请求
    func clearAllCachedRequests() {
        queue.sync {
            cachedRequests.removeAll()
            JPrint("已清空所有缓存请求")
        }
    }
    
    // MARK: - 私有方法
    
    /// 获取下一个待发送的请求
    private func getNextRequest() -> RequestCacheItem? {
        return queue.sync {
            guard !cachedRequests.isEmpty else { return nil }
            return cachedRequests.first
        }
    }
    
    /// 移除已发送的请求
    private func removeRequest(_ item: RequestCacheItem) {
        queue.sync {
            if let index = cachedRequests.firstIndex(where: { $0.id == item.id }) {
                let removedItem = cachedRequests.remove(at: index)
                requestRemovedSubject.onNext(removedItem)
                JPrint("请求已从缓存中移除: \(item.api.getUrl()), 缓存ID: \(item.id)")
            }
        }
    }
    
    /// 更新请求的重试次数
    private func updateRequestRetry(_ item: RequestCacheItem) -> RequestCacheItem? {
        return queue.sync {
            guard let index = cachedRequests.firstIndex(where: { $0.id == item.id }) else {
                return nil
            }
            
            let updatedItem = item.withIncrementedRetry()
            cachedRequests[index] = updatedItem
            JPrint("请求重试次数更新: \(item.api.getUrl()), 当前重试次数: \(updatedItem.retryCount)")
            return updatedItem
        }
    }
    
    /// 获取所有缓存的请求
    private func getAllRequests() -> [RequestCacheItem] {
        return queue.sync {
            return cachedRequests
        }
    }
    
    /// 通知所有回调处理器
    private func notifyCompletionHandlers(for item: RequestCacheItem, result: Result<APIable, Error>) {
        queue.async {
            for handler in item.completionHandlers {
                handler(result)
            }
            JPrint("已通知 \(item.completionHandlers.count) 个回调处理器: \(item.api.getUrl())")
        }
    }
    
    // MARK: - 自动重发逻辑
    
    /// 设置网络监控
    private func setupNetworkMonitoring() {
        // 监听网络状态变化
        networkReachabilityService.isReachableRelay
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] isReachable in
                if isReachable {
                    self?.onNetworkRestored()
                }
            })
            .disposed(by: disposeBag)
    }
    
    /// 检查网络是否可达
    private func isNetworkReachable() -> Bool {
        return networkReachabilityService.isReachableRelay.value
    }
    
    /// 网络恢复时的处理
    private func onNetworkRestored() {
        guard !isRetrying else { return }
        
        isRetrying = true
        JPrint("网络恢复，开始重试缓存的请求")
        
        retryCachedRequests()
            .subscribe(onError: { [weak self] error in
                self?.isRetrying = false
                JPrint("重试缓存请求时出错: \(error)")
            }, onCompleted: { [weak self] in
                self?.isRetrying = false
                JPrint("所有缓存请求重试完成")
            })
            .disposed(by: disposeBag)
    }
    
    /// 如果需要则开始重试
    private func startRetryIfNeeded() {
        guard !isRetrying && isNetworkReachable() else { return }
        
        isRetrying = true
        JPrint("开始重试缓存的请求")
        
        retryCachedRequests()
            .subscribe(onError: { [weak self] error in
                self?.isRetrying = false
                JPrint("重试缓存请求时出错: \(error)")
            }, onCompleted: { [weak self] in
                self?.isRetrying = false
                JPrint("缓存请求重试完成")
            })
            .disposed(by: disposeBag)
    }
    
    /// 重试缓存的请求
    private func retryCachedRequests() -> Observable<Void> {
        return Observable.create { observer in
            let requests = self.getAllRequests()
            JPrint("发现 \(requests.count) 个待重试的请求")
            
            if requests.isEmpty {
                observer.onCompleted()
                return Disposables.create()
            }
            
            let retryObservables = requests.prefix(self.maxConcurrentRetries).map { item in
                self.retrySingleRequest(item)
            }
            
            Observable.zip(retryObservables)
                .subscribe(onNext: { _ in
                    // 继续重试剩余的请求
                    self.retryCachedRequests()
                        .subscribe(onError: { error in
                            observer.onError(error)
                        }, onCompleted: {
                            observer.onCompleted()
                        })
                        .disposed(by: self.disposeBag)
                }, onError: { error in
                    observer.onError(error)
                })
                .disposed(by: self.disposeBag)
            
            return Disposables.create()
        }
    }
    
    /// 重试单个请求
    private func retrySingleRequest(_ item: RequestCacheItem) -> Observable<Void> {
        return Observable.create { observer in
            JPrint("开始重试请求: \(item.api.getUrl()), 缓存ID: \(item.id)")
            
            // 检查是否超过最大重试次数
            if item.retryCount >= self.maxRetryCount {
                JPrint("请求 \(item.api.getUrl()) 已达到最大重试次数，将被移除")
                self.notifyCompletionHandlers(for: item, result: .failure(NSError(domain: "RequestCache", code: -3, userInfo: [NSLocalizedDescriptionKey: "请求已达到最大重试次数"])))
                self.removeRequest(item)
                observer.onCompleted()
                return Disposables.create()
            }
            
            // 更新重试次数
            guard let updatedItem = self.updateRequestRetry(item) else {
                JPrint("请求 \(item.api.getUrl()) 已不存在于缓存队列中")
                observer.onCompleted()
                return Disposables.create()
            }
            
            // 发送重试事件
            self.requestRetrySubject.onNext(updatedItem)
            
            // 延迟重试，避免网络刚恢复时不稳定
            DispatchQueue.main.asyncAfter(deadline: .now() + self.retryDelay) {
                self.executeRetry(updatedItem, observer: observer)
            }
            
            return Disposables.create()
        }
    }
    
    /// 执行重试
    private func executeRetry(_ item: RequestCacheItem, observer: AnyObserver<Void>) {
        // 重新发送请求 - 使用类型擦除的包装器
        let api = item.api
        
        // 创建一个类型擦除的Observable来发送请求
        let sendObservable: Observable<APIable> = Observable.create { apiObserver in
            // 这里我们需要调用send()方法，但由于api是any APIable，我们不能直接调用send()
            // 我们需要使用一个包装器或通过其他方式发送请求
            
            // 创建一个中间对象来处理类型擦除
            let disposable = api.sendWithTypeErasure()
                .subscribe(
                    onNext: { result in
                        apiObserver.onNext(result)
                    },
                    onError: { error in
                        apiObserver.onError(error)
                    },
                    onCompleted: {
                        apiObserver.onCompleted()
                    }
                )
            
            return disposable
        }
        
        sendObservable
            .subscribe(onNext: { [weak self] api in
                guard let self = self else { return }
                
                JPrint("请求重试成功: \(api.getUrl())")
                
                // 通知原始订阅者
                self.notifyCompletionHandlers(for: item, result: .success(api))
                
                // 从缓存队列中移除
                self.removeRequest(item)
                
                observer.onNext(())
                observer.onCompleted()
            }, onError: { [weak self] error in
                guard let self = self else { return }
                
                JPrint("请求重试失败: \(item.api.getUrl()), 错误: \(error)")
                
                // 检查是否是网络错误，如果是则保留在队列中等待下次重试
                if let netError = error as? Net.NetError,
                   case .networkError = netError {
                    JPrint("网络错误，请求保留在队列中等待下次重试")
                } else {
                    // 其他错误，通知订阅者并移除请求
                    self.notifyCompletionHandlers(for: item, result: .failure(error))
                    self.removeRequest(item)
                    JPrint("非网络错误，请求从队列中移除")
                }
                
                observer.onError(error)
            })
            .disposed(by: self.disposeBag)
    }
    
    // MARK: - 清理和维护
    
    /// 清理过期请求
    private func cleanupExpiredRequests() {
        let now = Date()
        cachedRequests = cachedRequests.filter { item in
            // 检查是否过期
            let isExpired = now.timeIntervalSince(item.timestamp) > cacheExpiration
            // 检查是否超过最大重试次数
            let exceededRetry = item.retryCount >= maxRetryCount
            
            if isExpired || exceededRetry {
                // 通知所有订阅者请求已过期
                notifyCompletionHandlers(for: item, result: .failure(NSError(domain: "RequestCache", code: -1, userInfo: [NSLocalizedDescriptionKey: "请求已过期"])))
                requestRemovedSubject.onNext(item)
                JPrint("清理过期请求: \(item.api.getUrl()), 缓存ID: \(item.id)")
                return false
            }
            return true
        }
    }
    
    /// 移除优先级最低的请求
    private func removeLowestPriorityRequest() {
        guard !cachedRequests.isEmpty else { return }
        
        // 找到优先级最低的请求
        if let minPriorityIndex = cachedRequests.enumerated().min(by: { $0.element.priority < $1.element.priority })?.offset {
            let removedItem = cachedRequests.remove(at: minPriorityIndex)
            // 通知订阅者请求被移除
            notifyCompletionHandlers(for: removedItem, result: .failure(NSError(domain: "RequestCache", code: -2, userInfo: [NSLocalizedDescriptionKey: "请求队列已满，请求被移除"])))
            requestRemovedSubject.onNext(removedItem)
            JPrint("移除优先级最低的请求: \(removedItem.api.getUrl()), 优先级: \(removedItem.priority)")
        }
    }
    
    /// 设置定时清理
    private func setupCleanupTimer() {
        // 每5分钟清理一次过期请求
        Observable<Int>.interval(.seconds(300), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                self?.queue.async {
                    self?.cleanupExpiredRequests()
                }
            }).disposed(by: disposeBag)
    }
}

// MARK: - APIable 扩展，添加类型擦除支持
extension APIable {
    /// 发送请求并返回类型擦除的 Observable<APIable>
    fileprivate func sendWithTypeErasure() -> Observable<APIable> {
        return Observable.create { observer in
            let disposable = self.send()
                .subscribe(
                    onNext: { api in
                        observer.onNext(api)
                    },
                    onError: { error in
                        observer.onError(error)
                    },
                    onCompleted: {
                        observer.onCompleted()
                    }
                )
            
            return disposable
        }
    }
}

// 扩展 JPrint 函数
#if DEBUG
func JPrint(_ items: Any...) {
    #if DEBUG
    print("[RequestQueueManager]", items)
    #endif
}
#endif

