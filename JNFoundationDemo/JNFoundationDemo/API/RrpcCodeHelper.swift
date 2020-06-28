//
//  RrpcCodeHelper.swift
//  Khons
//
//  Created by 杨敬 on 2020/6/26.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
struct RrpcCodeHelper {
    //硬件通信协议
    //16进制 帧头(0xA5)  +  序号 + 命令号（0x00~0xF2） +  长度字节    +   数据 +  校验
    //输入命令
    private  static  let START_CHARGE: UInt16 = 0xC0;//开始充电
    private  static  let STOP_CHARGE: UInt16 = 0xC2;//停止充电
    private  static  let  CHANGE_INPUT_CHARGE: UInt16 = 0xC4;//更改电流
    private  static  let  CHANGE_WAITTIME_CHARGE: UInt16 = 0xC8;//更改预约时间
    private  static  let  GET_CHARGE_DATA: UInt16 = 0xA2;//获取所有电表参数
    private  static  let  GET_WARNING_DATA: UInt16 = 0xA4;//获取错误警告参数
    private  static  let  GET_DEVICE_DATA: UInt16 = 0xA6;// 获取所有充电器信息
    //其他数据位
    private  static  let CHARGE_TITLE: UInt16 = 0xA5
    private  static  let DATA_LENGTH_NONE: UInt16 = 0x00//数据为0
    private  static  let DATA_LENGTH: UInt16 = 0x00//数据为1
//    private  static let status = "OFFLINE" //预定义设备状态
    private static let BITS_OF_BYTE: UInt16 = 8
    /**
     * 多项式
     */
    private static let POLYNOMIAL: UInt16 = 0xA001
    /**
     * 初始值
     */
    private static let INITIAL_VALUE: UInt16 = 0xFFFF

    static func transformCommandToBase64code(command: Command) -> String {
        var result: String = ""
        var bytes: [UInt16] = []
//        bytes[0] = 0xa5
        bytes.append(0xa5)
//        bytes[1] = UInt16.random(in: 0...16)
        bytes.append(UInt16.random(in: 0...16))
//        bytes[2] = UInt16.random(in: 0...16)
        bytes.append(UInt16.random(in: 0...16))
        switch command {
        case .start:
            bytes[3] = START_CHARGE
            bytes[4] = 0x00
            let key = generateSecurityCode(bytes: bytes)
            bytes[5] = key & 0x00FF
            bytes[6] = (key & 0xFF00) >> 8
            result = ByteHelper.bytes2String(bytes)
        case .stop:
            bytes[3] = STOP_CHARGE
            bytes[4] = 0x00
            let key = generateSecurityCode(bytes: bytes)
            bytes[5] = key & 0x00FF
            bytes[6] = (key & 0xFF00) >> 8
            result = ByteHelper.bytes2String(bytes)
        case .change_input:
            bytes[3] = CHANGE_INPUT_CHARGE
            bytes[4] = 0x01
            bytes[5] = 0x08//电流值，单位A
            let key = generateSecurityCode(bytes: bytes)
            bytes[6] = (key & 0xFF00) >> 8
            bytes[7] = (key & 0x00FF) << 8
            result = ByteHelper.bytes2String(bytes)
        case .change_time:
            bytes[3] = CHANGE_WAITTIME_CHARGE
            bytes[5] = 0x02
            bytes[6] = 0x00;//低字节
            bytes[7] = 0x06;//高字节
            let key = generateSecurityCode(bytes: bytes)
            bytes[8] = ((key & 0xFF00) >> 8)
            bytes[9] = ((key & 0x00FF) << 8)
            result = ByteHelper.bytes2String(bytes)
        case .charge_data:
//            bytes[3] = GET_CHARGE_DATA
            bytes.append(GET_CHARGE_DATA)
//            bytes[4] = 0x00
            bytes.append(0)
            let key = generateSecurityCode(bytes: bytes)
//            bytes[5] = key & 0x00FF
            bytes.append(key & 0x00FF)
//            bytes[6] = (key & 0xFF00) >> 8
            bytes.append((key & 0xFF00) >> 8)
            result = ByteHelper.bytes2String(bytes)
        case .warning_data:
            bytes[3] = GET_WARNING_DATA
            bytes[4] = 0x00
            let key = generateSecurityCode(bytes: bytes)
            bytes[5] = ((key & 0xFF00) >> 8)
            bytes[6] = ((key & 0x00FF) << 8)
            result = ByteHelper.bytes2String(bytes)
        case .device_data:
            bytes[3] = GET_DEVICE_DATA
            bytes[4] = 0x00
            let key = generateSecurityCode(bytes: bytes)
            bytes[5] = ((key & 0xFF00) >> 8)
            bytes[6] = ((key & 0x00FF) << 8)
            result = ByteHelper.bytes2String(bytes)
        }
        return result
    }

    private static func generateSecurityCode(bytes: [UInt16]) -> UInt16 {
        var res = INITIAL_VALUE
        for val in bytes {
            res = res ^ val
            for _ in 0..<BITS_OF_BYTE {
                res = (res & 0x0001) == 1 ? (res >> 1) ^ POLYNOMIAL : res >> 1
            }
        }
        return res
    }
}

enum Command: String {
    case start//开始充电
    case stop//停止充电
    case change_input//修改电流
    case change_time//修改预约时间
    case charge_data//获取电表参数
    case warning_data//获取错误
    case device_data//获取充电器信息
}
