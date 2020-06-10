//
//  JPrint.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

func JPrint(_ items: Any...) {
    #if DEBUG
    print(#file, #line, items)
    #endif
}
