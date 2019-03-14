//
//  ZFBaseViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit

class ZFBaseViewController: UIViewController {
    var tableView: UITableView?
    var refreshController : ZFRefreshControl?
    var isPullup: Bool = false
    
    lazy var navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 40, width: UIScreen.main.bounds.width, height: 44))
    lazy var navItem = UINavigationItem()
    lazy var statusView = UIView.init(frame: CGRect.init(x: 0, y: -40, width: UIScreen.main.bounds.width, height: 40))
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        ZFNetworkManager.shared().userLogin ? loadData() : ()
        
        NotificationCenter.default.addObserver(self, selector: #selector(loginSuccess), name: NSNotification.Name(rawValue: ZFUserloginSuccessNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //重写title的 didSet方法
    override var title: String? {
        didSet{
            navItem.title = title
        }
    }
    //加载数据
    @objc func loadData() {
        refreshController?.endRefreshing()
    }
    
    ///tableview加载特效
    func animateTable() {
        let cells = tableView?.visibleCells
        let tableHeight: CGFloat = (tableView?.bounds.size.height)!
        for (index, cell) in (cells?.enumerated())! {
            cell.transform = CGAffineTransform.init(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 1.0,
                           delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: [],
                           animations: {
                            cell.transform = CGAffineTransform.init(translationX: 0, y: 0)
            }, completion: { (_) in
                
            })
        }
    }

}

extension ZFBaseViewController{
    @objc private func setupUI(){
        view.backgroundColor = UIColor.orange
        //设置不自动缩进
        automaticallyAdjustsScrollViewInsets = false

        setupNavigation()
        ZFNetworkManager.shared().userLogin ? setupTableView() : setupVisotorView()
        
    }
    
    //设置tableview
    @objc func setupTableView(){
        tableView = UITableView.init(frame: view.bounds, style: .plain)
        
        view.insertSubview(tableView!, belowSubview: navigationBar)
        
        tableView?.dataSource = self
        tableView?.delegate = self
        
        tableView?.contentInset = UIEdgeInsetsMake(navigationBar.bounds.height,
                                                   0,
                                                   0,
                                                   0)
        
        ///修改指示器的缩进
        tableView?.scrollIndicatorInsets = tableView!.contentInset
        refreshController = ZFRefreshControl()
        tableView?.addSubview(refreshController!)
        //添加监听方法
        refreshController?.addTarget(self, action: #selector(loadData), for: .valueChanged)
    }
    
    //设置访客视图
    private func setupVisotorView(){
        let visitorView = UIView(frame: view.bounds)
        visitorView.backgroundColor = UIColor.white
        view.insertSubview(visitorView, belowSubview: navigationBar)
        
        ///设置导航条按钮
        navItem.leftBarButtonItem = UIBarButtonItem.init(title: "注册", style: .plain, target: self, action: #selector(register))
        navItem.rightBarButtonItem = UIBarButtonItem.init(title: "登录", style: .plain, target: self, action: #selector(login))
    }
    
    //设置导航栏
    private func setupNavigation(){
        view.addSubview(navigationBar)
        navigationBar.isTranslucent = false
        navigationBar.items = [navItem]
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.darkGray]
        statusView.backgroundColor = UIColor.white
        navigationBar.tintColor = UIColor.orange
        navigationBar.addSubview(statusView)
    }
}

extension ZFBaseViewController {
    @objc private func register() {
        print("注册")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserShouldRegisterNotification), object: nil)
    }
    
    @objc private func login() {
        ///发送通知
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: ZFUserShouldLoginNotification), object: nil)
    }
    
    ///登录成功
    @objc private func loginSuccess(n: Notification) {
        navItem.leftBarButtonItem = nil
        navItem.rightBarButtonItem = nil
        ///view = nil 重新走一遍生命周期函数，重新设置view
        view = nil
        
        NotificationCenter.default.removeObserver(self)
    }
}

// MARK: -UITableViewDataSource
extension ZFBaseViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let row = indexPath.row
        let section = tableView.numberOfSections - 1
        if row < 0 || section < 0{
            return
        }
        
        let count = tableView.numberOfRows(inSection: section)
        //如果是最后一行，同时没有上拉刷新
        if row == (count - 1) && !isPullup {
            isPullup = true
            loadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         tableView.deselectRow(at: indexPath, animated: true)
    }
    
    ///实现cell点击效果
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        cell?.transform = CGAffineTransform.init(scaleX: 0.9, y: 0.9)
        UIView.commitAnimations()
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(0.2)
        cell?.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        UIView.commitAnimations()
    }
    
}

