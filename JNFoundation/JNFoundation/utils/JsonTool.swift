//
//  JsonTool.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import CleanJSON

public struct JsonTool {
    public static func fromJson<T: Decodable>(_ json: String, toClass: T.Type) -> T? {
        let decoder = CleanJSONDecoder()
        do {
          let result = try decoder.decode(toClass, from: json.data(using: .utf8)!)
          return result
        } catch DecodingError.dataCorrupted(let context) {
            JPrint(items: context)
          return nil
        } catch DecodingError.keyNotFound(_, let context) {
            JPrint(items: context)
          return nil
        } catch DecodingError.typeMismatch(_, let context) {
          JPrint(items: context)
          return nil
        } catch DecodingError.valueNotFound(_, let context) {
          JPrint(items: context)
          return nil
        } catch let error {
          JPrint(items: error)
          return nil
        }
    }

    public static func toJson<T: Encodable>(fromObject: T) -> String {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(fromObject)
            guard let json = String.init(data: data, encoding: .utf8) else {
                fatalError("check your data is encodable from utf8!")
            }
            return json
        } catch let err {
            JPrint(items: err)
            return ""
        }
    }
}
