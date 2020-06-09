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
    
    private init(name: Name) {
        _name = name
    }
    
    private var _dbManager: DBManager? = nil
    //NotificationCenter
    private var _nets: [String: Net] = [:]
    //ModelFactory
    private let _name: Name
}
