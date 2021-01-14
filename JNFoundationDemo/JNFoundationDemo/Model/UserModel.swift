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
    
    //MARK: 数据库读写
    func getAllTables() -> [Table] {
        return [_table]
    }
    
    private lazy var _table = UserTable.init(db: self.selfDB)
    
    func setItem(_ item: Item) -> Bool {
        let entity = item.toEntity()
        return _table.setItems([entity])
    }
    
    func getItem(by id: String) -> UserModel.Item? {
        return _table.getItem(by: id)?.toItem()
    }
}

extension UserModel {
    struct Item {
        let id: String
        let name: String
        let gender: Int
        
        func toEntity() -> UserTable.Entity {
            let item = UserTable.Entity.init(id: self.id, name: self.name, gender: self.gender)
            return item
        }
    }
}
