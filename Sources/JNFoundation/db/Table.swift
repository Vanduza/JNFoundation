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
        // 将"."替换成"_"避免部分关键字识别错误
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
        try? db.run { [weak self] _ in
            guard let sself = self else { return }
            try? sself.db.create(table: sself.name, of: Self.Entity.self)

            var old = VersionTable.getVersion(onDB: sself.db, ofTable: sself.name)
            if old == 0 {
                old = sself.firstVersion
                VersionTable.set(version: old, onDB: sself.db, forTable: sself.name)
            }

            guard sself.version >= 1 else {
                fatalError("table:\(sself.name) version must be >= 1, but set \(sself.version)")
            }

            if sself.version != old {
                // 数据库升级
            }

            VersionTable.set(version: sself.version, onDB: sself.db, forTable: sself.name)
        }
    }
}
