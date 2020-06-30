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
    private  static  let START_CHARGE: UInt8 = 0xC0;//开始充电
    private  static  let STOP_CHARGE: UInt8 = 0xC2;//停止充电
    private  static  let  CHANGE_INPUT_CHARGE: UInt8 = 0xC4;//更改电流
    private  static  let  CHANGE_WAITTIME_CHARGE: UInt8 = 0xC8;//更改预约时间
    private  static  let  GET_CHARGE_DATA: UInt8 = 0xA2;//获取所有电表参数
    private  static  let  GET_WARNING_DATA: UInt8 = 0xA4;//获取错误警告参数
    private  static  let  GET_DEVICE_DATA: UInt8 = 0xA6;// 获取所有充电器信息
    //其他数据位
    private  static  let CHARGE_TITLE: UInt8 = 0xA5
    private  static  let DATA_LENGTH_NONE: UInt8 = 0x00//数据为0
    private  static  let DATA_LENGTH: UInt8 = 0x00//数据为1
    //    private  static let status = "OFFLINE" //预定义设备状态
    private static let BITS_OF_BYTE: UInt8 = 8
    /**
     * 多项式
     */
    private static let POLYNOMIAL: UInt16 = 0xA001
    /**
     * 初始值
     */
    private static let INITIAL_VALUE: UInt16 = 0xFFFF
    static func getNoParamsCommand(_ command: Command) -> String {
        var result: String = ""
        var bytes: [UInt8] = []
        bytes.append(0xa5)
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(UInt8.random(in: 0...16))
        switch command {
            case .start:
                bytes.append(START_CHARGE)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .stop:
                bytes.append(STOP_CHARGE)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .charge_data:
                bytes.append(GET_CHARGE_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .warning_data:
                bytes.append(GET_WARNING_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(((key & 0xFF00) >> 8)))
                bytes.append(UInt8(((key & 0x00FF) << 8)))
                result = ByteHelper.bytes2String(bytes)
            case .device_data:
                bytes.append(GET_DEVICE_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(((key & 0xFF00) >> 8)))
                bytes.append(UInt8(((key & 0x00FF) << 8)))
                result = ByteHelper.bytes2String(bytes)
            default:
            break
        }
        return result
    }
    
    static func getChangeInput(current: UInt8) -> String {
        var result: String = ""
        var bytes: [UInt8] = []
        bytes.append(0xa5)
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(CHANGE_INPUT_CHARGE)
        bytes.append(0x01)
        bytes.append(current)//电流值，单位A
        let key = generateSecurityCode(bytes: bytes)
        bytes.append(UInt8((key & 0xFF00) >> 8))
        bytes.append(UInt8((key & 0x00FF) << 8))
        result = ByteHelper.bytes2String(bytes)
        return result
    }
    
    static func getChangeTime() -> String {
        var result: String = ""
        var bytes: [UInt8] = []
        bytes.append(0xa5)
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(CHANGE_WAITTIME_CHARGE)
        bytes.append(0x02)
        bytes.append(0)//低字节
        bytes.append(0x06)//高字节
        let key = generateSecurityCode(bytes: bytes)
        bytes.append(UInt8(((key & 0xFF00) >> 8)))
        bytes.append(UInt8(((key & 0x00FF) << 8)))
        result = ByteHelper.bytes2String(bytes)
        return result
    }
    
    static func transformCommandToBase64code(command: Command) -> String {
        var result: String = ""
        var bytes: [UInt8] = []
        bytes.append(0xa5)
        bytes.append(UInt8.random(in: 0...16))
        bytes.append(UInt8.random(in: 0...16))
        switch command {
            case .start:
                bytes.append(START_CHARGE)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .stop:
                bytes.append(STOP_CHARGE)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .change_input:
                bytes.append(CHANGE_INPUT_CHARGE)
                bytes.append(0x01)
                bytes.append(8)//电流值，单位A
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8((key & 0xFF00) >> 8))
                bytes.append(UInt8((key & 0x00FF) << 8))
                result = ByteHelper.bytes2String(bytes)
            case .change_time:
                bytes.append(CHANGE_WAITTIME_CHARGE)
                bytes.append(0)
                bytes.append(0x02)
                bytes.append(0)//低字节
                bytes.append(0x06)//高字节
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(((key & 0xFF00) >> 8)))
                bytes.append(UInt8(((key & 0x00FF) << 8)))
                result = ByteHelper.bytes2String(bytes)
            case .charge_data:
                bytes.append(GET_CHARGE_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(key & 0x00FF))
                bytes.append(UInt8((key & 0xFF00) >> 8))
                result = ByteHelper.bytes2String(bytes)
            case .warning_data:
                bytes.append(GET_WARNING_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(((key & 0xFF00) >> 8)))
                bytes.append(UInt8(((key & 0x00FF) << 8)))
                result = ByteHelper.bytes2String(bytes)
            case .device_data:
                bytes.append(GET_DEVICE_DATA)
                bytes.append(0)
                let key = generateSecurityCode(bytes: bytes)
                bytes.append(UInt8(((key & 0xFF00) >> 8)))
                bytes.append(UInt8(((key & 0x00FF) << 8)))
                result = ByteHelper.bytes2String(bytes)
        }
        return result
    }
    
    private static func generateSecurityCode(bytes: [UInt8]) -> UInt16 {
        var res = INITIAL_VALUE
        for val in bytes {
            res = res ^ UInt16(val)
            for _ in 0..<BITS_OF_BYTE {
                res = (res & 0x0001) == 1 ? (res >> 1) ^ POLYNOMIAL : res >> 1
            }
        }
        return res
    }
    
    func parsePayloadBase64Byte(string: String) {
        let a = ByteHelper.string2Bytes(string)
        //在线
        guard a.count >= 37 else { return }
        let ontime_current = String(((a[9]&0xff)+(a[11]&0xff)+(a[13]&0xff))/3) + "A"
        let total_power = String(a[27]&0xff)
        let voltage = String(a[9]&0xff)
        let q_charge = String(a[27]&0xff)
        let charge_time = String(a[31]&0xff) + "s"
        let temperature = String(a[28]&0xff) + "℃"
        let a_voltage = String(a[15]&0xff) + "V"
        let b_voltage = String(a[17]&0xff) + "V"
        let c_voltage = String(a[19]&0xff) + "V"
        let a_current = String(a[9]&0xff) + "A"
        let b_current = String(a[11]&0xff) + "A"
        let c_current = String(a[13]&0xff) + "A"
        let a_power = String(a[21]&0xff) + "kw"
        let b_power = String(a[23]&0xff) + "kw"
        let c_power = String(a[25]&0xff) + "kw"
        print(ontime_current,total_power,voltage, q_charge, charge_time, temperature, a_voltage, b_voltage, c_voltage, a_current,b_current,c_current,a_power,b_power,c_power)
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
