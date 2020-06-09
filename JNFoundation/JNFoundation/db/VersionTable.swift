//
//  VersionTable.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

final class VersionTable {
    static let name = "version_table"
    static func createAt(db: Database) {
        let table = KeyValueLongTable.init(onDB: db, withName: name)
        table.createIfNotExist()
    }
    
    static func getVersion(onDB db: Database, ofTable tableName: String) -> Int {
        let table = KeyValueLongTable.init(onDB: db, withName: name)
        return table.get(key: tableName) ?? 0
    }
    
    static func set(version: Int, onDB db: Database, forTable tableName:String) {
      let table = KeyValueLongTable.init(onDB: db, withName: name);
      table.set(value: version, forKey: tableName);
    }
}
