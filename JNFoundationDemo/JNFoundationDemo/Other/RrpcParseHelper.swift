//
//  RrpcParseHelper.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/30.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

struct RrpcParseHelper {
    static func parsePayloadBase64Byte(string: String) {
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
