//
//  ViewController.swift
//  JNFoundationDemo
//
//  Created by yangjing on 2020/6/8.
//  Copyright © 2020 vanduza. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        LoginAPI().login()
        DemoPluginName.shared.getNc().addObserver(self) { (event:SearchAuthorAPI.SubEvent) in
            print("收到通知")
        }
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
     
    @IBAction func sendRequest(_ sender: UIButton) {
//        GetChargeDataAPI.init(request: GetChargeDataAPI.Request.init(deviceId: "")).send().subscribe(onNext: { (api) in
//
//        }, onError: { (err) in
//            JPrint(items: err)
//        }).disposed(by: disposeBag)
        _ = SearchAuthorAPI.init(request: SearchAuthorAPI.Request.init(name: "libai")).send().subscribe()
    }
}
