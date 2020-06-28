//
//  PostStringHttpBuilder.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/10.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift

public protocol HttpString {
    init(builder: PostStringHttpBuilder)
    func send() -> Observable<String?>
}

public enum HttpMethod: String {
    case POST, GET
}

public protocol PostStringHttpBuilder {
    func build() -> HttpString

    func setUrl(_ url: String) -> PostStringHttpBuilder
    func getUrl() -> String

    func setMethod(_ method: HttpMethod) -> PostStringHttpBuilder
    func getMethod() -> HttpMethod

    func addHeader(key: String, value: String) -> PostStringHttpBuilder
    func getHeader(key: String) -> String?
    func getAllHeaders() -> [String: String]

    func setContent(_ content: String) -> PostStringHttpBuilder
    func getContent() -> String

    func setNeedToken(_ needToken: Bool) -> PostStringHttpBuilder
    func getIsNeedToken() -> Bool

    func getCodeResponseType() -> CodeResponse.Protocol?
}
