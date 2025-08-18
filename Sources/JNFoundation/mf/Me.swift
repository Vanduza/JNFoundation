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
            // 发送uid初始化的通知
            plugin.getNc().post(UidSetEvent())
            return
        }

        _uid = uid
        _table.set(value: uid, forKey: Key.uid.rawValue)
        // 同步切换数据库，避免异步获取错误
        plugin.getDBManager().createSelfDB()
        // 清除Model缓存，重新载入更新SelfDB的Model
        plugin.getMf().clearModelCache()
        // 发送一系列通知uidchanged
        plugin.getNc().post(UidChanedEvent())
    }

    public var needClearWhenUidChanged: Bool = false

    private lazy var _table: KeyValueStringTable = KeyValueStringTable(onDB: shareDB, withName: "me")
    private var _uid: String?
}
// MARK: - 通知类型定义
/**
 * uid变化要引起很多基础模块的初始化
 * 所以发两个事件：
 * 1. UidSetEvent: 业务层即将执行UidChanged事件，即使uid没有变化也要发此事件
 * 2. UidChangedEvent: uid发生改变，业务应监听此事件
 */
extension Me {
    final class UidSetEvent: Event {}
    final class UidChanedEvent: Event {}
}
