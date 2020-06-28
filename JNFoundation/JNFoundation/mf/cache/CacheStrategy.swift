//
//  CacheStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public protocol CacheStrategy: class {
    func clear()
    func adjust(byNewData newData: [String]) -> [String]
}
