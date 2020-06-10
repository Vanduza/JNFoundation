//
//  ModelFactory.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

final public class ModelFactory {
    init(plugin: Plugin) {
        _plugin = plugin
//        _plugin.getNotificationCenter().addObserver(self) { (event: Me.) in
//            <#code#>
//        }
    }

    public func getModel<T: ModelAble>(_ clazz: T.Type) -> T {
        let clazzName: String = String.init(describing: clazz)
        var model: T
        _lock.lock()
        if let type = _allModel[clazzName] {
            model = type as! T
        } else {
            model = T.init(plugin: _plugin)
            let tables = model.getAllTables()
            for table in tables {
                table.createIfNotExist()
            }
            model.inited()
            _allModel[clazzName] = model
        }
        _lock.unlock()
        return model
    }

    private let _plugin: Plugin
    private var _allModel: [String: ModelAble] = [:]
    private let _lock: NSRecursiveLock = NSRecursiveLock()
}
