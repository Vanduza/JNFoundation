//
//  UserModel.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift

class UserModel: Model, ModelAble {
    
    //MARK: 网络请求
    func login(userName: String, password: String) -> Observable<LoginAPI> {
        return LoginAPI.init(req: .init(userName: userName, pwd: password)).send()
    }
    
    func register(phone: String, validCode: String) -> Observable<RegisterAPI> {
        return RegisterAPI.init(req: .init(mobile: phone, code: validCode)).send()
    }
}
