//
//  AppDelegate.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow()
        window?.backgroundColor = UIColor.white
        window?.rootViewController = ZFMainViewController()
        window?.makeKeyAndVisible()
        
        loadAppIfo()
        setupAdditions()
        return true
    }

}

///设置应用程序额外信息
extension AppDelegate {
    private func setupAdditions(){
        ///设置HUD最小解除时间
        SVProgressHUD.setMinimumDismissTimeInterval(1)
        ///设置网络加载指示器
        AFNetworkActivityIndicatorManager.shared().isEnabled = true
        ///取得用户授权显示通知（上方的提示条、声音、BadgeNumber）
        let notifySetting = UIUserNotificationSettings.init(types: [.alert,.sound,.badge], categories: nil)
        UIApplication.shared.registerUserNotificationSettings(notifySetting)
    }
}


// MARK: -模拟从服务器加载应用程序信息
extension AppDelegate {
    private func loadAppIfo() {
        DispatchQueue.global().async {
            let url = Bundle.main.url(forResource: "main.json", withExtension: nil)
            let data = NSData.init(contentsOf: url!)
            let jsonPath = ("main.json").zf_appendDocumentDir()
            print(jsonPath)
            ///直接保存到沙盒，等待程序下一次启动使用
            data?.write(toFile: jsonPath, atomically: true)
        }
    }
}

