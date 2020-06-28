//
//  MergeStrategy.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/28.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public protocol MergeStrategy {
    func mergeToOld<Item: ModelItem>(old: inout Item, new: Item) -> Bool
}
