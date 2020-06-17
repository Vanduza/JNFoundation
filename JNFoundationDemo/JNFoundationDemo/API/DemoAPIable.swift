//
//  DemoAPIable.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/15.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift

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

class DemoAPI {
    func processToken(_ response: String) { }
    
    var needSetModel: Bool {
        return true
    }
    
    var shouldPostModelEvent: Bool {
        return true
    }
    
    var disposebag: DisposeBag = DisposeBag()
    
    var needToken: Bool {
        return true
    }
    
    var code: APICode = .ELSE_ERROR
}
