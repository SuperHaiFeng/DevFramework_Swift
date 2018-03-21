//
//  UIImageView+WebImage.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/24.
//  Copyright © 2018年 志方. All rights reserved.
//

import SDWebImage

extension UIImageView {
    ///隔离SDWebimage设置图像函数
    ///如果是头像，则给圆角
    func zf_setImage(urlString: String?, placeHolderImage: UIImage?, isAvatar: Bool = false) {
        guard let urlString = urlString,
            let url = URL(string: urlString) else{
            self.image = placeHolderImage
            return
        }
        sd_setImage(with: url, placeholderImage: placeHolderImage, options: [], progress: nil) {   [weak self](image, _, _, _) in
            ///完成回调，对图像判断是否是头像
            if isAvatar {
                self?.image = image?.zf_avatarImage(size: self?.bounds.size)
            }
        }
        
    }
}
