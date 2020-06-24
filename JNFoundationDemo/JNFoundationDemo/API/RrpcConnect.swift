//
//  RrpcConnect.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2020/6/23.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import JNFoundation
import RxSwift
import Alamofire

class RrpcConnect: HttpString {
    
    private let accessSecret = "123"
    private let accessKeyId = "1234"
    
    required init(builder: PostStringHttpBuilder) {
        _builder = builder
    }
    
    func send() -> Observable<String?> {
        let headersMap = ["Content-Type":"application/json; charset=utf-8","Accept":"application/json,text/json,text/javascript,text/html"]
        let combineHeaders = headersMap.merging(self._builder.getAllHeaders()) { $1 }
        let fullUrl = DemoPluginName.RrpcBaseUrl + generateCommomParam()
        JPrint(items: "fullUrl:\(fullUrl)")
        let req = try! URLRequest.init(url: fullUrl, method: .post, headers: combineHeaders)
        
        return Observable<String?>.create { (observer) in
            let dataRequest = Alamofire.request(req).responseString { (response: DataResponse<String>) in
                if let err = response.error {
                    observer.onError(err)
                    return
                }
                
                if let data = response.data {
                    let json = String.init(data: data, encoding: .utf8)
                    observer.onNext(json)
                }
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    private func generateCommomParam() -> String {
        let reqDic: [String: String]? = try? JSONSerialization.jsonObject(with: _builder.getContent().data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String: String]
        
        var dic: [CommonKey: String] = [:]
        let uri = (_builder.getUrl() as NSString).lastPathComponent
        dic[.Action] = "RRpc"//uri
        dic[.Format] = "JSON"
        dic[.RegionId] = "cn-shanghai"
//        dic[.SecureTransport] = "true"
        dic[.SignatureMethod] = "HMAC-SHA1"
        dic[.SignatureNonce] = "90901d50-b5c5-11ea-bd81-95f8a46056b4"//UUID().uuidString
        dic[.SignatureVersion] = "1.0"
//        dic[.SourceIp] = NetTool().ipAddress()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss'Z'"
        dic[.Timestamp] = encodeURL(string: "2020-06-24T02:51:12Z")//formatter.string(from: Date())
        dic[.Version] = "2018-01-20"
        dic[.Timeout] = "8000"
        dic[.DeviceName] = reqDic?[CommonKey.DeviceName.rawValue]
        dic[.ProductKey] = reqDic?[CommonKey.ProductKey.rawValue]
        dic[.RequestBase64Byte] = reqDic?[CommonKey.RequestBase64Byte.rawValue]
        dic[.AccessKeyId] = accessKeyId
        let paramString = transform(keyvalues: sortKeysOf(dic: dic))
        let signatue = getSignature(paramString, with: accessSecret)
        let result = "?Signature=\(signatue)" + paramString
        return result
    }
    
    /// 步骤1：将字典的key按字母升序排列
    /// - Parameter dic: 原字典
    /// - Returns: 键值对数组
    private func sortKeysOf(dic: [CommonKey: String]) -> [(CommonKey, String)] {
        let newDicArray = dic.sorted(by: { $0.key.rawValue < $1.key.rawValue })
        JPrint(items: "排序后的键值对:\n")
        newDicArray.forEach { (tuple: (key: CommonKey, value: String)) in
            print(tuple.key.rawValue + "=" + tuple.value)
        }
        return newDicArray
    }
    
    /// 步骤2：将已排序的键值对转换成query字符串，并替换特殊字符(replace("+", "%20").replace("*", "%2A").replace("%7E", "~"))
    /// - Parameter keyvalues: 已排序的键值对数组
    /// - Returns: 转换好的query字符串
    private func transform(keyvalues: [(CommonKey, String)]) -> String {
        var str: String = ""
        for keyvalue in keyvalues {
            str.append("&")
            str.append(keyvalue.0.rawValue)
            str.append("=")
            str.append(keyvalue.1)
        }
        let percentStr = str.dropFirst()
        print("percentStr:\(percentStr)")
        let header = "POST&%2F&"
        let string = encodeURL(string: String(percentStr))
        let result = header + string
        print(result)
        return result
    }
    
    private func encodeURL(string: String) -> String {
        let result = string.addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "!*'();:@&=+$,/?%#[]").inverted)?.replacingOccurrences(of: "+", with: "%20").replacingOccurrences(of: "*", with: "%2A").replacingOccurrences(of: "%7E", with: "~")
        return result ?? ""
    }
    
    /// 步骤3：获取已就绪的请求字符串签名
    /// - Parameters:
    ///   - content: 已经排序和转换的字符串
    ///   - key: 秘钥
    /// - Returns: 签名
    private func getSignature(_ content: String, with key: String) -> String {
        let trueKey = key + "&"
        return content.hmac(algorithm: .SHA1, key: trueKey)
    }
    
    private let _builder: PostStringHttpBuilder
    
    private enum CommonKey: String {
        case Action,
        AccessKeyId,
        DeviceName,
        Format,
        ProductKey,
        RegionId,
        SecureTransport,
        SignatureMethod,
        SignatureNonce,
        SignatureVersion,
        SourceIp,
        Timestamp,
        Version,
        Signature,
        Timeout,
        RequestBase64Byte
    }
}
class RrpcHttpBuilder: PostStringHttpBuilder {
    func build() -> HttpString {
        let connect = RrpcConnect.init(builder: self)
        return connect
    }
    
    func setUrl(_ url: String) -> PostStringHttpBuilder {
        _url = url
        return self
    }
    
    func getUrl() -> String {
        return _url
    }
    
    func setMethod(_ method: HttpMethod) -> PostStringHttpBuilder {
        _method = method
        return self
    }
    
    func getMethod() -> HttpMethod {
        return _method
    }
    
    func addHeader(key: String, value: String) -> PostStringHttpBuilder {
        _header[key] = value
        return self
    }
    
    func getHeader(key: String) -> String? {
        return _header[key]
    }
    
    func getAllHeaders() -> [String: String] {
        return _header
    }
    
    func setContent(_ content: String) -> PostStringHttpBuilder {
        _body = content
        return self
    }
    
    func getContent() -> String {
        return _body
    }
    
    func setNeedToken(_ needToken: Bool) -> PostStringHttpBuilder {
        _needToken = needToken
        return self
    }
    
    func getIsNeedToken() -> Bool {
        return _needToken
    }
    
    init() {}
    
    private var _url: String = ""
    private var _header: [String: String] = [:]
    private var _body: String = ""
    private var _method: HttpMethod = .POST
    private var _needToken = false
}
