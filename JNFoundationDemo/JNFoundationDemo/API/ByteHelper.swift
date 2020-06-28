//
//  ByteHelper.swift
//  ComponentsLibrary
//
//  Created by 杨敬 on 2020/6/26.
//  Copyright © 2020 杨敬. All rights reserved.
//

import Foundation

struct ByteHelper {
    ///Float数组转Byte数组
    static func floats2Bytes(_ fs: [Float]) -> [UInt8] {
        var bs = [UInt8]()
        for var f in fs {
            bs += withUnsafePointer(to: &f) {
                $0.withMemoryRebound(to: UInt8.self, capacity: 4) {
                    Array(UnsafeBufferPointer(start: $0, count: 4))
                }
            }
        }
        return bs
    }

    static func bytes2String(_ bs: [UInt16]) -> String {
        return Data.init(bytes: bs, count: bs.count).base64EncodedString()
    }
    
    static func string2Bytes(_ str: String) -> [UInt8] {
        let data = NSData.init(base64Encoded: str, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters)
        let bytes = [UInt8](data!)
        return bytes
    }
}
