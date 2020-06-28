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
}
