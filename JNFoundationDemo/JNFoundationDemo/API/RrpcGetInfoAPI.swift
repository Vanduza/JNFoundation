//
//  RrpcGetInfoAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/23.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift
import JNFoundation

final class RrpcGetInfoAPI: DemoAPI, DemoAPIable {
    var request: Request
    
    var response: Response?
    
    init(request: Request) {
        self.request = request
    }
    
    func getUrl() -> String {
        return "GetDeviceStatus"
    }
    
    func parse(json: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func setModel(_ postModelEvent: Bool) -> Observable<Void> {
        return Observable.just(())
    }
    
    var net: Net {
        return DemoPluginName.shared.getRrpcNet()
    }
    
    override var needToken: Bool {
        return false
    }
}

extension RrpcGetInfoAPI {
    class Request: APIRequest {
        var token: String?
        var uuid: String?
        
        let DeviceName: String
        let ProductKey: String
        let RequestBase64Byte: String
        
        init(deviceName: String, productKey: String, requestBase64Byte: String) {
            DeviceName = deviceName
            ProductKey = productKey
            RequestBase64Byte = requestBase64Byte
        }
    }
    
    class Response: APIResponse {
        
    }
}
