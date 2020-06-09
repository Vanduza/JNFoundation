//
//  Plugin.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/8.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class Plugin {
    open class Name: Hashable {
        public static func == (lhs: Plugin.Name, rhs: Plugin.Name) -> Bool {
            return lhs.hashValue == rhs.hashValue
        }
        public func hash(into hasher: inout Hasher) {
            hasher.combine(String.init(describing: self))
        }
    }
    
    public enum PluginError: Error {
        case duplicatedRegister, notRegister
    }
    
    static private var _allPlugins: [Name: Plugin] = [:]
    
    public class func register(pluginName: Name) throws {
        if _allPlugins.contains(where: { $0.key == pluginName }) {
            throw PluginError.duplicatedRegister
        }
        
        _allPlugins[pluginName] = Plugin.init(name: pluginName)
    }
    
    public class func getBy(name: Name) -> Plugin? {
        return _allPlugins[name]
    }
    
    public func setDBManager(_ dbm: DBManager) {
        _dbManager = dbm
    }
    
    public func getDBManager() -> DBManager? {
        return _dbManager
    }
    
    public func getNotificationCenter() -> JNNotificationCenter {
        return _nc
    }
    
    public func setMainNet(_ net: Net) {
        guard _mainNet == nil else {
            fatalError("不能重复定义主网络")
        }
        _mainNet = net
    }
    
    public func getName() -> Name {
        return _name
    }
    
    private init(name: Name) {
        _name = name
    }
    
    private lazy var _nc: JNNotificationCenter = JNNotificationCenter.init(plugin: self)
    private var _dbManager: DBManager? = nil
    private var _nets: [String: Net] = [:]
    private var _mainNet: Net?
    private let _name: Name
}
