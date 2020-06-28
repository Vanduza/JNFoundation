//
//  UserModel.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

class UserModel: Model, ModelAble {
    func getAllTables() -> [Table] {
        return [_table]
    }
    
    private lazy var _table = UserTable.init(db: self.selfDB)
    
    func setItem(_ item: Item) -> Bool {
        let entity = item.toEntity()
        do {
            try _table.db.insert(objects: [entity], intoTable: _table.name)
            return true
        } catch {
            JPrint(items: error)
            return false
        }
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
