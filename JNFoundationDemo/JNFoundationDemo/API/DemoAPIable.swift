//
//  DemoAPIable.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/15.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation

public protocol DemoAPIable: APIable {}

extension DemoAPIable {
    public var net: Net {
        return DemoPluginName.shared.getNet()
    }
    
    public var nc: JNNotificationCenter {
        return DemoPluginName.shared.getNc()
    }
    
    public var mf: ModelFactory {
        return DemoPluginName.shared.getMf()
    }
    
    public func getHttpMethod() -> HttpMethod {
        return .POST
    }
    
    public var needToken: Bool {
        return true
    }
}
