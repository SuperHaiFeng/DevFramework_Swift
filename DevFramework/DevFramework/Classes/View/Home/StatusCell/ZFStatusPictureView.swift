//
//  ZFStatusPictureView.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/24.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFStatusPictureView: UIView {
    var viewModel: ZFStatusViewModel?{
        didSet{
            calcViewSize()
            ///设置urls
            urls = viewModel?.picURLs
        }
    }
    
    private func calcViewSize(){
        ///处理宽度
        ///1>单图，根据配图视图大小，修改subviews[0]的宽高
        if viewModel?.picURLs?.count == 1 {
            let viewSize = viewModel?.pictureViewSize ?? CGSize()
            let v = subviews[0]
            v.frame = CGRect.init(x: 0,
                                  y: ZFStatusPictureViewOutterMargin,
                                  width: viewSize.width,
                                  height: viewSize.height - ZFStatusPictureViewOutterMargin)
            
            
        }else{
             ///2>多图，恢复subviews[0]的宽高，保证九宫格布局的完成
            let v = subviews[0]
            v.frame = CGRect.init(x: 0,
                                  y: ZFStatusPictureViewOutterMargin,
                                  width: ZFStatusPictureItemWidth,
                                  height: ZFStatusPictureItemWidth)
        }
        
       
        
        heightCons.constant = (viewModel?.pictureViewSize?.height) ?? 0
    }
    
///配图视图的数组
    private var urls: [ZFStatusPicture]? {
        didSet{
            ///隐藏所有imageview
            for v in subviews {
                v.isHidden = true
            }
            
            var index = 0
            for url in urls ?? [] {
                let iv = subviews[index] as! UIImageView
                ///处理四张图像
                if index == 1 && urls?.count == 4{
                    index += 1
                }
                iv.zf_setImage(urlString: url.thumbnail_pic, placeHolderImage: nil)
                iv.isHidden = false
                index += 1
            }
            
        }
    }
    
    @IBOutlet weak var heightCons: NSLayoutConstraint!
    
    override func awakeFromNib() {
        setupUI()
    }

}
//MARK: -设置界面
extension ZFStatusPictureView {
    private func setupUI(){
        ///超出边界的内容不现实
        clipsToBounds = true
        
        let count = 3
        let rect = CGRect.init(x: 0,
                               y: ZFStatusPictureViewOutterMargin,
                               width: ZFStatusPictureItemWidth,
                               height: ZFStatusPictureItemWidth)
        
        ///循环创建9个imageview
        for i in 0..<count * count {
            let iv = UIImageView()
            
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            ///行
            let row = CGFloat(i / count)
            ///列
            let col = CGFloat(i % count)
            
            let xOffset = col * (ZFStatusPictureItemWidth + ZFStatusPictureViewInnerMargin)
            let yOffset = row * (ZFStatusPictureItemWidth + ZFStatusPictureViewInnerMargin)
            
            iv.frame = rect.offsetBy(dx: xOffset, dy: yOffset)
            addSubview(iv)
        }
        
    }
}
