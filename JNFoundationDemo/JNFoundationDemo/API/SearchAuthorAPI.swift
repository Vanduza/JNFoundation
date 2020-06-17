//
//  SearchAuthorAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/17.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift

final class SearchAuthorAPI: DemoAPI, DemoAPIable {
    
    let request: Request
    var response: Response?
    
    override var needToken: Bool {
        return false
    }
    
    init(request: Request) {
        self.request = request
    }
    
    func getUrl() -> String {
        return "searchAuthors"
    }
    
    func parse(json: String) -> Observable<Void> {
        response = JsonTool.fromJson(json, toClass: Response.self)
        return Observable.just(())
    }
    
    func setModel(_ postModelEvent: Bool) -> Observable<Void> {
        return Observable.just(())
    }
}

extension SearchAuthorAPI {
    class Request: APIRequest {
        var token: String?
        var uuid: String?
        let name: String
        init(name: String) {
            self.name = name
        }
    }
    
    class Response: APIResponse {
        var result: String?
    }
}
