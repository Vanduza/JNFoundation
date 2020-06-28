//
//  OverwriteMergeStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

final public class OverWriteMergeStrategy: MergeStrategy {
    public func mergeToOld<Item>(old: inout Item, new: Item) -> Bool where Item: ModelItem {
        if old == new {
            return false
        }

        old = new
        return true
    }
    public init() {}
}
