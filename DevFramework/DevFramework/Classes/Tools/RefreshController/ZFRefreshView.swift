//
//  ZFRefreshView.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/27.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFRefreshView: UIView {
    ///指示图片
    @IBOutlet weak var tipIcon: UIImageView!
    ///指示标签
    @IBOutlet weak var tipLabel: UILabel!
    ///指示器
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    ///刷新状态
    var refreshStatu: ZFRefreshStatu = .Normal {
        didSet{
            switch refreshStatu {
            case .Normal:
                tipIcon.isHidden = false
                indicator.stopAnimating()
                tipLabel.text = "继续使劲拉..."
                UIView .animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.identity
                })
            case .Pulling:
                tipLabel.text = "放手就刷新..."
                UIView.animate(withDuration: 0.25, animations: {
                    self.tipIcon.transform = CGAffineTransform.init(rotationAngle: CGFloat(M_PI - 0.001))
                })
            case .WillRefresh:
                tipLabel.text = "正在刷新中..."
                tipIcon.isHidden = true
                indicator.startAnimating()
            }
        }
    }
    
    class func refreshView() -> ZFRefreshView {
        let nib = UINib.init(nibName: "ZFRefreshView", bundle: nil)
        
        return nib.instantiate(withOwner: nib, options: [:])[0] as! ZFRefreshView
        
    }
}
