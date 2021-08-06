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
    static let shared: DemoPluginName = DemoPluginName()
    static let BaseUrl = "https://www.wanandroid.com/"
    func setup() {
        do {
            try Plugin.register(pluginName: self)
        } catch let err as Plugin.PluginError {
            print(err)
        } catch {
            print(error)
        }
        let mainNet: Net = Net.init(plugin: self.getPlugin(), baseUrl: DemoPluginName.BaseUrl).setToMainNet().setHttpBuilder(StubHttpBuilder())
        self.getPlugin().setMainNet(mainNet)
    }
    
    func getPlugin() -> Plugin {
        guard let plugin = Plugin.getBy(name: self) else {
            fatalError("call \(self).setup first!")
        }
        return plugin
    }
    
    func getMainNet() -> Net {
        guard let net = getPlugin().getNet(byBaseUrl: DemoPluginName.BaseUrl) else {
            fatalError("初始化net时，调用一下setToMainNet")
        }
        
        return net
    }
    
    func getMf() -> ModelFactory {
        return getPlugin().getMf()
    }
    
    func getNc() -> JNNotificationCenter {
        return getPlugin().getNc()
    }
    
    func getDB() -> DBManager {
        return getPlugin().getDBManager()
    }
    
    private var _netMap: [String: Net] = [:]
    
    class DemoMockEvent: Event {
        let id: Int
        init(id: Int) {
            self.id = id
        }
    }
}
