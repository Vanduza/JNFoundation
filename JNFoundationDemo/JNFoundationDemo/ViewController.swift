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
        let req = SinglePoemAPI.Request()
        SinglePoemAPI.init(request: req).send().subscribe(onNext: { [weak self] (api) in
            self?.resultLabel.text = api.response?.result
            }, onError: { (error) in
                JPrint(items: error)
        }).disposed(by: disposeBag)
    }
}

