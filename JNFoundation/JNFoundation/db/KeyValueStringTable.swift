//
//  KeyValueStringTable.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/9.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import WCDBSwift

public class KeyValueStringTable: TableAble {
    public struct Entity: TableCodable {
        var key: String
        var value: String
        
        public enum CodingKeys: String, CodingTableKey {
            public typealias Root = Entity;
            public static let objectRelationalMapping = TableBinding(CodingKeys.self);
            
            case key, value;
            
            public static var columnConstraintBindings: [CodingKeys: ColumnConstraintBinding]? {
                return [key: ColumnConstraintBinding(isPrimary: true)]
            }
        }
    }
    
    public var db: Database
    
    public var name: String
    
    public var version: Int
    
    
}
