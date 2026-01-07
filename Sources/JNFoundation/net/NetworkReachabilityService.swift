import Foundation
import RxRelay
import RxSwift
import Network

enum NetworkStatus {
    case unknown
    case notReachable
    case reachableViaWiFi
    case reachableViaWWAN
}

protocol NetworkReachabilityService {
    var networkStatus: Observable<NetworkStatus> { get }
    func startListening()
    func stopListening()
}

class SystemNetworkReachabilityService: NetworkReachabilityService {
    private let pathMonitor: NWPathMonitor
    private let monitorQueue = DispatchQueue(label: "NetworkReachabilityMonitor")
    private let networkStatusRelay: BehaviorRelay<NetworkStatus> = .init(value: .unknown)
    let isReachableRelay: BehaviorRelay<Bool> = .init(value: false)
    private var isListening = false
    
    var networkStatus: Observable<NetworkStatus> {
        return networkStatusRelay.asObservable()
    }
    
    init() {
        self.pathMonitor = NWPathMonitor()
        setupPathMonitor()
    }
    
    init(requiredInterfaceType: NWInterface.InterfaceType) {
        self.pathMonitor = NWPathMonitor(requiredInterfaceType: requiredInterfaceType)
        setupPathMonitor()
    }
    
    private func setupPathMonitor() {
        pathMonitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            
            let networkStatus: NetworkStatus
            let isReachable: Bool
            
            switch path.status {
            case .satisfied:
                isReachable = true
                if path.usesInterfaceType(.wifi) {
                    networkStatus = .reachableViaWiFi
                } else if path.usesInterfaceType(.cellular) {
                    networkStatus = .reachableViaWWAN
                } else if path.usesInterfaceType(.wiredEthernet) {
                    networkStatus = .reachableViaWiFi // 将有线以太网视为 WiFi 类型
                } else {
                    networkStatus = .reachableViaWiFi // 其他接口类型默认视为 WiFi
                }
            case .unsatisfied:
                networkStatus = .notReachable
                isReachable = false
            case .requiresConnection:
                networkStatus = .unknown
                isReachable = false
            @unknown default:
                networkStatus = .unknown
                isReachable = false
            }
            
            self.networkStatusRelay.accept(networkStatus)
            self.isReachableRelay.accept(isReachable)
        }
    }
    
    func startListening() {
        guard !isListening else { return }
        
        pathMonitor.start(queue: monitorQueue)
        isListening = true
        
        // 立即发送当前状态
        updateStatus()
    }
    
    func stopListening() {
        guard isListening else { return }
        
        pathMonitor.cancel()
        isListening = false
    }
    
    private func updateStatus() {
        let path = pathMonitor.currentPath
        let networkStatus: NetworkStatus
        let isReachable: Bool
        
        switch path.status {
        case .satisfied:
            isReachable = true
            if path.usesInterfaceType(.wifi) {
                networkStatus = .reachableViaWiFi
            } else if path.usesInterfaceType(.cellular) {
                networkStatus = .reachableViaWWAN
            } else if path.usesInterfaceType(.wiredEthernet) {
                networkStatus = .reachableViaWiFi
            } else {
                networkStatus = .reachableViaWiFi
            }
        case .unsatisfied:
            networkStatus = .notReachable
            isReachable = false
        case .requiresConnection:
            networkStatus = .unknown
            isReachable = false
        @unknown default:
            networkStatus = .unknown
            isReachable = false
        }
        
        networkStatusRelay.accept(networkStatus)
        isReachableRelay.accept(isReachable)
    }
    
    deinit {
        stopListening()
    }
}
