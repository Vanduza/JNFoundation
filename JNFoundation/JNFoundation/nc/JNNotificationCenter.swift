//
//  JNNotificationCenter.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class JNNotificationCenter {
    init(plugin: Plugin) {
        _plugin = plugin
    }

    public func addObserver<T: Event, Observer>(_ observer: Observer, using: @escaping (T) -> Void) {

    }

    public func removeObserver<Observer>(_ observer: Observer, event: AnyClass) {

    }

    public func post<T: Event>(_ event: T) {
        guard Thread.current.isMainThread else {
            fatalError("post方法必须在主线程调用")
        }
    }

    private weak var _plugin: Plugin?
}
