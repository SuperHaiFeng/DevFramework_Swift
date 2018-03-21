//
//  ZFStatusCell.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/23.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFStatusCell: UITableViewCell {
    
    ///设置视图模型
    var viewModel: ZFStatusViewModel?{
        didSet{
            statusLabel.text = viewModel?.status.text
            nameLabel.text = viewModel?.status.user?.screen_name
            memberView.image = viewModel?.memberIcon
            approveImageView.image = viewModel?.vipIcon
            ///用户头像
            avatarImageView.zf_setImage(urlString: (viewModel?.status.user?.profile_image_url)!, placeHolderImage: UIImage(named: "tabbar_me"), isAvatar: true)
            
            ///底部工具栏
            toolBar.viewModel = viewModel
            ///配图视图模型
            pictureView.viewModel = viewModel
            
            retweetedLabel?.text = viewModel?.retweetedText
            
            sourceLabel.text = viewModel?.status.source
        }
    }
    
    ///头像
    @IBOutlet weak var avatarImageView: UIImageView!
    ///昵称
    @IBOutlet weak var nameLabel: UILabel!
    ///会员
    @IBOutlet weak var memberView: UIImageView!
    ///时间
    @IBOutlet weak var timeLabel: UILabel!
    ///来源
    @IBOutlet weak var sourceLabel: UILabel!
    ///正文
    @IBOutlet weak var statusLabel: UILabel!
    ///认证
    @IBOutlet weak var approveImageView: UIImageView!
    
    @IBOutlet weak var toolBar: ZFStatusToolBar!
    @IBOutlet weak var pictureView: ZFStatusPictureView!
    ///被转发微博的text（设置可选的）
    @IBOutlet weak var retweetedLabel: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        /**
            高级优化（耗电厉害）(如果性能已经很好，就不需要离屏渲染)
        */
        ///离屏渲染 (在CPU/GPU之间来回切换)
        self.layer.drawsAsynchronously = true
        
        ///栅栏化  异步绘制之后，会生成一张独立的图像，cell在屏幕上滚动的时候，本质上滚动的是这张图片
        ///cell优化，尽量减少图层的食量，相当于就只有一层
        ///停止滚动之后，可以接受监听
        self.layer.shouldRasterize = true
        
        ///使用栅格化必须注意指定分辨率
        self.layer.rasterizationScale = UIScreen.main.scale
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        let subviews = contentView.subviews
        var colors = [UIColor]()
        for view in subviews {
            colors.append(view.backgroundColor ?? UIColor.clear)
        }
        super.setSelected(selected, animated: animated)
        for i in 0..<subviews.count {
            subviews[i].backgroundColor = colors[i]
        }
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        let subviews = contentView.subviews
        var colors = [UIColor]()
        for view in subviews {
            colors.append(view.backgroundColor ?? UIColor.clear)
        }
        super.setHighlighted(highlighted, animated: animated)
        for i in 0..<subviews.count {
            subviews[i].backgroundColor = colors[i]
        }
    }

}
