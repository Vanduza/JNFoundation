//
//  GetDeviceInfoAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift

final class GetDeviceInfoAPI: DemoAPI, DemoAPIable {
    var request: Request
    
    var response: Response?
    
    init(request: Request) {
        self.request = request
    }
    
    func getUrl() -> String {
        return "RRpc"
    }
    
    func parse(json: String) -> Observable<Void> {
        return Observable.just(())
    }
    
    func setModel(_ postModelEvent: Bool) -> Observable<Void> {
        let fakeUser = UserModel.Item.init(id: "123", name: "小红", gender: 2)
        let ret = mf.getModel(UserModel.self).setItem(fakeUser)
        print("save success:\(ret)")
        return Observable.just(())
    }
    
    var net: Net {
        return DemoPluginName.shared.getRrpcNet()
    }
    
    override var needToken: Bool {
        return false
    }
    
    deinit {
        #if DEBUG
        print("dealloc \(type(of: self))")
        #endif
    }
}

extension GetDeviceInfoAPI {
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
        let code: Int
        let message: String
    }
}
