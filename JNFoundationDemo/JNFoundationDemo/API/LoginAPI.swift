//
//  LoginAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2021/1/13.
//  Copyright © 2021 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

final class LoginAPI: DemoAPI, DemoAPIable {
    var request: Request
    var response: Response?
    
    func getUrl() -> String {
        return "login"
    }
    
    init(req: Request) {
        self.request = req
    }
    
    override var needToken: Bool {
        return false
    }
    
    class Request: APIRequest {
        var token: String?
        var uuid: String?
        
        private let user_name: String
        private let password: String
        init(userName: String, pwd: String) {
            self.user_name = userName
            self.password = pwd
        }
    }
    
    class Response: APIResponse {
        let data: UserEntity
    }
    
    struct UserEntity: Decodable {
        let user_id: Int
        let token: String
    }
    
    class LoginEvent: JNFoundation.Event {
        let token: String
        init(token: String) {
            self.token = token
        }
    }
}
