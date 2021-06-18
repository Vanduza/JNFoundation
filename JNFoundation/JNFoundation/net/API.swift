//
//  API.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift

public protocol CodeResponsable: Decodable {
    var code: Int { get set }
    var message: String { get set }

    static func codeTokenExpired() -> Int
    static func codeSuccess() -> Int
}

public protocol APIRequest: AnyObject, Encodable {}

public protocol APIResponse: AnyObject, Decodable {}

public protocol API: AnyObject {
    associatedtype Request: APIRequest
    associatedtype Response: APIResponse
    var request: Request { get }
    var response: Response? { get set }
    var code: Int { get set }
    var token: String { get set }

    var nc: JNNotificationCenter { get }
    var mf: ModelFactory { get }
    var net: Net { get }
}

extension API {
    public var nc: JNNotificationCenter {
        return net.getPlugin().getNc()
    }

    public var mf: ModelFactory {
        return net.getPlugin().getMf()
    }
}

public protocol APIable: API {
    func send() -> Observable<Self>
    func getUrl() -> String
    func getHttpMethod() -> HttpMethod
    func parse(json: String) -> Observable<Void>
    func setModel(_ postModelEvent: Bool) -> Observable<Void>
    func processToken(_ response: String)
    func netStart()
    func netOver()

    var needSetModel: Bool { get }
    var useIpOrNot: Bool { get }
    var shouldPostModelEvent: Bool { get }
    var extraHeader: [String: String] { get }

    var needToken: Bool { get }
    var disposebag: DisposeBag { get }
}

extension APIable {
    public func getHttpMethod() -> HttpMethod {
        return .POST
    }

    public func netStart() {

    }

    public func netOver() {

    }
}

extension APIable {
    public func send() -> Observable<Self> {
        let ret = sendImpl()
        netStart()
        return ret
    }

    private func sendImpl() -> Observable<Self> {
        let token = net.getToken()
        self.token = token
        //如果正在登录，不执行网络请求，也不执行401
        if net.isLogin() {
            code = net.getHttpBuilder().codeResponseType.codeTokenExpired()
            return Observable<Self>.create { observer in
                observer.onError(Net.NetError.tokenExpired)
                observer.onCompleted()
                return Disposables.create()
            }
        }
        //如果需要token的接口，token为空，不执行网络请求
        if token.isEmpty, needToken {
            code = net.getHttpBuilder().codeResponseType.codeTokenExpired()
            //这里考虑异步执行
            net.set401(true)
            nc.post(Net.Net401Event.init(net: net))
            JPrint("token is empty")
            return Observable<Self>.create { observer in
                observer.onError(Net.NetError.tokenEmpty)
                observer.onCompleted()
                return Disposables.create()
            }
        }

        let url = net.getBaseUrl()+getUrl()

        return Observable<Self>.create { (observer) in
            self.net.getHttpBuilder()
                .setNeedToken(self.needToken)
                .setUseIpOrNot(self.useIpOrNot)
                .addHeader(keyValue: self.extraHeader)
                .setMethod(self.getHttpMethod())
                .setUrl(url)
                .setContent(JsonTool.toJson(fromObject: self.request)).build()
            .send().subscribe(onNext: { (response: String) in
                //此处不能弱引用self，避免API提前释放，API将在执行完请求的所有流程后释放
                let sself = self
                //netover是一个很重要的时序点，必须与processToken这个时序点在一个同步执行过程，失败也要标记
                sself.netOver()
                let codeResponseType = sself.net.getHttpBuilder().codeResponseType
                guard let res: CodeResponsable = JsonTool.fromJson(response, toClass: codeResponseType) else {
                    observer.onError(Net.NetError.decodeJsonError)
                    return
                }
                sself.code = res.code
                if sself.code == sself.net.getHttpBuilder().codeResponseType.codeTokenExpired() {
                    //返回401时，请求的token和现存token不一样，有登录接口修改，无法判断最新token是否过期，不能执行真正的401操作
                    let token = sself.token
                    if token != sself.net.getToken() {
                        observer.onError(Net.NetError.tokenExpired)
                        return
                    }
                    /* 执行真正的401操作
                    * 1.清除token，防止其他接口再发起需要token的请求
                     2.设置401状态，直到下次登录时或其他不需要token的接口返回时取消401
                     */
                    sself.net.setToken(Token.empty)
                    sself.net.set401(true)
                    if !sself.net.isLogin() {
                        sself.nc.post(Net.Net401Event.init(net: sself.net))
                    }
                    observer.onError(Net.NetError.tokenExpired)
                    return
                }

                //取消401
                sself.net.set401(false)

                if sself.code != sself.net.getHttpBuilder().codeResponseType.codeSuccess() {
                    let err = Net.NetError.networkError(error: res.message, code: sself.code)
                    observer.onError(err)
                    return
                }

                //给上层一次处理token的机会，解析数据时可能需要token
                sself.processToken(token)
                sself.parse(json: response).subscribe(onNext: { [weak sself] (_) in
                    guard let wself = sself else {
                        observer.onError(Net.NetError.apiReleased)
                        return
                    }
                    if wself.needSetModel {
                        _ = wself.setModel(wself.shouldPostModelEvent)
                    }
                    observer.onNext(wself)
                }, onError: { (err) in
                    observer.onError(err)
                }, onCompleted: {
                    observer.onCompleted()
                }).disposed(by: sself.disposebag)
            }, onError: { [weak self] (error) in
                self?.netOver()
                observer.onError(error)
            }, onCompleted: {
                observer.onCompleted()
            })
        }
    }
}

open class CodeResponse: CodeResponsable, Codable {
    public var message: String = ""

    open class func codeTokenExpired() -> Int {
        return 401
    }

    open class func codeSuccess() -> Int {
        return 200
    }

    public var code: Int = 200
}
