//
//  Codable+dictionary.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

extension Encodable {
    func toDictionary() throws -> [String: Any] {
        let encoder = DictionaryEncoder()
        return try encoder.encode(self)
    }
}

extension Decodable {
    static func fromDictionary(_ dic: [String: Any]) throws ->Self {
        let decoder = DictionaryDecoder()
        return try decoder.decode(Self.self, from: dic)
    }
}
