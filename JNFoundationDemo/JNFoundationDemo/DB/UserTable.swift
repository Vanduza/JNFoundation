//
//  UserTable.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import WCDBSwift

class UserTable: TableAble {
    var db: Database
    init(db: Database) {
        self.db = db
    }
    
    func setItems(_ items: [Entity]) -> Bool {
        if items.isEmpty { return true }
        do {
            try db.insertOrReplace(objects: items, intoTable: self.name)
            return true
        } catch let err {
            JPrint(items: err)
            return false
        }
    }

    func getItem(by id: String) -> Entity? {
        let item: Entity? = try! db.getObject(fromTable: self.name, where: Entity.Properties.id == id)
        return item
    }
    
    struct Entity: TableCodable {
        var id: String
        var name: String
        var gender: Int
        
        enum CodingKeys: String, CodingTableKey {
            typealias Root = Entity
            static let objectRelationalMapping: TableBinding<UserTable.Entity.CodingKeys> = TableBinding.init(CodingKeys.self)
            case id, name, gender
            static var columnConstraintBindings: [UserTable.Entity.CodingKeys : ColumnConstraintBinding]? {
                return [
                    id: ColumnConstraintBinding.init(isPrimary: true),
                ]
            }
        }
        
        func toItem() -> UserModel.Item {
            let item = UserModel.Item.init(id: id, name: name, gender: gender)
            return item
        }
    }
}
