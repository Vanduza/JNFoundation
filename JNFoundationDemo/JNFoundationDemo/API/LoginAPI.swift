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
        let account_id: Int
        var user_name: String?
        var avatar: String?
        var nickname: String?
        var mobile: String?
        var first_name: String?
        var last_name: String?
        var email: String?
        var age: Int
        var gender: String?
        var birthday: Int
        var is_qq: Bool
        var is_weibo: Bool
        var is_wechat: Bool
        var registeer_way: Int
        let token: String
    }
    
    class LoginEvent: JNFoundation.Event {
        let token: String
        init(token: String) {
            self.token = token
        }
    }
}
