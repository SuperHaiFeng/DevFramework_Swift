//
//  ZFTraitsVC.swift
//  DevFramework
//
//  Created by 张志方 on 2018/9/27.
//  Copyright © 2018年 志方. All rights reserved.
//

enum DataError {
    case cantParseJSON
}
enum CacheError : Error {
    case failedCaching
}
enum StringError: Error {
    case failedGerate
}

import UIKit
import RxSwift
import RxCocoa

class ZFTraitsVC: ZFTestVc {
    
    var textField1: UITextField!
    var textField2:UITextField!
    
    var button: UIButton!
    var switch1: UISwitch!
    var segment: UISegmentedControl!
    var indicator: UIActivityIndicatorView!
    var slider: UISlider!
    var step: UIStepper!
    //倒计时时间选择控件
    var ctimer: UIDatePicker!
    //开始按钮
    var start : UIButton!
    //剩余时间（必须为60的整数倍）
    let leftTime = Variable(TimeInterval(180))
    //当前倒计时是否结束
    let countDownStoped = Variable(true)
    
    
    
    var userModel = UserViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        self.setView()
//        self.setSingleEvent()
//        self.setCompletable()
//        self.setMaybe()
//        self.setControlProperty()
//        self.setControlEvent()
//        self.setBindingControl()
        self.setObserverMoreTextview()
        self.countDown()
    }
    
    
    func setView() {
        let top = self.label.frame.maxY
        self.textField1 = UITextField.init(frame: CGRect.init(x: 20, y: top, width: 300, height: 40))
        self.textField1.placeholder = "输入"
        self.textField1.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(self.textField1)
        
        self.textField2 = UITextField.init(frame: CGRect.init(x: 20, y: self.textField1.frame.maxY, width: 300, height: 40))
        self.textField2.borderStyle = UITextBorderStyle.roundedRect
        self.view.addSubview(self.textField2)
        
        self.button = UIButton.init(type: UIButtonType.system)
        self.button.frame = CGRect.init(x: 20, y: self.textField2.frame.maxY, width: 80, height: 40)
        self.button.setTitle("点我", for: UIControlState.normal)
        self.button.backgroundColor = UIColor.green
        self.view.addSubview(self.button)
        
        switch1 = UISwitch.init(frame: CGRect.init(x: button.frame.maxX, y: button.frame.minY, width: 80, height: 40))
        switch1.onTintColor = UIColor.red
        self.view.addSubview(switch1)
        
        segment = UISegmentedControl.init(items: ["First","Second","Third"])
        segment.frame = CGRect.init(x: 20, y: button.frame.maxY, width: 300, height: 40)
        segment.selectedSegmentIndex = 0
        self.view.addSubview(segment)
        
        indicator = UIActivityIndicatorView.init(frame: CGRect.init(x: switch1.frame.maxX, y: switch1.frame.minY, width: 40, height: 40))
        indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        self.view.addSubview(indicator)
        
        slider = UISlider.init(frame: CGRect.init(x: 20, y: segment.frame.maxY, width: 100, height: 40))
        self.view.addSubview(slider)
        
        step = UIStepper.init(frame: CGRect.init(x: slider.frame.maxX, y: segment.frame.maxY, width: 80, height: 40))
        self.view.addSubview(step)
        
        ctimer = UIDatePicker.init(frame: CGRect.init(x: 0, y: step.frame.maxY, width: 320, height: 200))
        ctimer.datePickerMode = UIDatePickerMode.countDownTimer
        self.view.addSubview(ctimer)
        
        start = UIButton.init(type: UIButtonType.custom)
        start.frame = CGRect.init(x: 0, y: ctimer.frame.maxY, width: 320, height: 30)
        start.setTitleColor(UIColor.red, for: .normal)
        start.setTitleColor(UIColor.gray, for: .disabled)
        self.view.addSubview(start)
        
        
        
    }
}

