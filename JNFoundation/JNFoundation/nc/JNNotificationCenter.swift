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

    private static let EventKey = "event"

    public func addObserver<T: Event, Observer>(_ observer: Observer, using: @escaping (T) -> Void) {
        let name: NSNotification.Name = getNotificationNameOf(event: T.self)
        let ob = _nc.addObserver(forName: name, object: nil, queue: nil) { (nt: Notification) in
            using(nt.userInfo![JNNotificationCenter.EventKey] as! T)
        }

        _map[name.rawValue] = ob
    }

    public func removeObserver<Observer>(_ observer: Observer, event: AnyClass) {
        guard let evt = event as? Event.Type else { return }
        let name = getNotificationNameOf(event: evt)
        JPrint(items: name)
        guard let ob = _map[name.rawValue] else { return }
        _nc.removeObserver(ob)
        _map.removeValue(forKey: name.rawValue)
    }

    public func removeObserveAll<Observer>(_ observer: Observer) {
        for tuple in _map {
            _nc.removeObserver(tuple.value)
        }
    }

    public func post<T: Event>(_ event: T) {
        guard Thread.current.isMainThread else {
            fatalError("post方法必须在主线程调用")
        }
        let name: NSNotification.Name = getNotificationNameOf(event: T.self)
        guard let plugin = _plugin else {
            JPrint("plugin has been released!")
            return
        }
        JPrint(items: name)
        event.setPlugin(plugin: plugin)
        _nc.post(name: name, object: nil, userInfo: [JNNotificationCenter.EventKey: event])
    }

    private func getNotificationNameOf<T: Event>(event: T.Type) -> NSNotification.Name {
        return NSNotification.Name.init(String(describing: type(of: T.self)))
    }

    private weak var _plugin: Plugin?
    private let _nc: NotificationCenter = NotificationCenter()
    private var _map: [String: NSObjectProtocol] = [:]
}
