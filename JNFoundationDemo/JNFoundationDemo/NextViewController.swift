//
//  NextViewController.swift
//  JNFoundationDemo
//
//  Created by 杨敬 on 2021/1/14.
//  Copyright © 2021 vanduza. All rights reserved.
//

import UIKit
import JNFoundation
import RxSwift

class NextViewController: UIViewController {
    private let _disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        DemoPluginName.shared.getPlugin().getNc().addObserver(self) { (event: LoginAPI.LoginEvent) in
            print("收到通知:", event.token)
        }.disposed(by: _disposeBag)
        
        SearchAuthorAPI.init(request: .init(name: "李白")).send().subscribe { (api: SearchAuthorAPI) in
            print(api.response?.result ?? "")
        }.disposed(by: _disposeBag)
    }
    

    deinit {
        #if DEBUG
        print("dealloc \(type(of: self))")
        #endif
    }

}
