//
//  ZFStatusToolBar.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/24.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFStatusToolBar: UIView {
    
    var viewModel: ZFStatusViewModel? {
        didSet{
            retweetedButton.setTitle(viewModel?.retweetedStr, for: [])
            commentButton.setTitle(viewModel?.commentsStr, for: [])
            likeButton.setTitle(viewModel?.likeStr, for: [])
        }
    }
    ///转发
    @IBOutlet weak var retweetedButton: UIButton!
    ///评论
    @IBOutlet weak var commentButton: UIButton!
    ///点赞
    @IBOutlet weak var likeButton: UIButton!

}
