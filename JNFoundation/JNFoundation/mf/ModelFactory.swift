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
        _plugin.getNotificationCenter().addObserver(self) { (event: Me.) in
            <#code#>
        }
    }
    
    private let _plugin: Plugin
    private var _allModel: [String: ModelAble] = [:]
    private let _lock: NSRecursiveLock = NSRecursiveLock()
}
