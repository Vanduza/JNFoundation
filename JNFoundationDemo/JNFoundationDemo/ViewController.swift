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
//        let selfDbPath = DemoPluginName.shared.getDB().getSelfDB().path
//        print("SelfDBPath:",selfDbPath)
        
        LoginAPI.init(req: .init(userName: "张三", pwd: "123456")).send().subscribe { [weak self] (api: LoginAPI) in
            guard let resp = api.response else { return }
            self?.configureLoginSuccess(response: resp)
        } onError: { (error) in
            Toast.show(type: ToastType.error1(info: error))
        }.disposed(by: disposeBag)
        let right = UIBarButtonItem.init(title: "Post", style: .plain, target: self, action: #selector(postNotification))
        self.navigationItem.rightBarButtonItem = right
        DemoPluginName.shared.getPlugin().getNc().observeEvent(using: { (event: DemoPluginName.DemoMockEvent) in
            print("收到通知:", event.id)
        }).disposed(by: disposeBag)
        
        DemoPluginName.shared.getNc().observeEvents([DemoPluginName.DemoMockEvent.self, LoginAPI.LoginEvent.self]) {
            print("收到通知2")
        }.disposed(by: disposeBag)
    }
    
    func configureLoginSuccess(response: LoginAPI.Response) {
        
    }
    
    @objc func postNotification() {
        let event = DemoPluginName.DemoMockEvent.init(id: 123)
        DemoPluginName.shared.getNc().post(event)
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

class Person: Decodable {
    let isMale: Bool
}
