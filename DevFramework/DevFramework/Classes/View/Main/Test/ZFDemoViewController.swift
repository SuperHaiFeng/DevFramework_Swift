//
//  ZFDemoViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFDemoViewController: ZFBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(navigationController?.childViewControllers.count ?? 0)"
        
    }

    @objc private func showNext(){
        let vc = ZFDemoViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension ZFDemoViewController {
    override func setupTableView() {
        super.setupTableView()
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "下一个", image: nil, horizontalAlignment: .right, target: self, action: #selector(showNext))
    }
}
