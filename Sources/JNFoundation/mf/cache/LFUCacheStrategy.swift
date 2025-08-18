//
//  LFUCacheStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class LFUCacheStrategy: CacheStrategy {

    init(maxCount: Int = 1000) {
        self.maxCnt = max(5, maxCount)
        self.changeCnt = max(1, min(maxCount/10, maxCnt/2))
    }

    private var ids = [String: Int]()
    private let maxCnt: Int
    private let changeCnt: Int

    public func clear() {
        ids.removeAll()
    }

    public func adjust(byNewData newData: [String]) -> [String] {
        // 每访问一次id  对应的times加1
        for id in newData {
            ids[id] = (ids[id] ?? 0) + 1
        }

        if ids.count < maxCnt {
            return []
        }

        let sorted = ids.sorted { (first: (_: String, value: Int), second:(_: String, value: Int)) -> Bool in
            return first.value < second.value
        }

        var result = [String](repeating: "", count: changeCnt)
        for i in 0..<changeCnt {
            let id = sorted[i].key
            result[i] = id
            ids.removeValue(forKey: id)
        }

        return result
    }
}
