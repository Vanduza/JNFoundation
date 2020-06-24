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
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBAction func sendRequest(_ sender: UIButton) {
        let req = SearchAuthorAPI.Request.init(name: "李白")
        SearchAuthorAPI.init(request: req).send().subscribe(onNext: { [weak self] (api) in
            self?.resultLabel.text = api.response?.result
            }, onError: { (error) in
                JPrint(items: error)
        }).disposed(by: disposeBag)
        
//        let req = RrpcGetInfoAPI.Request.init(deviceName: "Dev001", productKey: "a1blwzzltJu", requestBase64Byte: "charge_data")
//        RrpcGetInfoAPI.init(request: req).send().subscribe(onNext: { (api) in
//
//            }).disposed(by: disposeBag)
    }
}

