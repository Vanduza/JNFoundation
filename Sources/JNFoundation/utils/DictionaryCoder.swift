//
//  DictionaryCoder.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
// MARK: - Encoder
final class DictionaryEncoder: Encoder {

    var result: [String: Any] = [:]

    func encode<Value>(_ value: Value) throws -> [String: Any] where Value: Encodable {
        result.removeAll()
        try value.encode(to: self)
        return result
    }

    func container<Key>(keyedBy type: Key.Type) -> KeyedEncodingContainer<Key> where Key: CodingKey {
        return KeyedEncodingContainer<Key>.init(KeyedEncodingDictionaryContainer.init({ [weak self] (key: String, value: Any) in
            self?.result[key] = value
        }))
    }
}

fileprivate final class KeyedEncodingDictionaryContainer<CodingKeys: CodingKey>: KeyedEncodingContainerProtocol {

    private var block: (String, Any) -> Void

    init(_ block: @escaping (String, Any) -> Void) {
        self.block = block
    }

    func encodeNil(forKey key: CodingKeys) throws {
    }

    func encode(_ value: Bool, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: String, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Double, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Float, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Int, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Int8, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Int16, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Int32, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: Int64, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: UInt, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: UInt8, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: UInt16, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: UInt32, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode(_ value: UInt64, forKey key: CodingKeys) throws {
        block(key.stringValue, value)
    }

    func encode<T>(_ value: T, forKey key: CodingKeys) throws where T: Encodable {
        block(key.stringValue, value)
    }

    func nestedContainer<NestedKey>(keyedBy keyType: NestedKey.Type, forKey key: CodingKeys) -> KeyedEncodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("It should not be called. ")
    }

    func nestedUnkeyedContainer(forKey key: CodingKeys) -> UnkeyedEncodingContainer {
        fatalError("It should not be called. ")
    }

    func superEncoder() -> Encoder {
        fatalError("It should not be called. ")
    }

    func superEncoder(forKey key: CodingKeys) -> Encoder {
        fatalError("It should not be called. ")
    }

    var codingPath: [CodingKey] {
        fatalError("It should not be called. ")
    }

}

extension DictionaryEncoder {
    var codingPath: [CodingKey] {
        fatalError("It should not be called. ")
    }

    var userInfo: [CodingUserInfoKey: Any] {
        fatalError("It should not be called. ")
    }

    func unkeyedContainer() -> UnkeyedEncodingContainer {
        fatalError("It should not be called. ")
    }

    func singleValueContainer() -> SingleValueEncodingContainer {
        fatalError("It should not be called. ")
    }
}
// MARK: - Decoder
final class DictionaryDecoder: Decoder {

    var values: [String: Any]?

    public func decode<T>(_ type: T.Type, from dic: [String: Any]) throws -> T where T: Decodable {
        values = dic
        return try T(from: self)
    }

    func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key>
        where Key: CodingKey {
            return KeyedDecodingContainer<Key>(
                KeyedDecodingDictionaryContainer<Key>(withDic: &values!))
    }
}

extension DictionaryDecoder {
    var codingPath: [CodingKey] {
        fatalError("It should not be called. ")
    }

    var userInfo: [CodingUserInfoKey: Any] {
        fatalError("It should not be called. ")
    }

    func unkeyedContainer() throws -> UnkeyedDecodingContainer {
        fatalError("It should not be called. ")
    }

    func singleValueContainer() throws -> SingleValueDecodingContainer {
        fatalError("It should not be called. ")
    }
}

fileprivate final class KeyedDecodingDictionaryContainer<CodingKeys: CodingKey>: KeyedDecodingContainerProtocol {

    private let values: [String: Any]

    typealias Key = CodingKeys

    init(withDic: inout [String: Any]) {
        values = withDic
    }

    func contains(_ key: CodingKeys) -> Bool {
        return values[key.stringValue] != nil
    }

    func decodeNil(forKey key: CodingKeys) throws -> Bool {
        return values[key.stringValue] == nil
    }

    func decode(_ type: Bool.Type, forKey key: CodingKeys) throws -> Bool {
        return values[key.stringValue] as! Bool
    }

    func decode(_ type: String.Type, forKey key: CodingKeys) throws -> String {
        return values[key.stringValue] as! String
    }

    func decode(_ type: Double.Type, forKey key: CodingKeys) throws -> Double {
        return values[key.stringValue] as! Double
    }

    func decode(_ type: Float.Type, forKey key: CodingKeys) throws -> Float {
        return values[key.stringValue] as! Float
    }

    func decode(_ type: Int.Type, forKey key: CodingKeys) throws -> Int {
        return values[key.stringValue] as! Int
    }

    func decode(_ type: Int8.Type, forKey key: CodingKeys) throws -> Int8 {
        return values[key.stringValue] as! Int8
    }

    func decode(_ type: Int16.Type, forKey key: CodingKeys) throws -> Int16 {
        return values[key.stringValue] as! Int16
    }

    func decode(_ type: Int32.Type, forKey key: CodingKeys) throws -> Int32 {
        return values[key.stringValue] as! Int32
    }

    func decode(_ type: Int64.Type, forKey key: CodingKeys) throws -> Int64 {
        return values[key.stringValue] as! Int64
    }

    func decode(_ type: UInt.Type, forKey key: CodingKeys) throws -> UInt {
        return values[key.stringValue] as! UInt
    }

    func decode(_ type: UInt8.Type, forKey key: CodingKeys) throws -> UInt8 {
        return values[key.stringValue] as! UInt8
    }

    func decode(_ type: UInt16.Type, forKey key: CodingKeys) throws -> UInt16 {
        return values[key.stringValue] as! UInt16
    }

    func decode(_ type: UInt32.Type, forKey key: CodingKeys) throws -> UInt32 {
        return values[key.stringValue] as! UInt32
    }

    func decode(_ type: UInt64.Type, forKey key: CodingKeys) throws -> UInt64 {
        return values[key.stringValue] as! UInt64
    }

    func decode<T>(_ type: T.Type, forKey key: CodingKeys) throws -> T where T: Decodable {
        return values[key.stringValue] as! T
    }

    func nestedContainer<NestedKey>(keyedBy type: NestedKey.Type, forKey key: CodingKeys) throws -> KeyedDecodingContainer<NestedKey> where NestedKey: CodingKey {
        fatalError("It should not be called. ")
    }

    func nestedUnkeyedContainer(forKey key: CodingKeys) throws -> UnkeyedDecodingContainer {
        fatalError("It should not be called. ")
    }

    func superDecoder() throws -> Decoder {
        fatalError("It should not be called. ")
    }

    func superDecoder(forKey key: CodingKeys) throws -> Decoder {
        fatalError("It should not be called. ")
    }

    var codingPath: [CodingKey] {
        fatalError("It should not be called. ")
    }

    var allKeys: [CodingKeys] {
        fatalError("It should not be called. ")
    }
}
