//
//  RXCircleVC.swift
//  DevFramework
//
//  Created by 张志方 on 2018/10/30.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Foundation

class RXCircleVC: UIViewController {
    var circleView : UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUp()
    }
    
    func setUp() {
        circleView = UIView.init(frame: CGRect(origin: view.center, size: CGSize(width: 100.0, height: 100.0)))
        circleView.center = view.center
        circleView.layer.cornerRadius = circleView.frame.width/2.0
        circleView.backgroundColor = UIColor.green
        view.addSubview(circleView)
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(circleMoved(_:)))
        circleView.addGestureRecognizer(gesture)
        
    }
    @objc func circleMoved(_ recognize:UIPanGestureRecognizer) {
        let location = recognize.location(in: view)
        UIView.animate(withDuration: 0.1) {
            self.circleView.center = location
        }
    }

}


class CircleViewModel {
}
