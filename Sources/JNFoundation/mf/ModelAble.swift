//
//  ModelAble.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public protocol ModelAble: AnyObject {
    init(plugin: Plugin)
    var plugin: Plugin { get }
    func inited()
    func willDeinited()

    func getAllTables() -> [Table]
    func clearAllDataInDB()

    var needClearWhenUidChanged: Bool { get }
    var shareDB: Database { get }
    var selfDB: Database { get }
    var nc: JNNotificationCenter { get }
}

public extension ModelAble {
    var needClearWhenUidChanged: Bool {
        return true
    }
    var shareDB: Database {
        return plugin.getDBManager().getShareDB()
    }

    var selfDB: Database {
        return plugin.getDBManager().getSelfDB()
    }

    var nc: JNNotificationCenter {
        return plugin.getNc()
    }

    func clearAllDataInDB() {
        let tables = getAllTables()
        for table in tables {
            table.clear()
        }
    }

    func inited() {}
    func willDeinited() {}
}
