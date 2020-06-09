//
//  Me.swift
//  JNFoundation
//
//  Created by yangjing on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation

public class Me: ModelAble {
    public required init(plugin: Plugin) {
        _plugin = plugin
    }
    
    public func getAllTables() -> [Table] {
        <#code#>
    }
    
    private let _plugin: Plugin
    
    private let _table: KeyValueStringTable = KeyValueStringTable(onDB: shareDB, withName: "me")
}
