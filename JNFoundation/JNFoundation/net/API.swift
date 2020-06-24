//
//  API.swift
//  JNFoundation
//
//  Created by 杨敬 on 2020/6/12.
//  Copyright © 2020 vanduza. All rights reserved.
//

import Foundation
import RxSwift

public enum APICode: Int {
    case SUCCESS = 200
    case TOKEN_EXPIRE_CODE = 401
    case NOT_MODIFIED = 304
    case SERVER_ERROR = 500
    case ELSE_ERROR = 501
}

public protocol APIRequest: class, Encodable {
    var token: String? { get set }
    var uuid: String? { get set }
}

public protocol APIResponse: class, Decodable {}

public protocol API: class {
    associatedtype Request: APIRequest
    associatedtype Response: APIResponse
    var request: Request { get }
    var response: Response? { get set }
    var code: APICode { get set }

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

    var needSetModel: Bool { get }
    var shouldPostModelEvent: Bool { get }

    var needToken: Bool { get }
    var disposebag: DisposeBag { get }
}

extension APIable {
    public func getHttpMethod() -> HttpMethod {
        return .POST
    }
}

extension APIable {
    public func send() -> Observable<Self> {
        return sendImpl()
    }

    private func sendImpl() -> Observable<Self> {
        let token = net.getToken()
        self.request.token = token
        self.request.uuid = mf.getModel(Device.self).getUUID()
        //如果正在登录，不执行网络请求，也不执行401
        if net.isLogin() {
            code = .TOKEN_EXPIRE_CODE
            return Observable.just(self)
        }
        //如果需要token的接口，token为空，不执行网络请求
        if token.isEmpty, needToken {
            code = .TOKEN_EXPIRE_CODE
            //这里考虑异步执行
            net.set401(true)
            nc.post(Net.Net401Event.init(net: net))
            JPrint("token is empty")
            return Observable.just(self)
        }

        let url = net.getBaseUrl()+getUrl()

        return Observable<Self>.create { (observer) in
            self.net.getHttpBuilder()
                .setNeedToken(self.needToken)
                .setMethod(self.getHttpMethod())
            .setUrl(url)
                .setContent(JsonTool.toJson(fromObject: self.request)).build()
            .send().subscribe(onNext: { (response: String?) in
                //此处不能弱引用self，避免API提前释放，API将在执行完请求的所有流程后释放
                let sself = self

                guard let response = response else {
                    observer.onError(Net.NetError.responseEmpty)
                    return
                }

                let res: _ResponseCode? = JsonTool.fromJson(response, toClass: _ResponseCode.self)
                sself.code = res?.code ?? APICode.ELSE_ERROR
                if sself.code == .TOKEN_EXPIRE_CODE {
                    //返回401时，请求的token和现存token不一样，有登录接口修改，无法判断最新token是否过期，不能执行真正的401操作
                    let token = sself.request.token ?? Token.empty
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

                if sself.code != .SUCCESS, sself.code != .NOT_MODIFIED {
                    observer.onError(Net.NetError.decodeJsonError)
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
            }, onError: { (error) in
                observer.onError(error)
            }, onCompleted: {
                observer.onCompleted()
            })
        }
    }
}

private struct _ResponseCode: Decodable {
    init(from decoder: Decoder) throws {
        do {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            let codeV = try values.decode(Int.self, forKey: .code)
            code = APICode.init(rawValue: codeV) ?? APICode.ELSE_ERROR
            message = try? values.decode(String.self, forKey: .message)
        } catch let err as DecodingError {
            JPrint(items: err)
        }
    }

    enum CodingKeys: String, CodingKey {
        case code, message
    }

    var code: APICode = .ELSE_ERROR
    var message: String?
}
