//
//  Table.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol Table: class {
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
        }catch let err {
            debugPrint(err)
        }
    }
    
    public var firstVersion: Int {
        return 1
    }
    
    public var name: String {
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
            
            var old = VersionTable.get
        })
    }
}
