//
//  JNPrint.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

func JNPrint(_ message: String) {
    #if DEBUG
    print("JNFoundation:", #file, #line, message)
    #endif
}
