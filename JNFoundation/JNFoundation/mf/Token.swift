//
//  Token.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class Token: Model, ModelAble {
    static public let empty = ""

    public func getAllTables() -> [Table] {
        return [_table]
    }

    public func setToken(_ token: String, forUrl url: String) {
        _tokens[url] = token
        _table.set(value: token, forKey: url)
    }

    public func getToken(byUrl url: String) -> String {
        if let token = _tokens[url] {
            return token
        }

        if let token = _table.getValueBy(key: url) {
            _tokens[url] = token
            return token
        }

        return Token.empty
    }

    private lazy var _table: KeyValueStringTable = KeyValueStringTable.init(onDB: self.selfDB, withName: "token")

    private var _tokens: [String: String] = [:]
}
