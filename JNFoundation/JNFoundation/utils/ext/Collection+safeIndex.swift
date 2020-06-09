//
//  Collection+safeIndex.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

extension Collection {
    subscript(safe index: Self.Index) -> Self.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
