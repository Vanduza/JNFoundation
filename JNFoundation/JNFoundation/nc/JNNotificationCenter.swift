//
//  JNNotificationCenter.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift

public class JNNotificationCenter {
    init(plugin: Plugin) {
        _plugin = plugin
    }

    private static let EventKey = "event"

    public func addObserver<T: Event, Observer>(_ observer: Observer, using: @escaping (T) -> Void) -> Disposable {
        let name: NSNotification.Name = getNotificationNameOf(event: T.self)
        let ob = _nc.addObserver(forName: name, object: nil, queue: nil) { (nt: Notification) in
            using(nt.userInfo![JNNotificationCenter.EventKey] as! T)
        }
        return Disposables.create { [weak self] in
            self?._nc.removeObserver(ob)
        }
    }

    public func post<T: Event>(_ event: T) {
        guard Thread.current.isMainThread else {
            fatalError("post方法必须在主线程调用")
        }
        let name: NSNotification.Name = getNotificationNameOf(event: type(of: event).self)
        guard let plugin = _plugin else {
            JPrint("plugin has been released!")
            return
        }
        event.setPlugin(plugin: plugin)
        _nc.post(name: name, object: nil, userInfo: [JNNotificationCenter.EventKey: event])
    }

    private func getNotificationNameOf(event: AnyClass) -> NSNotification.Name {
        let eventName = event.description()
        return NSNotification.Name.init(eventName)
    }

    private weak var _plugin: Plugin?
    private let _nc: NotificationCenter = NotificationCenter()
}
