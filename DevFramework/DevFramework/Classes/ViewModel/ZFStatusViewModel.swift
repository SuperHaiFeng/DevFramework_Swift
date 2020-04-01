//
//  ZFStatusViewModel.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/23.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation
import UIKit

///单条视图模型
class ZFStatusViewModel {
    @objc var status: ZFStatuses
    ///以下是计算性属性
    ///会员图标
    var memberIcon: UIImage?
    ///认证类型 -1：没有认证，0：认证用户。2，3，5：企业认证，220:达人
    var vipIcon: UIImage?
    ///转发文字
    var retweetedStr: String?
    ///评论文字
    var commentsStr: String?
    ///点赞文字
    var likeStr: String?
    ///配图视图大小
    var pictureViewSize: CGSize?
    ///如果有被转发的微博，返回被转发微博的配图，否则返回原创微博的配图
    var picURLs: [ZFStatusPicture]? {
        return status.retweeted_status?.pic_urls ?? status.pic_urls
    }
    ///转发微博的文本
    var retweetedText: String?
    
    ///行高
    var rowHeight: CGFloat!
    
    ///构造函数
    ///微博的视图模型
    init(model: ZFStatuses) {
        self.status = model
        ///直接计算出会员图标/会员等级0-6
        if (model.user?.mbrank)! > 0 && (model.user?.mbrank)! <= 7 {
            let imageName = "vip\(model.user?.mbrank ?? -1)"
            memberIcon = UIImage(named: imageName)
        }
        
        ///计算vip
        switch model.user?.verified_type ?? -1 {
        case 0:
            vipIcon = UIImage(named: "normal")
        case 2,3,5:
            vipIcon = UIImage(named: "compony")
        case 220:
            vipIcon = UIImage(named: "glass")
        default:
            break
        }
        
        ///设置底部计数字符串
        retweetedStr = countString(count: model.reposts_count, defaultStr: "转发")
        commentsStr = countString(count: model.comments_count, defaultStr: "评论")
        likeStr = countString(count: model.attitudes_count, defaultStr: "赞")
        
        pictureViewSize = calcPictureViewSize(count: (picURLs?.count)!)
        ///设置被转发微博的文字
        
        retweetedText = "@\(status.retweeted_status?.user?.screen_name ?? ""):\(status.retweeted_status?.text ?? "")"
        ///更新行高
        updateRowHeight()
    }
    
    ///计算配图视图的大小
    private func calcPictureViewSize(count: Int) -> CGSize{
        
        if count == 0{
            return CGSize()
        }
        ///计算高度
        let row = (count - 1) / 3 + 1
        
        var height = ZFStatusPictureViewOutterMargin
        height += CGFloat(row) * ZFStatusPictureItemWidth
        height += CGFloat(row - 1) * ZFStatusPictureViewInnerMargin
        
        return CGSize.init(width: ZFStatusPictureViewWidth, height: height)
    }
    
    var description: String {
        return status.description
    }
    
    ///调用单个图片，更新配图的大小
    func updateSingleImage(image: UIImage) {
        var size = image.size
        ///过宽图像处理
        let maxWidth: CGFloat = 300
        let minWidth: CGFloat = 40
        if size.width > 40 {
            ///设置最大宽度
            size.width = maxWidth
            ///等比例调整高度
            size.height = size.width * image.size.height / image.size.width
        }
        
        ///过窄的图像处理
        if size.width < maxWidth {
            size.width = minWidth
            ///要特殊处理高度，高度过大影响用户体验
            size.height = size.width * image.size.height / image.size.width / 4
        }
        
        ///特例：有些图像，本身就很窄很长
        
        size.height += ZFStatusPictureViewOutterMargin
        ///重新设置配置视图大小
        pictureViewSize = size
        
        ///更新行高
        updateRowHeight()
    }
    
    ///给定一个数字，返回对应的描述结果
    private func countString(count: Int, defaultStr: String) -> String{
        if count == 0{
            return defaultStr
        }
        if count < 10000 {
            return count.description
        }
        return String.init(format: "%.1f万", Double(count) / 10000)
    }
    
    ///根据当前的视图模型计算行高
    func updateRowHeight() {
        let top: CGFloat = 8
        let margin: CGFloat = 12
        let iconHeight: CGFloat = 34
        let toolbarHeight: CGFloat = 35
        
        var height: CGFloat = 0
        
        let viewSize = CGSize.init(width: UIScreen.main.bounds.width - 2 * margin, height: CGFloat(MAXFLOAT))
        let originalFont = UIFont.systemFont(ofSize: 15)
        let retweetedFont = UIFont.systemFont(ofSize: 14)
        
        height = top + margin + iconHeight + margin
        
        ///计算正文高度
        if let text = status.text {
            height += (text as NSString).boundingRect(with: viewSize,
                                                      options: [.usesLineFragmentOrigin],
                                                      attributes: [NSAttributedString.Key.font: originalFont],
                                                      context: nil).height
        }
        
        ///判断是否是转发微博
        if status.retweeted_status != nil {
            height += 2 * margin
            
            if let text = retweetedText {
                height += (text as NSString).boundingRect(with: viewSize,
                                                         options: [.usesLineFragmentOrigin],
                                                         attributes: [NSAttributedString.Key.font: retweetedFont],
                                                         context: nil).height
            }
        }
        
        ///配图视图
        height += (pictureViewSize?.height)!
        
        height += margin
        
        height += toolbarHeight
        
        rowHeight = height
    }
}
