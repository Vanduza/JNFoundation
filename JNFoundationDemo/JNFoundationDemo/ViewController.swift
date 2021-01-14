//
//  ViewController.swift
//  JNFoundationDemo
//
//  Created by yangjing on 2020/6/8.
//  Copyright © 2020 vanduza. All rights reserved.
//

import UIKit
import RxSwift
import JNFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let selfDbPath = DemoPluginName.shared.getDB().getSelfDB().path
        print("SelfDBPath:",selfDbPath)
        
        LoginAPI.init(req: .init(userName: "张三", pwd: "123456")).send().subscribe { [weak self] (api: LoginAPI) in
            self?.configureLoginSuccess(response: api.response)
        } onError: { (error) in
            Toast.show(type: ToastType.error1(info: error))
        }.disposed(by: disposeBag)
    }
    
    func configureLoginSuccess(response: LoginAPI.Response?) {
        
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
     
    @IBAction func sendRequest(_ sender: UIButton) {
        self.navigationController?.pushViewController(NextViewController(), animated: true)
    }
    @IBAction func changeUserAction(_ sender: UIButton) {

    }
}

class Toast {
    static func show(type: ToastType) {
        
    }
}

enum ToastType {
    case error1(info: Error)
}
