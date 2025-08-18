//
//  NSObject+className.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

extension NSObject {
    class var className: String {
        return String.init(describing: self)
    }
}
