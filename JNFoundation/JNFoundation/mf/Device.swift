//
//  Device.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import UIKit

open class Device: Model, ModelAble {

    enum Key: String {
        case uuid, deviceToken, telephone
    }

    public func getUUID() -> String {
        if let uuid = _uuid {
            return uuid
        }

        if let uuid = KeychainHelper().keychainQueryUUID() {
            return uuid
        }

        let uuid = UUID().uuidString

        if KeychainHelper().keychainSave(uuid: uuid) {
            _uuid = uuid
            return uuid
        }
        return "no_uuid"
    }

    public func getDeviceToken() -> String {
        if let token = _deviceToken {
            return token
        }

        if let token = _table.getValueBy(key: Key.uuid.rawValue) {
            _deviceToken = token
            return token
        }

        guard let token = _deviceToken else {
            fatalError("call \(self).setDeviceToken first!")
        }

        return token
    }

    public func setDeviceToken(token: String) {
        _table.set(value: token, forKey: Key.deviceToken.rawValue)
    }

    public func getDeviceInfo() -> String {
        let device: UIDevice = UIDevice.current
        //设备名称
        let name: String = device.name
        // 设备所有者
        let deviceModel: String = device.modelName
        // 设备型号
        let type: String = device.localizedModel
        // 获取本地化版本
        let systemName: String = device.systemName;       // 获取当前运行的系统
        let systemVersion: String = device.systemVersion; // 获取当前系统的版本

        return "\(systemName),\(type),\(deviceModel),\(systemVersion)---deviceName:\(name)"
    }

    public func getAllTables() -> [Table] {
        return [_table]
    }

    public var needClearWhenUidChanged: Bool = false

    private lazy var _table: KeyValueStringTable = KeyValueStringTable.init(onDB: self.shareDB, withName: "device")
    private var _uuid: String?
    private var _deviceToken: String?
}

extension UIDevice {
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }

        switch identifier {
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,3":
            return "iPhone SE (GSM+CDMA)"
        case "iPhone8,4":
            return "iPhone SE (GSM)"
        case "iPhone9,1":                               return "iPhone 7 (CDMA)"
        case "iPhone9,2":                               return "iPhone 7 Plus (CDMA)"
        case "iPhone9,3":                               return "iPhone 7 (GSM)"
        case "iPhone9,4":                               return "iPhone 7 Plus (GSM)"
        case "iPhone10,1":                              return "iPhone 8 (CDMA)"
        case "iPhone10,2":                              return "iPhone 8 Plus (CDMA)"
        case "iPhone10,3":                              return "iPhone X (CDMA)"
        case "iPhone10,4":                              return "iPhone 8 (GSM)"
        case "iPhone10,5":                              return "iPhone 8 Plus (GSM)"
        case "iPhone10,6":                              return "iPhone X (GSM)"
        case "iPhone11,2":                              return "iPhone XS"
        case "iPhone11,4":
            return "iPhone XS Max China"
        case "iPhone11,6":                              return "iPhone XS Max"
        case "iPhone11,8":
            return "iPhone XR"
        case "iPhone12,1":
            return "iPhone 11"
        case "iPhone12,3":
            return "iPhone 11 Pro"
        case "iPhone12,5":
            return "iPhone 11 Pro Max"
        case "iPhone12,8":
            return "iPhone SE 2nd Gen"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
}
