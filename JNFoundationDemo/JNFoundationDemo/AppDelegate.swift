//
//  AppDelegate.swift
//  JNFoundationDemo
//
//  Created by yangjing on 2020/6/8.
//  Copyright © 2020 vanduza. All rights reserved.
//

import UIKit

func JPrint(_ file: String = #file, _ line: Int = #line, items: Any...) {
    #if DEBUG
    let file = (file as NSString).lastPathComponent
    print(file, line, items)
    #endif
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        DemoPluginName.shared.setup()
        return true
    }

}

