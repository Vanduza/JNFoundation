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

    public func setHttpBuilder<T: PostStringHttpBuilder>(_ builder: T) -> Net {
        _httpBuilder = builder
        return self
    }

    public func getHttpBuilder() -> PostStringHttpBuilder {
        guard let builder = _httpBuilder else {
            fatalError("call setHttpBuilder first!")
        }
        return builder
    }

    public func setToMainNet() -> Net {
        _isMainNet = true
        return self
    }

    public func setToken(_ token: String) {
        _token = token
    }

    public func getToken() -> String {
        return _token
    }

    public func clear401() {
        _has401 = false
    }

    public func setLogin(_ isLogin: Bool) {
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
    private var _token: String = ""

    public class Net401Event: Event {
        init(net: Net) {
            self.net = net
        }
        public let net: Net
    }

    public enum NetError: Error, LocalizedError {
        case responseEmpty
        case tokenExpired
        case apiReleased
        case decodeJsonError
        case tokenEmpty
        case networkError(error: String, code: Int)

        public var errorDescription: String? {
            switch self {
            case .responseEmpty:
                return "响应为空"
            case .tokenExpired:
                return "Token已过期"
            case .apiReleased:
                return "API对象已被释放"
            case .decodeJsonError:
                return "JSON编码错误"
            case .tokenEmpty:
                return "Token为空"
            case .networkError(let error, let code):
                return "网络错误 code:\(code), message:\(error)"
            }
        }
    }
}
