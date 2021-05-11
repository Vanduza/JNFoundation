//
//  Table.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol Table: AnyObject {
    func createIfNotExist()
    func clear()

    var db: Database { get }
    var name: String { get }
    var version: Int { get }
    var firstVersion: Int { get }
}

extension Table {
    public func clear() {
        do {
            try db.delete(fromTable: name)
        } catch let err {
            JPrint(items: err)
        }
    }

    public var version: Int {
        return firstVersion
    }

    public var firstVersion: Int {
        return 1
    }

    public var name: String {
        //将"."替换成"_"避免部分关键字识别错误
        let name = String.init(describing: Self.self).replacingOccurrences(of: ".", with: "_")
        return name
    }
}

public protocol TableAble: Table {
    associatedtype Entity: TableCodable
    typealias Fields = Entity.Properties
}

extension TableAble {
    public func createIfNotExist() {
        try? db.run(embeddedTransaction: {
            try? db.create(table: name, of: Self.Entity.self)

            var old = VersionTable.getVersion(onDB: db, ofTable: name)
            if old == 0 {
                old = firstVersion
                VersionTable.set(version: old, onDB: db, forTable: name)
            }

            guard version >= 1 else {
                fatalError("table:\(name) version must be >= 1, but set \(version)")
            }

            if version != old {
                //数据库升级
            }

            VersionTable.set(version: version, onDB: db, forTable: name)
        })
    }
}
