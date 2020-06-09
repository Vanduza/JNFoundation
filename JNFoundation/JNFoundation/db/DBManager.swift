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
        
    }
    
    private func createSelfDB() {
        self._selfDB?.close();
        
        self._selfDB = Database(withPath: self.getSelfDBPath());
//        if let pwd = getSelfDBPwd() {
//            self._selfDB!.setCipher(key: pwd.data(using: .ascii));
//        }
        
        VersionTable.createAt(db: _selfDB!);
    }
    
    private func createShareDB() {
        self._shareDB?.close();
        
        self._shareDB = Database(withPath: self.getShareDBPath());
        
//        if let pwd = getShareDBPwd() {
//            self._shareDB!.setCipher(key: pwd.data(using: .ascii));
//        }
        
        VersionTable.createAt(db: _shareDB!);
    }
    
    private func getDBPath()->String {
        return NSHomeDirectory() + "/Documents/database/"
        + String.init(describing: _builder.getPlugin().getName()) + "/";
    }
    
    private func getShareDBPath()->String {
        return getDBPath() + "share.db";
    }
    
    private func getSelfDBPath()->String {
        let uid = getUid();
        let md5 = (uid + "jn" + String.init(describing: (_builder.getPlugin().getName())).md5();
        let dbname:String = String(uid.prefix(6)) + md5;
        
        return getDBPath() + dbname + ".db";
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
        return _plugin
    }
    
    func build() {
        
    }
    
    private let _plugin: Plugin
}