extension ZFTraitsVC {
    //MARK:------------特征序列---------
    //1、Single
    //Single 是 Observable 的另外一个版本。但它不像 Observable 可以发出多个元素，它要么只能发出一个元素，要么产生一个 error 事件。发出一个元素，或一个 error 事件,不会共享状态变化
    func setSingleEvent()  {
        //获取豆瓣某频道下的信息
//        getPlayList("0")
//            .subscribe { (event) in
//                switch event{
//                case .success(let json):
//                    print("json结果：",json)
//                case .error(let error):
//                    print("错误：",error)
//                }
//        }
//        .disposed(by: disposeBag)
        
        getPlayList("0")
            .subscribe(onSuccess: { (json) in
                print("json结果：",json)
            }) { (error) in
                print("错误：",error)
        }
        .disposed(by: disposeBag)
    }
    //获取豆瓣频道数据
    func getPlayList(_ channle: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create { single in
            let url = "https://douban.fm/j/mine/playlist?"
                + "type=n&channel=\(channle)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, _, error) in
                if let error = error {
                    single(.error(error))
                    return
                }
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                        single(.error(DataError.cantParseJSON as! Error))   //RxSwift提供的SingleEvent枚举error
                        return
                    }
                single(.success(result))        //RxSwift提供的SingleEvent枚举success
                
            })
            task.resume()
            
            return Disposables.create{task.cancel()}
        }
    }
    
    //2、completable
    //Completable 是 Observable 的另外一个版本。不像 Observable 可以发出多个元素，它要么只能产生一个 completed 事件，要么产生一个 error 事件。
    //应用场景：
    //Completable 和 Observable<Void> 有点类似。适用于那些只关心任务是否完成，而不需要在意任务返回值的情况。比如：在程序退出时将一些数据缓存到本地文件，供下次启动时加载。像这种情况我们只关心缓存是否成功。
    func setCompletable() {
//        cacheLocally()
//            .subscribe{completable in
//                switch completable{
//                case .completed:
//                    print("保存成功")
//                case .error(let error):
//                    print("保存失败：",error)
//                }
//        }
//        .disposed(by: disposeBag)
        cacheLocally()
            .subscribe(onCompleted: {
                print("保存成功")
            }) { (error) in
                print("保存失败：",error)
        }
        .disposed(by: disposeBag)
        
    }
    //缓存本地数据（使用comopletable的一个场景）
    func cacheLocally() -> Completable {
        return Completable.create(subscribe: { completable in
            //将数据缓存到本地，随机成功或失败
            let success = (arc4random() % 2 == 0)
            guard success else {
                completable(.error(CacheError.failedCaching)) //RxSwift提供的CompletableEvent枚举error
                return Disposables.create{}
            }
            completable(.completed)     //RxSwift提供的CompletableEvent枚举completed
            return Disposables.create {}
        })
    }
    
    //3、MayBe
    //Maybe 同样是 Observable 的另外一个版本。它介于 Single 和 Completable 之间，它要么只能发出一个元素，要么产生一个 completed 事件，要么产生一个 error 事件。
    func setMaybe() {
        generateString()
            .subscribe(onSuccess: { (element) in
                print("成功发出元素：",element)
            }, onError: { (error) in
                print("执行失败：",error)
            }) {
                print("执行完毕，但没有任何元素")
        }
        .disposed(by: disposeBag)
    }
    
    func generateString() -> Maybe<String> {
        return Maybe<String>.create(subscribe: { (maybe) -> Disposable in
            //成功并发出一个元素
            maybe(.success("success"))
            
            //成功但不发出任何元素
            maybe(.completed)
            
            //失败
            maybe(.error(StringError.failedGerate))
            return Disposables.create {}
        })
    }
    
    //3、ControlProperty
    //ControlProperty 是专门用来描述 UI 控件属性，拥有该类型的属性都是被观察者（Observable）。
    func setControlProperty() {
        //将textfield输入的文字绑定到label上
        textField1.rx.text
            .bind(to:label.rx.text)
            .disposed(by: disposeBag)
        
        
        
        //内容改变就获取到所有的文字
        textField1.rx.text.orEmpty.asObservable()
            .subscribe(onNext:{print("您输入的是：\($0)")})
            .disposed(by: disposeBag)
        
        //和asObservable一样
//        textField.rx.text.orEmpty.changed
//            .subscribe(onNext:{print("您输入的是：\($0)")})
//            .disposed(by: disposeBag)
    }
    
    //4、ControlEvent
    //ControlEvent 是专门用于描述 UI 所产生的事件，拥有该类型的属性都是被观察者（Observable）。
    func setControlEvent() {
        button.rx.tap
            .subscribe(onNext:{print("欢迎访问我")})
            .disposed(by: disposeBag)
    }
    
    //控件互相绑定
    func setBindingControl() {
        let input = textField1.rx.text.orEmpty.asDriver()   //将普通序列转换成Driver
            .throttle(0.3)  //在线程中操作，0.3秒内若值多次改变，取最后一次
        
        let output = textField2.rx.text.orEmpty.asDriver()
            .throttle(0.3)
        
        //内容绑定到另一个输入框
        input.drive(textField2.rx.text)
            .disposed(by: disposeBag)
        
        output.drive(textField1.rx.text)
            .disposed(by: disposeBag)
        
        //内容绑定到文本标签
        input.map { "当前字数：\($0.count)"}
            .drive(label.rx.text)
            .disposed(by: disposeBag)
        
        //根据内容字数判断按钮是否可用
        input.map { $0.count > 5 }
            .drive(button.rx.isEnabled)
            .disposed(by: disposeBag)
    }
    
    //监听多个textview
    func setObserverMoreTextview() {
        Observable.combineLatest(textField1.rx.text.orEmpty, textField2.rx.text.orEmpty) {
                textValue1, textValue2 -> String in
                return "你输入的号码是：\(textValue1)-\(textValue2)"
            }
            .map{$0}
            .bind(to:label.rx.text)
            .disposed(by: disposeBag)
        
        //switch开关控制按钮是否可用
        switch1.rx.isOn
            .bind(to:button.rx.isEnabled)
            .disposed(by: disposeBag)
        switch1.rx.isOn.asObservable()
            .subscribe(onNext:{print("当前状态:\($0)")})
            .disposed(by: disposeBag)
        
        //创建可观察序列
        let observe: Observable<String> =
            segment.rx.selectedSegmentIndex.asObservable().map {
                return self.segment.titleForSegment(at: $0) ?? ""
            }
        observe
            .bind(to: textField2.rx.text)
            .disposed(by: disposeBag)
        
        //开关绑定指示器
        switch1.rx.isOn
            .bind(to:indicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        //开关绑定网络指示器
        switch1.rx.isOn
            .bind(to:UIApplication.shared.rx.isNetworkActivityIndicatorVisible)
            .disposed(by: disposeBag)
        
        //绑定slider
        slider.rx.value.asObservable()
            .subscribe(onNext:{print("当前滑动到：\($0)")})
            .disposed(by: disposeBag)
        
        //绑定stepper
        step.rx.value.asObservable()
            .subscribe(onNext:{print("当前值：\($0)")})
            .disposed(by: disposeBag)
        
        //使用滑块控制步长
//        slider.rx.value
//            .map{ Double($0) }
//            .bind(to: step.rx.stepValue)
//            .disposed(by: disposeBag)
        
        //双向绑定
        //将用户名与textfield2做双向绑定
        userModel.userName.asObservable()
            .bind(to: textField2.rx.text)
            .disposed(by: disposeBag)
        textField2.rx.text.orEmpty
            .bind(to:userModel.userName)
            .disposed(by: disposeBag)
        //将用户信息绑定到lable上
        userModel.userInfo.asObservable()
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
        //手势扩展
        let swipe = UISwipeGestureRecognizer()
        swipe.direction = .up
        self.view.addGestureRecognizer(swipe)
        
        swipe.rx.event
            .bind { recognizer in
                let point = recognizer.location(in: recognizer.view)
                print("当前滑动的点：\(point.x),\(point.y)")
            }
            .disposed(by: disposeBag)
        
    }
    
    //倒计时
    func countDown() {
        //剩余时间与dataPicker做双向绑定
        DispatchQueue.main.async {
            self.ctimer.rx.countDownDuration
                .bind(to:self.leftTime)
                .disposed(by: self.disposeBag)
            self.leftTime.asObservable()
                .bind(to:self.ctimer.rx.countDownDuration)
                .disposed(by:self.disposeBag)
        }
        
        //绑定开始按钮标题
        Observable.combineLatest(leftTime.asObservable(),countDownStoped.asObservable()) {leftTime, countDownStoped in
                //根据当前的状态设置按钮的标题
                if countDownStoped {
                    return "开始"
                }else {
                    return "倒计时开始，还有\(Int(leftTime))秒"
                }
            }
            .bind(to: start.rx.title())
            .disposed(by: disposeBag)
        
        //绑定start和datapicker的状态（倒计时过程按钮和选择器不可用）
        countDownStoped.asDriver().drive(ctimer.rx.isEnabled).disposed(by: disposeBag)
        countDownStoped.asDriver().drive(start.rx.isEnabled).disposed(by: disposeBag)
        
        //按钮点击响应
        start.rx.tap
            .bind{[weak self] in
                self?.startClicked()
            }
            .disposed(by: disposeBag)
    }
    //开始倒计时
    func startClicked() {
        self.countDownStoped.value = false
        Observable<Int>.interval(1, scheduler: MainScheduler.instance)
            .takeUntil(countDownStoped.asObservable().filter{$0}) //倒计时结束停止计时器
            .subscribe { event in
                //每次剩余时间-1
                self.leftTime.value -= 1
                if self.leftTime.value == 0 {
                    self.countDownStoped.value = true
                    self.leftTime.value = 180
                }
        }
        .disposed(by: disposeBag)
    }
}

struct UserViewModel {
    let userName = Variable("guest")
    
    //用户信息
    lazy var userInfo = {
        return self.userName.asObservable()
            .map{$0 == "Admin" ? "您是管理员" : "您是普通游客"}
            .share(replay: 1)
    }()
}
