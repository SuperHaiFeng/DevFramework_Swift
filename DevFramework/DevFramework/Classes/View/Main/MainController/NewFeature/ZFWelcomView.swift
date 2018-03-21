//
//  ZFWelcomView.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/11.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import SDWebImage

class ZFWelcomView: UIView, NibLoadable {
    
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var tipLabel: UILabel!
    
    @IBOutlet weak var bottomCons: NSLayoutConstraint!
    
    @IBOutlet weak var iconWidth: NSLayoutConstraint!
    override func awakeFromNib() {
        
        guard let urlString = ZFNetworkManager.shared().userAccount.avatar_large,
            let url = URL(string: urlString) else{
                return
        }
        
        ///设置头像
        iconImage.sd_setImage(with: url, placeholderImage: UIImage(named:"tabbar_me"))
        iconImage.layer.cornerRadius = iconWidth.constant / 2
        iconImage.layer.masksToBounds = true
    }
    
    ///视图被添加到window上，表示视图已经显示
    override func didMoveToWindow() {
        super.didMoveToWindow()
        ///视图是使用自动布局设置的,只是设置了约束，当天家到视图上时，根据父视图的大小，计算约束值，更新控件位置
        
        self.layoutIfNeeded()
        bottomCons.constant = bounds.size.height - 200
        ///如果控件们的frame还没计算好，所有的约束一起动画
        UIView.animate(withDuration: 1.0,
                       delay: 0.5,
                       usingSpringWithDamping: 0.7,
                       initialSpringVelocity: 0,
                       options: [],
                       animations: {
            ///更新约束
            self.layoutIfNeeded()
        }) { (_) in
            UIView.animate(withDuration: 1.0, animations: {
                self.tipLabel.alpha = 1
            }, completion: { (_) in
                UIView.animate(withDuration: 1.0, animations: {
                    self.alpha = 0
                }, completion: { (_) in
                    self.removeFromSuperview()
                })
            })
        }
    }
}

