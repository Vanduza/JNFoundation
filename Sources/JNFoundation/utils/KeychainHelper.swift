//
//  KeychainHelper.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

struct KeychainHelper {
    private let kUUIDKey = Bundle.main.bundleIdentifier ?? "com.vanduza.uuid"
    @discardableResult
    func keychainSave(uuid: String) -> Bool {
        let query = createQueryDictionary(identifier: kUUIDKey)
        SecItemDelete(query)
        query.setValue(uuid.data(using: String.Encoding.utf8), forKey: kSecValueData as String)

        let status: OSStatus = SecItemAdd(query, nil)
        return status == noErr
    }

    func keychainQueryUUID() -> String? {
        let query = createQueryDictionary(identifier: kUUIDKey)

        query.setValue(kCFBooleanTrue, forKey: kSecReturnData as String)
        query.setValue(kSecMatchLimitOne, forKey: kSecMatchLimit as String)

        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)

        if status == noErr {
            if let data = dataTypeRef as! Data? {
                let ret = String(data: data, encoding: String.Encoding.utf8)
                return ret
            }
        }

        return nil
    }

    private func createQueryDictionary(identifier: String) -> NSMutableDictionary {
        let query = NSMutableDictionary()
        query.setValue(kSecClassGenericPassword, forKey: kSecClass as String)
        query.setValue(identifier, forKey: kSecAttrService as String)
        query.setValue(identifier, forKey: kSecAttrAccount as String)
        query.setValue(kSecAttrAccessibleAfterFirstUnlock, forKey: kSecAttrAccessible as String)
        return query
    }
}
