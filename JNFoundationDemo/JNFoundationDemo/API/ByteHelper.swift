//
//  ByteHelper.swift
//  ComponentsLibrary
//
//  Created by 杨敬 on 2020/6/26.
//  Copyright © 2020 杨敬. All rights reserved.
//

import Foundation

struct ByteHelper {
    private static let BITS_OF_BYTE: UInt8 = 8
    /**
     * 多项式
     */
    private static let POLYNOMIAL: UInt16 = 0xA001
    /**
     * 初始值
     */
    private static let INITIAL_VALUE: UInt16 = 0xFFFF
    
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

    static func bytes2String(_ bs: [UInt8]) -> String {
        return Data.init(bytes: bs, count: bs.count).base64EncodedString()
    }
    
    static func string2Bytes(_ str: String) -> [UInt8] {
        if let data = NSData.init(base64Encoded: str, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
            return [UInt8](data)
        }
        return []
    }
    /**
     * CRC16 编码
     *
     * @param bytes 编码内容
     * @return 编码结果
     */
    static func crc16(bytes: [UInt8]) -> UInt16 {
        var res = INITIAL_VALUE
        for val in bytes {
            res = res ^ UInt16(val)
            for _ in 0..<BITS_OF_BYTE {
                res = (res & 0x0001) == 1 ? (res >> 1) ^ POLYNOMIAL : res >> 1
            }
        }
        return revert(src: res)
    }
    /**
     * 翻转16位的高八位和低八位字节
     *
     * @param src 翻转数字
     * @return 翻转结果
     */
    static func revert(src: UInt16) -> UInt16 {
        let lowByte = (src & 0xFF00) >> 8
        let highByte = (src & 0x00FF) << 8
        print("##########lowByte######\(lowByte)");
        print("##########highByte######\(highByte)");
        print(lowByte | highByte);
        print("##########highByte######\(highByte)");
        return lowByte | highByte;
    }
    
    /**
     * 将整数转换为byte数组并指定长度
     */
    static func intToBytes(value: Int) -> [UInt8] {
        return [UInt8.init(truncatingIfNeeded: value), UInt8.init(truncatingIfNeeded: value >> 8)]
    }
    
    static func getCRC(bytes: [UInt8]) -> String {
        var CRC = 0x0000ffff;
        let POLYNOMIAL = 0x0000a001;
        
        for i in 0..<bytes.count {
            CRC ^= (Int(bytes[i]) & 0x000000ff);
            for _ in 0..<8 {
                if ((CRC & 0x00000001) != 0) {
                    CRC >>= 1;
                    CRC ^= POLYNOMIAL;
                } else {
                    CRC >>= 1;
                }
            }
        }
        return String.init(format: "%02X", CRC)
    }
}
