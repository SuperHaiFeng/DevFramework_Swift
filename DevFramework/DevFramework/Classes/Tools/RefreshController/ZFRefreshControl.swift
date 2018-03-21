//
//  ZFRefreshControl.swift
//  DevFramework
//
//  Created by 志方 on 2018/2/27.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

///刷新状态切换的临界点
private let ZFRefreshOffset: CGFloat = 60

///Normal:普通状态 Pulling:超过临界点，开始刷新 WillRefresh:超过临界点，并且放手
enum ZFRefreshStatu {
    case Normal
    case Pulling
    case WillRefresh
}

///刷新控件
class ZFRefreshControl: UIControl {
    
    ///滚动控件的父视图，下拉刷新控件英爱适用于uitableview/uicollectionview
    private weak var scrollView: UIScrollView?
    
    private lazy var refreshView: ZFRefreshView = ZFRefreshView.refreshView()
    
    init() {
        super.init(frame: CGRect())
        
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupUI()
    }
    
    ///当添加到俯视图的时候，newSubview是父视图
    ///当父视图被移除，newSubview是nil
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        ///判断父视图的类型
        guard let sv = newSuperview as? UIScrollView else {
            return
        }
        
        ///记录父视图
        scrollView = sv
        
        ///KVO监听父视图的contentOffset
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [], context: nil)
        
    }
    
    ///本视图从父视图上移除
    override func removeFromSuperview() {
        ///superView还存在
        superview?.removeObserver(self, forKeyPath: "contentOffset")
        super.removeFromSuperview()
        ///superView不存在
    }
    
    ///所有的监听都调用该方法
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        ///contentOffset的y值跟contentInset的top有关
        guard let sv = scrollView else {
            return
        }
        ///初始高度
        let height = -(sv.contentInset.top + sv.contentOffset.y)
        if height < 0 {
            return
        }
        
        ///根据高度刷新控件的frame
        self.frame = CGRect.init(x: 0,
                                 y: -height,
                                 width: sv.bounds.width,
                                 height: height)
        ///判断临界点
        if sv.isDragging {
            if height > ZFRefreshOffset && refreshView.refreshStatu == .Normal {
                refreshView.refreshStatu = .Pulling
            }else if height <= ZFRefreshOffset && (refreshView.refreshStatu == .Pulling){
                refreshView.refreshStatu = .Normal
            }
        }else{
            ///放手-判断是否超过临界点
            if refreshView.refreshStatu == .Pulling{
                beginRefreshing()
                ///发送刷新事件
                sendActions(for: .valueChanged)
            }
        }
    }
    
    
    ///开始刷新
    func beginRefreshing() {
        guard let sv = scrollView else{
            return
        }
        ///判断视图是正在刷新
        if refreshView.refreshStatu == .WillRefresh {
            return
        }
        ///设置刷新视图的状态
        refreshView.refreshStatu = .WillRefresh
        
        ///调整表格的间距
        var inset = sv.contentInset
        inset.top += ZFRefreshOffset
        
        sv.contentInset = inset
    }
    ///结束刷新
    func endRefreshing () {
        guard let sv = scrollView else{
            return
        }
        ///判断是否在刷新
        if refreshView.refreshStatu != .WillRefresh {
            return
        }
        ///恢复刷新视图的状态
        refreshView.refreshStatu = .Normal
        ///恢复表格是图的contentInset
        UIView.animate(withDuration: 0.25) {
            var inset = sv.contentInset
            inset.top -= ZFRefreshOffset
            sv.contentInset = inset
        }
        
    }

}

extension ZFRefreshControl {
    func setupUI() {
        backgroundColor = superview?.backgroundColor
        ///超出边界不显示
//        clipsToBounds = true
        ///添加刷新视图
        addSubview(refreshView)
        ///自动布局
        refreshView.translatesAutoresizingMaskIntoConstraints = false
        
        addConstraint(NSLayoutConstraint.init(item: refreshView,
                                              attribute: .centerX,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .centerX,
                                              multiplier: 1.0,
                                              constant: 0))
        addConstraint(NSLayoutConstraint.init(item: refreshView,
                                              attribute: .bottom,
                                              relatedBy: .equal,
                                              toItem: self,
                                              attribute: .bottom,
                                              multiplier: 1.0,
                                              constant: 0))
        addConstraint(NSLayoutConstraint.init(item: refreshView,
                                              attribute: .width,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: refreshView.bounds.width))
        addConstraint(NSLayoutConstraint.init(item: refreshView,
                                              attribute: .height,
                                              relatedBy: .equal,
                                              toItem: nil,
                                              attribute: .notAnAttribute,
                                              multiplier: 1.0,
                                              constant: refreshView.bounds.height))
    }
}
