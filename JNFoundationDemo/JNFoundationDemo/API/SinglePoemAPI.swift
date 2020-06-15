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

final class SinglePoemAPI: DemoAPIable {
    var request: Request
    
    var response: Response?
    

    func processToken(_ response: String) {

    }

    var needSetModel: Bool = true

    var shouldPostModelEvent: Bool = true

    var disposebag: DisposeBag = DisposeBag()
    
    var needToken: Bool {
        return false
    }

    var code: APICode

    init(request: SinglePoemAPI.Request) {
        self.request = request
        code = .ELSE_ERROR
    }

    func getUrl() -> String {
        return "singlePoetry"
    }

    func parse(json: String) -> Observable<Void> {
        response = JsonTool.fromJson(json, toClass: Response.self)
        return Observable.just(())
    }

    func setModel(_ postModelEvent: Bool) -> Observable<Void> {
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
