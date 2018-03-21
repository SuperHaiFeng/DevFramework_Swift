//
//  ZFNewFeatureView.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/11.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFNewFeatureView: UIView, NibLoadable {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageController: UIPageControl!
    @IBOutlet weak var enterButton: UIButton!
    @IBAction func enterStatus(_ sender: Any) {
        removeFromSuperview()
    }
    
    override func awakeFromNib() {
        ///自动布局设置的及界面，从xib加载默认
        let count = 4
        let rect = UIScreen.main.bounds
        for i in 0..<count {
            let imageName = "feature"
            let iv = UIImageView(image: UIImage(named:imageName))
            
            iv.frame = rect.offsetBy(dx: CGFloat(i) * rect.width, dy: 0)
            scrollView.addSubview(iv)
        }
        
        scrollView.contentSize = CGSize(width: CGFloat(count + 1) * rect.width, height: rect.height)
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        
        enterButton.isHidden = true
    }

}

extension ZFNewFeatureView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        ///滚动到最后一个，删除视图
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width)
        ///判断是否最后一页
        if page == scrollView.subviews.count {
            removeFromSuperview()
        }
        
        enterButton.isHidden = (page != scrollView.subviews.count - 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        enterButton.isHidden = true
        
        let page = Int(scrollView.contentOffset.x / scrollView.bounds.width + 0.5)
        
        pageController.currentPage = page
        
        pageController.isHidden = (page == scrollView.subviews.count)
    }
}
