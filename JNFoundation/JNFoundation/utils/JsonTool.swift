//
//  JsonTool.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import CleanJSON

struct JsonTool {
    static func fromJson<T: Decodable>(_ json: String, toClass: T.Type) -> T? {
        let decoder = CleanJSONDecoder()
        let DecodingErrorKey = "DecodingError:";
        do {
          let result = try decoder.decode(toClass, from: json.data(using: .utf8)!);
          return result;
        } catch DecodingError.dataCorrupted(let context) {
          debugPrint(DecodingErrorKey + context.debugDescription);
          return nil;
        } catch DecodingError.keyNotFound(_, let context) {
          debugPrint(DecodingErrorKey + context.debugDescription);
          return nil;
        } catch DecodingError.typeMismatch(_, let context) {
          debugPrint(DecodingErrorKey + context.debugDescription);
          return nil;
        } catch DecodingError.valueNotFound(_, let context) {
          debugPrint(DecodingErrorKey + context.debugDescription);
          return nil;
        } catch let error {
          debugPrint(DecodingErrorKey + error.localizedDescription);
          return nil;
        }
    }
    
    static func toJson<T: Encodable>(fromObject: T) -> String {
        let encoder = JSONEncoder();
        do {
            let data = try encoder.encode(fromObject)
            guard let json = String.init(data: data, encoding: .utf8) else {
                fatalError("check your data is endodable from utf8!")
            }
            return json
        } catch let err {
            JPrint(err)
            return ""
        }
    }
}
