//
//  ModelAble.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public protocol ModelAble: AnyObject {
    init(plugin: Plugin)
    var plugin: Plugin { get }
    func inited()
    func willDeinited()

    var needClearWhenUidChanged: Bool { get }
    var nc: JNNotificationCenter { get }
}

public extension ModelAble {
    var needClearWhenUidChanged: Bool {
        return true
    }

    var nc: JNNotificationCenter {
        return plugin.getNc()
    }

    func inited() {}
    func willDeinited() {}
}
