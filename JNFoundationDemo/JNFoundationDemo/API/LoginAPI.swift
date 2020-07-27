//
//  LoginAPI.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

class LoginAPI {
    func login() {
        DemoPluginName.shared.getPlugin().getMf().getModel(Me.self).setUid("fakeUid")
        DemoPluginName.shared.getPlugin().getMf().getModel(Token.self).setToken("fakeToken", forUrl: DemoPluginName.BaseUrl)
    }
}
