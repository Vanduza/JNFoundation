//
//  Model.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

open class Model {
    public required init(plugin: Plugin) {
        self.plugin = plugin
    }

    public var plugin: Plugin
}

open class ModelEvent: Event {
    public let ids: [String]
    public required init(ids: [String]) {
        self.ids = ids
    }
}
