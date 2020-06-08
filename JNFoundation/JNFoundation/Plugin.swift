//
//  Plugin.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/8.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class Plugin {
    open class Name {}
    
    public enum PluginError: Error {
        case duplicatedRegister, notRegister
    }
    
    static private var _allPlugins: [String: Plugin] = [:]
    
    public class func register(pluginName: Name.Type) throws {
        let name = String(describing: pluginName)
        if _allPlugins.contains(where: { $0.key == name }) {
            throw PluginError.duplicatedRegister
        }
        
        _allPlugins[name] = Plugin.init(name: pluginName)
    }
    
    private init(name: Name.Type) {
        
    }
    
    //DBManager
    //NotificationCenter
    //map[String]Net
    //ModelFactory
    //name
}
