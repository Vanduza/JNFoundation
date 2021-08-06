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
        let right = UIBarButtonItem.init(title: "Post", style: .plain, target: self, action: #selector(postNotification))
        self.navigationItem.rightBarButtonItem = right
        DemoPluginName.shared.getPlugin().getNc().observeEvent(using: { [weak self] (event: DemoPluginName.DemoMockEvent) in
            self?.dealNotification(id: event.id)
        }).disposed(by: _disposeBag)
    }
    
    private func dealNotification(id: Int) {
        print("收到通知2:", id)
    }
    
    @objc func postNotification() {
        let event = DemoPluginName.DemoMockEvent.init(id: 123)
        DemoPluginName.shared.getNc().post(event)
    }
    
    deinit {
        #if DEBUG
        print("dealloc \(type(of: self))")
        #endif
    }

}
