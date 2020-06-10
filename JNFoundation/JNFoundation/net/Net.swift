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

    func getBaseUrl() -> String {
        return _baseUrl
    }

    private weak var _plugin: Plugin?
    private let _baseUrl: String
    private var _httpBuilder: PostStringHttpBuilder?
}
