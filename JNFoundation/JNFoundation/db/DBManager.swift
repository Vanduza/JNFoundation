//
//  DBManager.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public class DBManager {
    init(builder: Builder) {
        _builder = builder
    }

    public func getSelfDB() -> Database {
        guard let selfDB = _selfDB else {
            fatalError("call DBManager.createSelfDB first")
        }
        return selfDB
    }

    public func getShareDB() -> Database {
        guard let shareDB = _shareDB else {
            fatalError("call DBManager.createShareDB first")
        }
        return shareDB
    }

    func createSelfDB() {
        self._selfDB?.close()
        let selfDB = Database(withPath: self.getSelfDBPath())
        self._selfDB = selfDB
        //数据库加密, 暂不需要加密
        if let pwd = getSelfDBPwd() {
            self._selfDB?.setCipher(key: pwd.data(using: .ascii))
        }

        VersionTable.createAt(db: selfDB)
    }

    func createShareDB() {
        self._shareDB?.close()
        let shareDB = Database(withPath: self.getShareDBPath())
        self._shareDB = shareDB
        VersionTable.createAt(db: shareDB)
    }

    private func getDBPath() -> String {
        return NSHomeDirectory() + "/Documents/database/"
        + String.init(describing: _builder.getPlugin().getName()) + "/"
    }

    private func getShareDBPath() -> String {
        return getDBPath() + "share.db"
    }

    private func getSelfDBPath() -> String {
        let uid = getUid()
        let md5 = (uid + "jn" + String.init(describing: (getPlugin().getName()))).md5()
        let dbname: String = String(uid.prefix(6)) + md5

        return getDBPath() + dbname + ".db"
    }

    private func getUid() -> String {
        var uid = getPlugin().getMf().getModel(Me.self).getUid()
        if uid == Me.empty {
            uid = "uid_tmp"
        }

        return uid
    }

    private func getPlugin() -> Plugin {
        return _builder.getPlugin()
    }

    private func getSelfDBPwd() -> String? {
        return _builder.getPassword()
    }

    private let _builder: Builder

    private var _shareDB: Database?
    private var _selfDB: Database?
}

class Builder {
    init(plugin: Plugin) {
        _plugin = plugin
    }

    func getPlugin() -> Plugin {
        guard let plugin = _plugin else {
            fatalError("Plugin has been released")
        }
        return plugin
    }

    func setPassword(_ pwd: String) {
        _password = pwd
    }

    func getPassword() -> String? {
        return _password
    }

    var enablePassword: Bool = false

    var hasPassword: Bool {
        return _password == nil
    }

    private var _password: String?
    //避免Plugin-DBManager-Builder-Plugin循环引用
    private weak var _plugin: Plugin?
}
