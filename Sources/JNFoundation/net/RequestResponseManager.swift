import Foundation
import RxSwift

class RequestResponseManager {
    static let shared = RequestResponseManager()
    
    private let queue = DispatchQueue(label: "com.jn.request.response", qos: .utility)
    private var responseSubjects: [String: PublishSubject<Result<APIable, Error>>] = [:]
    
    private init() {}
    
    /// 为请求创建响应 Subject
    func createResponseSubject(forRequestId requestId: String) -> PublishSubject<Result<APIable, Error>> {
        return queue.sync {
            let subject = PublishSubject<Result<APIable, Error>>()
            responseSubjects[requestId] = subject
            return subject
        }
    }
    
    /// 获取请求的响应 Subject
    func getResponseSubject(forRequestId requestId: String) -> PublishSubject<Result<APIable, Error>>? {
        return queue.sync {
            return responseSubjects[requestId]
        }
    }
    
    /// 发送响应并清理 Subject
    func sendResponse(forRequestId requestId: String, result: Result<APIable, Error>) {
        queue.async {
            if let subject = self.responseSubjects[requestId] {
                subject.onNext(result)
                subject.onCompleted()
                self.responseSubjects.removeValue(forKey: requestId)
            }
        }
    }
}
