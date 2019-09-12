//
//  ZFTextNetAFVC.swift
//  DevFramework
//
//  Created by 张志方 on 2019/5/21.
//  Copyright © 2019 志方. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ZFTestNetAFVC: UIViewController {
    var model = ZFMessageModel()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        model.fatchMessageData().subscribe (onNext:{(mod) in
            print(mod)
            },onError:{(error) in
                print(error)
            }).disposed(by: disposeBag)
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
