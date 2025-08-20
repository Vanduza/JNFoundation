//
//  KeyValueStringTable.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
@preconcurrency import WCDBSwift

public class KeyValueStringTable: TableAble {
    public struct Entity: TableCodable {
        var key: String
        var value: String

        public enum CodingKeys: String, CodingTableKey {
            public typealias Root = Entity
            public static let objectRelationalMapping = TableBinding(CodingKeys.self) {
                BindColumnConstraint(key, isPrimary: true)
            }
            case key, value
        }
    }

    public init(onDB: Database, withName: String) {
        db = onDB
        name = withName
    }

    public func getValueBy(key: String) -> String? {
        let object: Entity? = (try? db.getObject(fromTable: name, where: Entity.Properties.key == key)) ?? nil

        return object?.value
    }

    public func set(value: String, forKey: String) {
        try? db.insertOrReplace([Entity(key: forKey, value: value)], intoTable: name)
    }

    public func delete(key: String) {
        try? db.delete(fromTable: name, where: Entity.Properties.key == key)
    }

    public let db: Database
    public let name: String
}
