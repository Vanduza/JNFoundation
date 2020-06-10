//
//  DemoPlugin.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/10.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

class DemoPluginName: Plugin.Name {
    func setup() {
        do {
            try Plugin.register(pluginName: self)
        } catch let err {
            print("Plugin.registerError:", err)
        }
    }
    
    func getPlugin() -> Plugin {
        guard let plugin = Plugin.getBy(name: self) else {
            fatalError("call \(self).setup first!")
        }
        return plugin
    }
}
