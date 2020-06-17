//
//  SinglePoemAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/15.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift

final class SinglePoemAPI: DemoAPI, DemoAPIable {
    var request: Request
    
    var response: Response?

    init(request: SinglePoemAPI.Request) {
        self.request = request
    }

    func getUrl() -> String {
        return "singlePoetry"
    }

    func parse(json: String) -> Observable<Void> {
        response = JsonTool.fromJson(json, toClass: Response.self)
        return Observable.just(())
    }

    func setModel(_ postModelEvent: Bool) -> Observable<Void> {
        mf.getModel(Me.self).setUid("123")
        return Observable.just(())
    }
    
    deinit {
        JPrint("dealloc \(type(of: self))")
    }
}

extension SinglePoemAPI {
    class Request: APIRequest {
        var token: String?
        var uuid: String?
    }

    class Response: APIResponse {
        var result: String?
    }
}
