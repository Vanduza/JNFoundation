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
        DemoPluginName.shared.getNc().addObserver(self) { (event:SearchAuthorAPI.SubEvent) in
            print("收到通知")
        }
    }

    @IBOutlet weak var resultLabel: UILabel!
    
    private let disposeBag: DisposeBag = DisposeBag()
     
    @IBAction func sendRequest(_ sender: UIButton) {
        
    }
    @IBAction func changeUserAction(_ sender: UIButton) {

    }
}
