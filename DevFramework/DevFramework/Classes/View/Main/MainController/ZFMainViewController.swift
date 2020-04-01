//
//  ZFMainViewController.swift
//  DevFramework
//
//  Created by 志方 on 2018/1/26.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import SVProgressHUD
import RxSwift

class ZFMainViewController: UITabBarController {
    let disposeBag = DisposeBag()
    ///定时器
    private var timer : Timer?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupChildController()
        setupComposeButton()
        setupTimer()
        
        setupNewFeatureView()
        
        ///设置代理
        delegate = self
        
        ///登陆通知
        NotificationCenter.default.addObserver(self, selector: #selector(userLogin), name: NSNotification.Name(rawValue: ZFUserShouldLoginNotification), object: nil)
        //注册通知
        NotificationCenter.default.addObserver(self, selector: #selector(userRegister), name: NSNotification.Name(rawValue: ZFUserShouldRegisterNotification), object: nil)
        
    }
    
    deinit {
        ///销毁
        timer?.invalidate()
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func userLogin(n: Notification){
        var when = DispatchTime.now()
        ///token过期，提示重新登录
        if n.object != nil {
            SVProgressHUD.setDefaultMaskType(.gradient)
            SVProgressHUD.showInfo(withStatus: "用户登录超时，请重新登录")
            when = DispatchTime.now() + 1
        }
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let vc = UINavigationController.init(rootViewController: ZFOAuthViewController())
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    @objc private func userRegister(n: Notification) {
        let when = DispatchTime.now()
        DispatchQueue.main.asyncAfter(deadline: when) {
            SVProgressHUD.setDefaultMaskType(.clear)
            let vc = UINavigationController(rootViewController: ZFTestNetAFVC())
            vc.navigationBar.isHidden = false
            self.present(vc, animated: true, completion: nil)
        }
        
    }
    
    //设置显示竖屏
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    //objc允许这个函数在运行时通过OC的消息机制被调用
    @objc private func composeStatus() {
//        let compose = ZFComposeTypeView.loadFromNib()
//        compose.show()
        let gift = GiftDropImageView(imageUrl: "")
        gift.showAnimation(fromView: view)
        gift.tapGiftObserver.subscribe(onNext: { [unowned self] _ in
            
        }).disposed(by: disposeBag)
    }
    
    private lazy var composeButton: UIButton = UIButton.init()
    
}
//MARK: -新特性
extension ZFMainViewController {
    private func setupNewFeatureView() {
        let v = isNewVersion ? ZFNewFeatureView.loadFromNib() : ZFWelcomView.loadFromNib()

        view.addSubview(v)
    }
    
    private var isNewVersion: Bool {
        
        let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        
        let path: String = ("version" as String).zf_appendDocumentDir()
        let sandboxVersion = (try? String(contentsOfFile: path)) ?? ""
        
        _ = try? currentVersion.write(toFile: path, atomically: true, encoding: .utf8)
        
        return currentVersion != sandboxVersion
    }
}


extension ZFMainViewController : UITabBarControllerDelegate {
    ///将要选择item
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        ///获取控制器在数组中的索引
        let index = children.index(of: viewController)
        ///获取当前索引(重复点击首页item)
        if selectedIndex == 0 && index == selectedIndex{
            ///让表格滚动到底部,获取到控制器
            let nav = children[0] as! UINavigationController
            let vc = nav.children[0] as! ZFHomeViewController
            vc.tableView?.setContentOffset(CGPoint.init(x: 0, y: -128), animated: true)
            vc.refreshController?.beginRefreshing()
            ///刷新表格
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1, execute: {
                vc.loadData()
            })
            
            vc.tabBarItem.badgeValue = nil
            UIApplication.shared.applicationIconBadgeNumber = 0
        }
        
        return !viewController.isMember(of: UIViewController.self)
    }
}

extension ZFMainViewController {
    ///定时检查未读数量
    private func setupTimer(){
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc private func updateTimer(){
        ///请求未读微博数量
        if !ZFNetworkManager.shared().userLogin {
            return
        }
        self.tabBar.items?[0].badgeValue = "8"
        UIApplication.shared.applicationIconBadgeNumber = 8
    }
    
    private func setupComposeButton(){
        composeButton.setImage(UIImage.init(named: "add"), for: UIControl.State.normal)
        composeButton.setBackgroundImage(UIImage.init(named: "R"), for: UIControl.State.normal)
        tabBar.addSubview(composeButton)
        
        //计算按钮的宽度
        let count = CGFloat(children.count)
        let w = tabBar.bounds.width/count
        composeButton.frame = tabBar.bounds.insetBy(dx: w * 2, dy: 0)
        composeButton.addTarget(self, action: #selector(composeStatus), for: .touchUpInside)
    }
    ///设置所有子控制器
    private func setupChildController(){
        
        ///获取沙盒json路径
        let jsonPath = ("main.json").zf_appendDocumentDir()
        //加载data
        var data = NSData.init(contentsOfFile: jsonPath)
        
        if data == nil {
            let path = Bundle.main.path(forResource: "main.json", ofType: nil)
            data = NSData.init(contentsOfFile: path!)
        }
        
        ///反序列化
        guard let array = try? JSONSerialization.jsonObject(with: data! as Data, options: []) as? [[NSString: NSString]]
            else {
                return
        }
        
        
        /**
        guard let path = Bundle.main.path(forResource: "main.json", ofType: nil),
            let data = NSData.init(contentsOfFile: path),
            let array = try? JSONSerialization.jsonObject(with: data as Data, options: []) as? [[NSString: NSString]]
            else {
            return
        }
        
        let array = [
            ["clsName":"ZFHomeViewController","title":"首页","imageName":"firstPage"],
            ["clsName":"ZFMessageViewController","title":"信息","imageName":"subject"],
            ["clsMame":"","title":""],
            ["clsName":"ZFDiscoveryViewController","title":"发现","imageName":"teacher"],
            ["clsName":"ZFProfileViewController","title":"我","imageName":"me"]
        ]
        
        数组 -> json
        let data = try! JSONSerialization.data(withJSONObject: array, options: [.prettyPrinted])

        (data as NSData).write(toFile: "/Users/Andy/Desktop/demo.json", atomically: true)
        */
        var arrayM = [UIViewController]()
        for dict in array {
            arrayM.append(controler(dict: dict as [String : String]))
        }
        viewControllers = arrayM
        
    }
    
    //使用一个字典创建一个子控制器
    private func controler(dict: [String: String]) -> UIViewController{
        guard let clsName = dict["clsName"],
            let title = dict["title"],
            let imageName = dict["imageName"],
            let cls = NSClassFromString(Bundle.main.namespace + "." + clsName) as? UIViewController.Type
            else{
                return UIViewController()
        }
        
        let vc = cls.init()
        vc.title = title
        vc.tabBarItem.image = UIImage(named: "tabbar_" + imageName)
        vc.tabBarItem.selectedImage = UIImage(named: "tabbar_" + imageName + "_selected")?.withRenderingMode(.alwaysOriginal)
        vc.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .highlighted)
        
        let nav = ZFNavigationController(rootViewController:vc)
        return nav
        
    }
}
