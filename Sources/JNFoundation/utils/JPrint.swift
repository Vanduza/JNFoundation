//
//  JPrint.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public func JPrint(_ file: String = #file, _ line: Int = #line, items: Any...) {
    #if DEBUG
    let file = (file as NSString).lastPathComponent
    print(file, line, items)
    #endif
}
