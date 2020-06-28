//
//  StubConnect.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift
import Alamofire

class StubConnect: HttpString {
    required init(builder: PostStringHttpBuilder) {
        _builder = builder
    }
    
    func send() -> Observable<String?> {
        let headersMap = ["Content-Type":"application/json; charset=utf-8","Accept":"application/json,text/json,text/javascript,text/html"]
        let combineHeaders = headersMap.merging(self._builder.getAllHeaders()) { $1 }
        
        let body = self._builder.getContent().data(using: .utf8)
        var req = try! URLRequest.init(url: self._builder.getUrl(), method: .post, headers: combineHeaders)
        req.httpBody = body
        
        return Observable<String?>.create { (observer) in
            let dataRequest = Alamofire.request(req).responseString { (response: DataResponse<String>) in
                if let err = response.error {
                    observer.onError(err)
                    return
                }
                
                if let data = response.data {
                    let json = String.init(data: data, encoding: .utf8)
                    observer.onNext(json)
                }
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    private var request: Alamofire.Request? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    private let _builder: PostStringHttpBuilder
}

class StubHttpBuilder: PostStringHttpBuilder {
    var codeResponseType: CodeResponse.Type {
        return ResponseCode.self
    }
    
    func build() -> HttpString {
        let connect = StubConnect.init(builder: self)
        return connect
    }
    
    func setUrl(_ url: String) -> PostStringHttpBuilder {
        _url = url
        return self
    }
    
    func getUrl() -> String {
        return _url
    }
    
    func setMethod(_ method: HttpMethod) -> PostStringHttpBuilder {
        _method = method
        return self
    }
    
    func getMethod() -> HttpMethod {
        return _method
    }
    
    func addHeader(key: String, value: String) -> PostStringHttpBuilder {
        _header[key] = value
        return self
    }
    
    func getHeader(key: String) -> String? {
        return _header[key]
    }
    
    func getAllHeaders() -> [String: String] {
        return _header
    }
    
    func setContent(_ content: String) -> PostStringHttpBuilder {
        _body = content
        return self
    }
    
    func getContent() -> String {
        return _body
    }
    
    func setNeedToken(_ needToken: Bool) -> PostStringHttpBuilder {
        _needToken = needToken
        return self
    }
    
    func getIsNeedToken() -> Bool {
        return _needToken
    }
    
    init() {}
    
    private var _url: String = ""
    private var _header: [String: String] = [:]
    private var _body: String = ""
    private var _method: HttpMethod = .POST
    private var _needToken = false
}
