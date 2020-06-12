//
//  Net.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public final class Net {
    public init(plugin: Plugin, baseUrl: String) {
        _plugin = plugin
        _baseUrl = baseUrl
    }

    public func setHttpBuilder<T: PostStringHttpBuilder>(_ builder: T) {
        _httpBuilder = builder
    }

    public func getHttpBuilder() -> PostStringHttpBuilder {
        guard let builder = _httpBuilder else {
            fatalError("call setHttpBuilder first!")
        }
        return builder
    }

    public func setToMainNet() -> Net {
        _plugin?.setMainNet(self)
        _isMainNet = true
        return self
    }

    public func setToken(_ token: String) {
        if !_isMainNet {
            getPlugin().getMf().getModel(Token.self).setToken(token, forUrl: getBaseUrl())
            return
        }

        getPlugin().getNc().removeObserver(self, event: Me.UidSetEvent.self)

        getPlugin().getNc().addObserver(self) { [weak self] (_: Me.UidSetEvent) in
            guard let sself = self else { return }
            sself.getPlugin().getMf().getModel(Token.self).setToken(token, forUrl: sself.getBaseUrl())
        }
    }

    public func getToken() -> String {
        return getPlugin().getMf().getModel(Token.self).getToken(byUrl: getBaseUrl())
    }

    public func clear401() {
        _has401 = false
    }

    func setLogin(_ isLogin: Bool) {
        _isLogin = isLogin
    }

    func isLogin() -> Bool {
        return _isLogin
    }

    func set401(_ has401: Bool) {
        _has401 = has401
    }

    func getHas401() -> Bool {
        return _has401
    }

    func getBaseUrl() -> String {
        return _baseUrl
    }

    func getPlugin() -> Plugin {
        guard let plugin = _plugin else {
            fatalError("plugin has been released!")
        }
        return plugin
    }

    private weak var _plugin: Plugin?
    private let _baseUrl: String
    private var _httpBuilder: PostStringHttpBuilder?
    private var _isMainNet: Bool = false
    private var _isLogin: Bool = false
    private var _has401: Bool = false

    public class Net401Event: Event {
        init(net: Net) {
            self.net = net
        }
        public let net: Net
    }

    public enum NetError: Error {
        case responseEmpty, tokenExpired, apiReleased, decodeJsonError
    }
}
