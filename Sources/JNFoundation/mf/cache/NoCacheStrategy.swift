//
//  NoCacheStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class NoCacheStrategy: CacheStrategy {
    public func clear() {
        // do nothing
    }

    public func adjust(byNewData newData: [String]) -> [String] {
        return []
    }
}
