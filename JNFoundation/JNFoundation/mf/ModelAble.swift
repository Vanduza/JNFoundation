//
//  ModelAble.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol ModelAble: class {
    init(plugin: Plugin)
    var plugin: Plugin { get }
    func inited()
    func willDeinited()

    func getAllTables() -> [Table]
    func clearAllData()

    var needClearWhenUidChanged: Bool { get }
    var shareDB: Database { get }
    var selfDB: Database { get }
}

extension ModelAble {
    public var needClearWhenUidChanged: Bool {
        return true
    }
    public var shareDB: Database {
        return plugin.getDBManager().getShareDB()
    }

    public var selfDB: Database {
        return plugin.getDBManager().getSelfDB()
    }

    public func clearAllData() {
        let tables = getAllTables()
        for table in tables {
            table.clear()
        }
    }

    public func inited() {}
    public func willDeinited() {}
}
