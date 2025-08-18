//
//  LRUCacheStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class LRUCacheStrategy: CacheStrategy {

    init(maxCount: Int = 1000) {
        self.maxCnt = max(5, maxCount)
        self.changeCnt = max(1, min(maxCount/10, maxCnt/2))
    }

    private let maxCnt: Int
    private let changeCnt: Int
    private var time: Int = 0
    private var ids: [String: Int] = [:]

    public func clear() {
        ids.removeAll()
    }

    public func adjust(byNewData newData: [String]) -> [String] {
        // 最近访问的id 对应的time值越大
        for id in newData {
            ids[id] = time
            time += 1
        }

        if ids.count < maxCnt {
            return []
        }

        let sorted = ids.sorted { (left: (_: String, value: Int), right:(_: String, value: Int)) -> Bool in
            return left.value < right.value
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
