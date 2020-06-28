//
//  JoinMergeStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

final public class JoinMergeStrategy: MergeStrategy {
    public func mergeToOld<Item>(old: inout Item, new: Item) -> Bool where Item: ModelItem {
        if old == new {
            return false
        }

        var oldDic = try! old.toDictionary()
        let newDic = try! new.toDictionary()

        oldDic.merge(newDic) { (_, new) in new }

        old = try! Item.fromDictionary(oldDic)

        return true
    }

    public init() {}
}
