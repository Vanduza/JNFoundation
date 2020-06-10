//
//  Me.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public class Me: ModelAble {

    enum Key: String {
        case uid
    }

    static let empty = ""

    public let plugin: Plugin

    public required init(plugin: Plugin) {
        self.plugin = plugin
    }

    public func getAllTables() -> [Table] {
        return [_table]
    }

    public func getUid() -> String {
        if let uid = _uid {
            return uid
        }

        if let uid = _table.getValueBy(key: Key.uid.rawValue) {
            _uid = uid
            return uid
        }

        let uid = Me.empty
        _uid = uid
        return uid
    }

    public func setUid(_ uid: String) {
        if _uid == uid {
            //发送uid初始化的通知
            return
        }

        _uid = uid
        _table.set(value: uid, forKey: Key.uid.rawValue)
        //发送一系列通知uidchanged
    }

    public var needClearWhenUidChanged: Bool = false

    private lazy var _table: KeyValueStringTable = KeyValueStringTable(onDB: shareDB, withName: "me")
    private var _uid: String?
}
