//
//  DBManager.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class DBManager {
    init(builder: Builder) {
        _builder = builder
    }
    
    private let _builder: Builder
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
