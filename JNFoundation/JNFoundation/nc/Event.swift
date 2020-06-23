//
//  Event.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

open class Event {
    public func getPlugin() -> Plugin {
        guard let plugin = _plugin else {
            fatalError("call Event.setPlugin first!")
        }
        return plugin
    }

    func setPlugin(plugin: Plugin) {
        _plugin = plugin
    }

    private var _plugin: Plugin?
    public init() {}
}
