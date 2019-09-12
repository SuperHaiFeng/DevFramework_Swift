//
//  ZFNavigationController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBar.isHidden = true
    }
    ///重写push方法
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        ///隐藏底部的bar
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            if let vc = viewController as? ZFBaseViewController {
                var title = "返回"
                if viewControllers.count == 1{
                    title = viewControllers.first?.title ?? "返回"
                }
                vc.navItem.leftBarButtonItem = UIBarButtonItem.init(title: title, image: UIImage.init(named: "back"), horizontalAlignment: .left, target: self, action: #selector(popToParent))
                
            }
        }
        
        
        super.pushViewController(viewController, animated: true)
        
    }
    
    @objc private func popToParent(){
        popViewController(animated: true)
    }

    func swapTwoValues<V>(a: inout V, b: inout V) {
        let tem = a
        a = b
        b = tem
    }

}
