//
//  RegisterAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2021/1/13.
//  Copyright © 2021 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

final class RegisterAPI: DemoAPI, DemoAPIable {
    var request: Request
    
    var response: Response?
    
    init(req: Request) {
        self.request = req
    }
    
    func getUrl() -> String {
        return "regPhone"
    }
}

extension RegisterAPI {
    class Request: APIRequest {
        var token: String?
        var uuid: String?
        
        private let mobile: String
        private let code: String
        init(mobile: String, code: String) {
            self.mobile = mobile
            self.code = code
        }
    }
    
    class Response: APIResponse {
        
    }
}
