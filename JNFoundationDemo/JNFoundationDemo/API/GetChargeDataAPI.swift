//
//  GetChargeDataAPI.swift
//  Khons
//
//  Created by 杨敬 on 2020/6/29.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

final class GetChargeDataAPI: DemoAPI, DemoAPIable {
    var request: Request
    var response: Response?
    init(request: Request) {
        self.request = request
    }

    func getUrl() -> String {
        return ""
    }
}

extension GetChargeDataAPI {
    class Request: APIRequest {
        var token: String?
        var uuid: String?

        //此Key值与RrpcConnect中的CommonKey的Key值对应
        let RequestBase64Byte = Command.charge_data.rawValue
        let DeviceId: String
        init(deviceId: String) {
            self.DeviceId = deviceId
        }
    }

    class Response: APIResponse {

    }
}
