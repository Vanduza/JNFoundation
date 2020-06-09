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
    var needClearWhenUidChanged: Bool {
        return true
    }
    
    var shareDB: Database {
        guard let dbm = plugin.getDBManager() else {
            fatalError("call Plugin.setDBManager first!")
        }
        return dbm.
    }
    
    func clearAllData() {
        let tables = getAllTables()
        for table in tables {
            table.clear()
        }
    }
    
    public func inited() {}
    public func willDeinited() {}
}
