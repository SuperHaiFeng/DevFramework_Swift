//
//  ZFStatusesList_viewModel.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/2.
//  Copyright © 2018年 志方. All rights reserved.
//

import Foundation
import SDWebImage
/**
    如果类需要使用 ‘KVC’或者字典转魔心钢框架设置对象值，类就需要继承自NSObject
    如果类只是包装一些代码逻辑  可以不使用任何父类，更加轻量
    OC 一律都集成NSObject
 */

/**
    实名：字典转模型数据处理
    1、字典转模型
    2 、下拉/上拉刷新
 */
private let maxPillupTryTime = 3
class ZFStatusesListViewModel {
    lazy var statusList = [ZFStatusViewModel]()
    private var pullupErrorTimes = 0
    
    ///完成回调（网络请求是否完成）
    func loadStatus(pullup: Bool, completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()) {
        if pullup && pullupErrorTimes > maxPillupTryTime {
            completion(true,false)
            return
        }
        
        ///since_id 下拉，取出数组中第一条微博的id
        let since_id = pullup ? 0 : (statusList.first?.status.id ?? 0)
        ///max_id 上拉刷新
        let max_id = !pullup ? 0 : (statusList.last?.status.id ?? 0)
        
        ZFNetworkManager.shared().statusList(since_id: since_id, max_id: max_id) { (list, isSuccess) in
            if !isSuccess{
                completion(false,false)
                return
            }
            var array = [ZFStatusViewModel]()
            ///遍历字典数组。字典转模型
            for dict in list ?? [] {
                guard let model = ZFStatuses.yy_model(with: dict) else{
                    continue
                }
                var arr = [ZFStatusPicture]()
                ///如果是被转发的微博则保存被转发微博的图片，否则保存自创微博的图片资源
                if model.retweeted_status != nil {
                    for dic in dict["retweeted_status"]!["pic_urls"] as! NSArray {
                        guard let mode = ZFStatusPicture.yy_model(with: dic as! [AnyHashable : Any]) else{
                            continue
                        }
                        arr.append(mode)
                    }
                    model.retweeted_status?.pic_urls = arr
                }else{
                    for dic in dict["pic_urls"] as! NSArray {
                        guard let mode = ZFStatusPicture.yy_model(with: dic as! [AnyHashable : Any]) else{
                            continue
                        }
                        arr.append(mode)
                    }
                    model.pic_urls = arr
                }
                
                ///将视图模型添加到数组
                array.append(ZFStatusViewModel(model:model))
            }
            
            ///下拉刷新应该将结果数组拼接在数组前面
            if pullup {
                self.statusList += array
            }else{
                self.statusList = array + self.statusList
            }
           
            ///判断上拉刷新的数据量
            if pullup && array.count == 0{
                self.pullupErrorTimes += 1
                completion(isSuccess, false)
            }else{
                self.cacheSingleImage(list: array, completion: completion)
            }
        }
    }
    
    ///缓存本次下载微博数据数组中的单张图片
    ///缓存完单张图片，并且修改配图的大小之后再回调，才能保证等比例显示单张图像
    private func cacheSingleImage(list: [ZFStatusViewModel], completion: @escaping (_ isSuccess: Bool, _ shouldRefresh: Bool)->()){
        ///调度组
        let group = DispatchGroup()
        
        ///记录长度
        var length = 0
    
        ///遍历数组，有单张图片的进行缓存
        for vm in list {
            if vm.picURLs?.count != 1 {
                continue
            }
            guard let pic = vm.picURLs?[0].thumbnail_pic,
                let url = URL(string: pic) else {
                continue
            }
            ///下载图像
            ///downloadImage 核心方法,下载完成之后自动保存在沙盒中，文件路径是url的md5
            group.enter()
            SDWebImageManager.shared().downloadImage(with: url, options: [], progress: nil, completed: { (image, _, _, _, _) in
                
                if let image = image,
                    let data = UIImagePNGRepresentation(image){
                    length += data.count
                    ///缓存成功，调用更新图像大小
                    vm.updateSingleImage(image: image)
                }
                
                group.leave()
            })
        }
        ///监听调度组
        group.notify(queue: DispatchQueue.main) {
            completion(true, true)
        }
    }
}
