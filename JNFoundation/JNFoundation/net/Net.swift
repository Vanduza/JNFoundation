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

    private let _plugin: Plugin
    private let _baseUrl: String
}
