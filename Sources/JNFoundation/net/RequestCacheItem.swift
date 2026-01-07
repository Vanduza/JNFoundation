import Foundation
import RxSwift

struct RequestCacheItem {
    let id: String
    let api: APIable
    let timestamp: Date
    let retryCount: Int
    let priority: Int
    let completionHandlers: [RequestCompletionHandler]
    
    init(api: APIable, priority: Int = 0, completionHandler: RequestCompletionHandler? = nil) {
        self.id = UUID().uuidString
        self.api = api
        self.timestamp = Date()
        self.retryCount = 0
        self.priority = priority
        
        if let handler = completionHandler {
            self.completionHandlers = [handler]
        } else {
            self.completionHandlers = []
        }
    }
    
    init(id: String, api: APIable, timestamp: Date, retryCount: Int, priority: Int, completionHandlers: [RequestCompletionHandler]) {
        self.id = id
        self.api = api
        self.timestamp = timestamp
        self.retryCount = retryCount
        self.priority = priority
        self.completionHandlers = completionHandlers
    }
    
    func withIncrementedRetry() -> RequestCacheItem {
        return RequestCacheItem(
            id: self.id,
            api: self.api,
            timestamp: self.timestamp,
            retryCount: self.retryCount + 1,
            priority: self.priority,
            completionHandlers: self.completionHandlers
        )
    }
    
    func addingCompletionHandler(_ handler: @escaping RequestCompletionHandler) -> RequestCacheItem {
        var newHandlers = self.completionHandlers
        newHandlers.append(handler)
        return RequestCacheItem(
            id: self.id,
            api: self.api,
            timestamp: self.timestamp,
            retryCount: self.retryCount,
            priority: self.priority,
            completionHandlers: newHandlers
        )
    }
}
