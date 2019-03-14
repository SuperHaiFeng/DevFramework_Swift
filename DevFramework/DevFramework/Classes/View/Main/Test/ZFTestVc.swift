//
//  ZFTestVc.swift
//  DevFramework
//
//  Created by 张志方 on 2018/9/19.
//  Copyright © 2018年 志方. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

enum MyError:Error {
    case A
    case B
}

class ZFTestVc: ZFBaseViewController {

    var label: UILabel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "测试RXSwift"
        self.createView()
//        self.setObserverWithBind()
//        self.setObservableWithBindTo()
//        self.setObserverWithBinder()
//        self.setObservableWithRxSwift()
//        self.binderAttrWithUI()
//        self.binderAttrWithReactive()
//        self.setPublishSubject()
//        self.setBehaviorSubject()
//        self.setReplaySubject()
//        self.setVariable()
//        self.setBuffer()
//        self.setWindow()
//        self.setMap()
//        self.setFlatMap()
//        self.setFlatMapLatest()
//        self.setConcatMap()
//        self.setScan()
//        self.setGroupBy()
//        self.setFilter()
//        self.setDistinctUntilChanged()
//        self.setSingle()
//        self.setElementAt()
//        self.setIgnoreElements()
//        self.setTake()
//        self.setTakeLast()
//        self.setSkip()
//        self.setSample()
//        self.setDebounce()
//        self.setAmb()
//        self.setTakeWhile()
//        self.setTakeUntil()
//        self.setSkipWhile()
//        self.setStartWith()
//        self.setMerge()
//        self.setZip()
//        self.setCombineLatest()
//        self.setWithLatestFrom()
//        self.setSwitchLatest()
//        self.setToArray()
//        self.setReduce()
//        self.setConcat()
//        self.setConnectable()
//        self.setPublish()
//        self.setReplay()
//        self.setMulticast()
//        self.setRefCount()
//        self.setShareRelay()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ZFTestVc {
    
    func createView() {
        
        self.label = UILabel.init(frame: CGRect.init(x: 20, y:86, width: UIScreen.main.bounds.size.width, height: 40))
        label.text = "我是测试";
        view.addSubview(self.label)
    }
    
    //MARK:---------------------观察者绑定---------------------
    
//    使用三种方法绑定观察者
    func setObserverWithBind() {
        //Observable序列（每隔1秒钟发出一个索引数）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map{"当前索引数：\($0)"}
            .bind{[weak self](text) in
                self?.label.text = text
            }
            .disposed(by: disposeBag)
    }
    
    func setObservableWithBindTo() {
        //观察者
        let observer : AnyObserver<String> = AnyObserver{[weak self](event) in
            switch event {
            case .next(let text):
                self?.label.text = text
                
            default:
                break
            }
        }
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map{"当前索引数：\($0)"}
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
    
    func setObserverWithBinder() {
        //观察者
        let observer: Binder<String> = Binder(label){ (view, text) in
            //收到发出的索引数显示到label上
            view.text = text
        }
        
        //observable序列（每隔1秒发出一个索引）
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map {"当前索引数：\($0)"}
            .bind(to: observer)
            .disposed(by: disposeBag)
    }
    
    //可以不使用观察者，直接使用RXSwift为我们绑定的属性即可
    func setObservableWithRxSwift() {
        let observable = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        observable
            .map{"当前索引数：\($0)"}
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
    }
    
    //MARK:---------------------属性的绑定---------------------
    
    //通过对 UI 类进行扩展，测试绑定属性
    func binderAttrWithUI() {
        //每隔0.5秒发出一个索引
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable
            .map{CGFloat($0)}
            .bind(to: label.fontSize)//根据索引数不断方法字体
            .disposed(by: disposeBag)
    }
    
    //通过对 Reactive 类进行扩展，测试绑定属性
    func binderAttrWithReactive() {
        let observable = Observable<Int>.interval(0.5, scheduler: MainScheduler.instance)
        observable
            .map{CGFloat($0)}
            .bind(to: label.rx.fontSize)
            .disposed(by: disposeBag)
    }
    
    //MARK: ---------------------Subjects---------------------
    //Subjects 既是订阅者，也是 Observable：一共有四种 Subjects，分别为：PublishSubject、BehaviorSubject、ReplaySubject、Variable。他们之间既有各自的特点，也有相同之处：
    
    //publishSubject
    //PublishSubject是最普通的 Subject，它不需要初始值就能创建。
    // PublishSubject 的订阅者从他们开始订阅的时间点起，可以收到订阅后 Subject 发出的新 Event，而不会收到他们在订阅前已发出的 Event。
    
    func setPublishSubject() {
        //创建publishSubject
        let subject = PublishSubject<String>()
        //由于当前没有订阅者，这条消息不会打印到控制台
        subject.onNext("没有订阅者订阅此内容")
        
        //第一次订阅subject
        subject.subscribe(onNext:{string in
            print("第一滴订阅：",string)
        }, onCompleted:{
            print("第一次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有一个订阅，该消息输出到控制台
        subject.onNext("我订阅了1111")
        
        
        
        //在主线程执行subscribe
        subject.observeOn(ConcurrentDispatchQueueScheduler.init(qos: DispatchQoS.userInteractive))
            .subscribeOn(MainScheduler.instance)
            .subscribe(onNext: { string in
                
            }, onError: {error in
                
            }, onCompleted: {
                
            }).disposed(by: disposeBag)
        
        //第二次订阅
        subject.subscribe(onNext:{string in
            print("第二次订阅：",string)
        }, onCompleted:{
            print("第二次订阅：onCompleted")
        }).disposed(by: disposeBag)
        
        //当前有两个订阅，该消息会输出到控制台
        subject.onNext("我订阅了2222")
        
        //让subject结束
        subject.onCompleted()
        
        //subject完成后会发出.next事件了
        subject.onNext("44444")
        
        //subject完成后它的所有订阅（包括结束后的订阅），都能收到subject的.completed事件，
        subject.subscribe(onNext:{string in
            print("第三次订阅：",string)
        }, onCompleted:{
            print("第三次订阅：onCompleted")
        }).disposed(by: disposeBag)
    }
    
    //BehaviorSubject
    //BehaviorSubject 需要通过一个默认初始值来创建。
    //当一个订阅者来订阅它的时候，这个订阅者会立即收到 BehaviorSubjects 上一个发出的event。之后就跟正常的情况一样，它也会接收到 BehaviorSubject 之后发出的新的 event。
    func setBehaviorSubject() {
        //创建BehaviorSubject
        let subject = BehaviorSubject(value: "1111")
        
        //第一次订阅
        subject.subscribe { event in
            print("第一个次订阅：",event)
        }.disposed(by: disposeBag)
        
        //发送.next事件
        subject.onNext("222")
        
        //发送error事件
        subject.onError(NSError(domain: "local", code: 0, userInfo: nil))
        
        //第二次订阅
        subject.subscribe { (event) in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
    }
    
    //ReplaySubject
//    ReplaySubject 在创建时候需要设置一个 bufferSize，表示它对于它发送过的 event 的缓存个数。
//    比如一个 ReplaySubject 的 bufferSize 设置为 2，它发出了 3 个 .next 的 event，那么它会将后两个（最近的两个）event 给缓存起来。此时如果有一个 subscriber 订阅了这个 ReplaySubject，那么这个 subscriber 就会立即收到前面缓存的两个.next 的 event。
//    如果一个 subscriber 订阅已经结束的 ReplaySubject，除了会收到缓存的 .next 的 event外，还会收到那个终结的 .error 或者 .complete 的event。
    func setReplaySubject() {
        //创建buffersize = 2的ReplaySubject
        let subject = ReplaySubject<String>.create(bufferSize: 2)
        
        //连续发送3个next事件
        subject.onNext("111")
        subject.onNext("222")
        subject.onNext("333")
        
        //第一次订阅subject
        subject.subscribe { (event) in
            print("第一次订阅:",event)
        }.disposed(by: disposeBag)
        
        //在发送一个next事件
        subject.onNext("444")
        
        //第二次订阅
        subject.subscribe { (event) in
            print("第二次订阅：",event)
        }.disposed(by: disposeBag)
        
        //让subject结束
        subject.onCompleted()
        
        //第三次订阅
        subject.subscribe { (event) in
            print("第三次订阅:",event)
        }.disposed(by: disposeBag)
    }
    
    //Variable
//    Variable 其实就是对 BehaviorSubject 的封装，所以它也必须要通过一个默认的初始值进行创建。
//    Variable 具有 BehaviorSubject 的功能，能够向它的订阅者发出上一个 event 以及之后新创建的 event。
//    不同的是，Variable 还会把当前发出的值保存为自己的状态。同时它会在销毁时自动发送 .complete的 event，不需要也不能手动给 Variables 发送 completed或者 error 事件来结束它。
//    简单地说就是 Variable 有一个 value 属性，我们改变这个 value 属性的值就相当于调用一般 Subjects 的 onNext() 方法，而这个最新的 onNext() 的值就被保存在 value 属性里了，直到我们再次修改它。
    func setVariable() {
        let variable = Variable("111")
        
        //修改value值
        variable.value = "222"
        
        //第一次订阅
        variable.asObservable().subscribe {
            print("第一次订阅",$0)
        }.disposed(by: disposeBag)
        //修改value值
        variable.value = "333"
        //第二次订阅
        variable.asObservable().subscribe {
            print("第二次订阅",$0)
        }.disposed(by: disposeBag)
        variable.value = "444"
        //该方法调用完毕，variable会自动发出.completed事件，会自动销毁该对象
    }
    
    //MARK:---------------------变换操作（Transforming Observables）---------------------
    
    //1、buffer
//    buffer 方法作用是缓冲组合，第一个参数是缓冲时间，第二个参数是缓冲个数，第三个参数是线程。
//    该方法简单来说就是缓存 Observable 中发出的新元素，当元素达到某个数量，或者经过了特定的时间，它就会将这个元素集合发送出来。
    
    func setBuffer() {
        let subject = PublishSubject<String>()
        
        //每缓存3个元素则组合起来一起发出。
        //如果1秒钟内不够3个也会发出（有几个发几个，一个都没有发空数组 []）
        subject
            .buffer(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
    }
    
    //2、window
//    window 操作符和 buffer 十分相似。不过 buffer 是周期性的将缓存的元素集合发送出来，而 window 周期性的将元素集合以 Observable 的形态发送出来。
//    同时 buffer要等到元素搜集完毕后，才会发出元素序列。而 window 可以实时发出元素序列。
    func setWindow() {
        let subject = PublishSubject<String>()
        //每三个元素作为一个子Observer发出
        subject.window(timeSpan: 1, count: 3, scheduler: MainScheduler.instance)
            .subscribe(onNext:{[weak self] in
                print("subscribe:\($0)")
                $0.asObservable()
                    .subscribe(onNext:{print($0)})
                    .disposed(by: self!.disposeBag)
            })
            .disposed(by: disposeBag)
        
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("a")
        subject.onNext("b")
        subject.onNext("c")
    }
    
    //3、map
//    该操作符通过传入一个函数闭包把原来的 Observable 序列转变为一个新的 Observable 序列。
    func setMap() {
        Observable.of(1,2,3)
            .map{$0 * 10}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
    }
    
    //4、flatMap
//    map 在做转换的时候容易出现“升维”的情况。即转变之后，从一个序列变成了一个序列的序列。
//    而 flatMap 操作符会对源 Observable 的每一个元素应用一个转换方法，将他们转换成 Observables。 然后将这些 Observables 的元素合并之后再发送出来。即又将其 "拍扁"（降维）成一个 Observable 序列。
//    这个操作符是非常有用的。比如当 Observable 的元素本生拥有其他的 Observable 时，我们可以将所有子 Observables 的元素发送出来。
    
    func setFlatMap() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let variable = Variable(subject1)

        variable.asObservable()
            .flatMap{$0}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        //输出：A、B、1、2、C
    }
    
    //5、flatMapLatest
//    flatMapLatest与flatMap 的唯一区别是：flatMapLatest只会接收最新的value 事件。
    func setFlatMapLatest() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let variable = Variable(subject1)
        
        variable.asObservable()
            .flatMapLatest{$0}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        //输出：A、B、1、2
    }
    
    //6、concatMap
//    concatMap 与 flatMap 的唯一区别是：当前一个 Observable 元素发送完毕后，后一个Observable 才可以开始发出元素。或者说等待前一个 Observable 产生完成事件后，才对后一个 Observable 进行订阅。
    func setConcatMap() {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let variable = Variable(subject1)
        
        variable.asObservable()
            .concatMap{$0}
            .subscribe(onNext:{print($0)})
        .disposed(by: disposeBag)
        subject1.onNext("B")
        variable.value = subject2
        subject2.onNext("2")
        subject1.onNext("C")
        subject1.onCompleted()//只有前一个序列结束才能接受下一个序列
        //输出：A、B、C、2
    }
    
    //7、scan
//    scan 就是先给一个初始化的数，然后不断的拿前一个结果和最新的值进行处理操作。
    func setScan() {
        Observable.of(1,2,3,4,5)
            .scan(0){acum,elem in
                acum + elem
            }
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //输出：1、3、6、10、15
    }
    
    //8、groupBy
//    groupBy 操作符将源 Observable 分解为多个子 Observable，然后将这些子 Observable 发送出来。
//    也就是说该操作符会将元素通过某个键进行分组，然后将分组后的元素序列以 Observable 的形态发送出来。
    func setGroupBy() {
        //将奇数偶数分成两组
        Observable<Int>.of(0,1,2,3,4,5,6)
            .groupBy(keySelector: {(element) -> String in
                return element % 2 == 0 ? "偶数" : "奇数"
            })
            .subscribe{(event) in
                switch event {
                case .next(let group):
                    group.asObservable().subscribe({(event) in
                        print("key:\(group.key)   event:\(event)")
                    })
                        .disposed(by: self.disposeBag)
                default:
                    print("")
                }
            }
            .disposed(by: disposeBag)
    }
    
    //MARK:---------------------过滤操作符（Filtering Observables）---------------------
    //1、filter
    //该操作符就是用来过滤掉某些不符合要求的事件
    func setFilter() {
        Observable.of(2,34,24,43,4,63,23)
            .filter{
                $0 > 10     //过滤掉小于10的数
            }
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
    }
    
    //2、distinctUntilChanged
    //该操作符用于过滤掉连续重复的事件。
    func setDistinctUntilChanged()  {
        Observable.of(1,23,1,4,5,4)
            .distinctUntilChanged()     //过滤掉重复的1和4
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
    }
    
    //3、single
//    限制只发送一次事件，或者满足条件的第一个事件。
//    如果存在有多个事件或者没有事件都会发出一个 error 事件。
//    如果只有一个事件，则不会发出 error事件。
    func setSingle() {
        Observable.of(1,2,3,4)
            .single{$0 == 2}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        Observable.of("A","B","C","D")
            .single()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：2、A
    }
    
    //4、elementAt
    //该方法实现只处理在指定位置的事件。
    func setElementAt() {
        Observable.of(1,2,3,4)
            .elementAt(2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：3
    }
    
    //5、ignoreElements
    //该操作符可以忽略掉所有的元素，只发出 error或completed 事件。
    //如果我们并不关心 Observable 的任何元素，只想知道 Observable 在什么时候终止，那就可以使用 ignoreElements 操作符。
    func setIgnoreElements() {
        Observable.of(1,2,3,4)
            .ignoreElements()
            .subscribe({print($0)})
            .disposed(by: disposeBag)
        //输出：completed
    }
    
    //6、take
    //该方法实现仅发送 Observable 序列中的前 n 个事件，在满足数量之后会自动 .completed
    func setTake() {
        Observable.of(1,2,3,4)
            .take(2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //输出：1，2
    }
    
    //7、takeLast
    //该方法实现仅发送 Observable序列中的后 n 个事件。
    func setTakeLast() {
        Observable.of(1,2,3,4)
            .takeLast(2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //输出：3，4
    }
    
    //8、skip
    //该方法用于跳过源 Observable 序列发出的前 n 个事件
    func setSkip()  {
        Observable.of(1,2,3,4)
            .skip(2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //输出结果：3，4
    }
    
    //9、sample
    //Sample 除了订阅源Observable 外，还可以监视另外一个 Observable， 即 notifier 。
    //每当收到 notifier 事件，就会从源序列取一个最新的事件并发送。而如果两次 notifier 事件之间没有源序列的事件，则不发送值。
    func setSample() {
        let source = PublishSubject<Int>()
        let notifier = PublishSubject<String>()
        
        source
            .sample(notifier)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        source.onNext(1)
        
        //让源序列接受消息
        notifier.onNext("A")
        source.onNext(2)
        
        //让源序列接受消息
        notifier.onNext("B")
        notifier.onNext("C")
        
        source.onNext(3)
        source.onNext(4)
        
        //让源序列接受消息
        notifier.onNext("D")
        
        source.onNext(5)

        notifier.onCompleted()
        //运行结果：1，2，4，5
    }
    
    //10、debounce
    //debounce 操作符可以用来过滤掉高频产生的元素，它只会发出这种元素：该元素产生后，一段时间内没有新元素产生。
    //换句话说就是，队列中的元素如果和下一个元素的间隔小于了指定的时间间隔，那么这个元素将被过滤掉。
    //debounce 常用在用户输入的时候，不需要每个字母敲进去都发送一个事件，而是稍等一下取最后一个事件
    func setDebounce() {
        //定义好每个事件里的值以及发送的时间
        let times = [
            ["value":1, "time":0.1],
            ["value":2, "time":1.1],
            ["value":3, "time":1.2],
            ["value":4, "time":1.2],
            ["value":5, "time":1.4],
            ["value":6, "time":2.1],
        ]
        
        //生成对应的Observable序列并订阅
        Observable.from(times)
            .flatMap{item in
                return Observable.of(Int(item["value"]!))
                .delaySubscription(Double(item["time"]!), scheduler: MainScheduler.instance)
            }
            .debounce(0.5, scheduler: MainScheduler.instance) //只发出与下一个间隔超过0.5秒的元素
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：1，5，6
    }
    
    //MARK:---------------------条件和布尔操作符（Conditional and Boolean Operators）---------------------
    //1、amb
//    当传入多个 Observables 到 amb 操作符时，它将取第一个发出元素或产生事件的 Observable，然后只发出它的元素。并忽略掉其他的 Observables。
    func setAmb() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        let subject3 = PublishSubject<Int>()
        
        subject1
        .amb(subject2)
        .amb(subject3)
            .subscribe(onNext:{print($0)})
        .disposed(by: disposeBag)
        
        subject2.onNext(1)
        subject1.onNext(20)
        subject2.onNext(2)
        subject1.onNext(40)
        subject3.onNext(0)
        subject2.onNext(3)
        subject1.onNext(60)
        subject3.onNext(0)
        subject3.onNext(0)
        //运行结果：1，2，3
    }
    
    //2、takeWhile
//    该方法依次判断 Observable 序列的每一个值是否满足给定的条件。 当第一个不满足条件的值出现时，它便自动完成。
    func setTakeWhile() {
        Observable.of(2,3,4,5,6)
            .takeWhile{$0 < 4}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：2,3
    }
    
    //3、takeUntil
//    除了订阅源 Observable 外，通过 takeUntil 方法我们还可以监视另外一个 Observable， 即 notifier。
//    如果 notifier 发出值或 complete 通知，那么源 Observable 便自动完成，停止发送事件
    func setTakeUntil() {
        let source = PublishSubject<String>()
        let notifier = PublishSubject<String>()
        
        source
            .takeUntil(notifier)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        source.onNext("a")
        source.onNext("b")
        source.onNext("c")
        source.onNext("d")
        
        //停止接受消息
        notifier.onNext("z")
        
        source.onNext("e")
        source.onNext("f")
    }
    
    //4、skipWhile
//    该方法用于跳过前面所有满足条件的事件。
//    一旦遇到不满足条件的事件，之后就不会再跳过了
    
    func setSkipWhile() {
        Observable.of(2,3,4,5,6)
            .skipWhile{$0 < 4}
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：4，5，6
    }
    
    //5、skipUntil===同takeUntil相反
    
    // MARK:---------------------结合操作（Combining Observables）---------------------
    
    //1、startWith
//    该方法会在 Observable 序列开始之前插入一些事件元素。即发出事件消息之前，会先发出这些预先插入的事件消息。
    func setStartWith() {
        Observable.of(3,4,5)
            .startWith(1)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：1，3，4，5
        
        Observable.of("2","3")
            .startWith("a")
            .startWith("b")
            .startWith("c")
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：c,b,a,2,3
    }
    
    //2、merge
//    该方法可以将多个（两个或两个以上的）Observable 序列合并成一个 Observable序列。
    func setMerge() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<Int>()
        
        Observable.of(subject1,subject2)
            .merge()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject1.onNext(2)
        subject1.onNext(3)
        subject2.onNext(4)
        subject2.onNext(5)
        subject1.onNext(6)
        //运行结果：2，3，4，5，6
    }
    
    //3、zip
//    该方法可以将多个（两个或两个以上的）Observable 序列压缩成一个 Observable 序列。
//    而且它会等到每个 Observable 事件一一对应地凑齐之后再合并。
    func setZip() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.zip(subject1,subject2){
                "\($0)\($1)"
            }
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("a")
        subject1.onNext(2)
        subject2.onNext("b")
        subject2.onNext("c")
        subject2.onNext("d")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        //运行结果：1a,2b,3c,4d
    }
    
    //4、combineLatest
//    该方法同样是将多个（两个或两个以上的）Observable 序列元素进行合并。
//    但与 zip 不同的是，每当任意一个 Observable 有新的事件发出时，它会将每个 Observable 序列的最新的一个事件元素进行合并。
    func setCombineLatest() {
        let subject1 = PublishSubject<Int>()
        let subject2 = PublishSubject<String>()
        
        Observable.combineLatest(subject1, subject2) {
            "\($0)\($1)"
            }
            .subscribe(onNext: { print($0) })
            .disposed(by: disposeBag)
        
        subject1.onNext(1)
        subject2.onNext("A")
        subject1.onNext(2)
        subject2.onNext("B")
        subject2.onNext("C")
        subject2.onNext("D")
        subject1.onNext(3)
        subject1.onNext(4)
        subject1.onNext(5)
        //运行结果：1A,2A,2B,2C,2D,3D,4D,5D
    }
    
    //5、withLatestFrom
//    该方法将两个 Observable 序列合并为一个。每当 self 队列发射一个元素时，便从第二个序列中取出最新的一个值。
    func setWithLatestFrom() {
        let subject1 = PublishSubject<String>()
        let subject2 = PublishSubject<String>()
        
        subject1.withLatestFrom(subject2)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        subject1.onNext("A")
        subject2.onNext("1")
        subject1.onNext("B")
        subject1.onNext("C")
        subject2.onNext("2")
        subject1.onNext("D")
        //运行结果：1，1，2
    }
    
    //6、switchLatest
    //switchLatest 有点像其他语言的switch 方法，可以对事件流进行转换。
//    比如本来监听的 subject1，我可以通过更改 variable 里面的 value 更换事件源。变成监听 subject2。
    
    func setSwitchLatest()  {
        let subject1 = BehaviorSubject(value: "A")
        let subject2 = BehaviorSubject(value: "1")
        let variable = Variable(subject1)
        
        variable.asObservable()
            .switchLatest()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        subject1.onNext("B")
        subject1.onNext("C")
        
        //改变事件源
        variable.value = subject2
        subject1.onNext("D")
        subject2.onNext("2")
        
        //改变事件源
        variable.value = subject1
        subject2.onNext("3")
        subject1.onNext("E")
        //运行结果：A，B，C，1，2，D，E
    }
    
    //MARK:---------------------算数、以及聚合操作（Mathematical and Aggregate Operators）---------------------
    //1、toArray
//    该操作符先把一个序列转成一个数组，并作为一个单一的事件发送，然后结束
    func setToArray()  {
        Observable.of(1,2,3)
            .toArray()
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：[1,2,3]
    }
    
    //2、reduce
//    reduce 接受一个初始值，和一个操作符号。
//    reduce 将给定的初始值，与序列里的每个值进行累计运算。得到一个最终结果，并将其作为单个值发送出去。
    func setReduce() {
        Observable.of(1,2,3,4,5)
            .reduce(0, accumulator: +)
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：15
    }
    
    //3、concat
//    concat 会把多个 Observable 序列合并（串联）为一个 Observable 序列。
//    并且只有当前面一个 Observable 序列发出了 completed 事件，才会开始发送下一个 Observable 序列事件
    func setConcat() {
        let subject1 = BehaviorSubject(value: 1)
        let subject2 = BehaviorSubject(value: 2)
        
        let variable = Variable(subject1)
        variable.asObservable()
            .concat()
            .subscribe(onNext:{print($0)})
            .disposed(by:disposeBag)
        
        subject2.onNext(2)
        subject1.onNext(1)
        subject1.onNext(1)
        subject1.onCompleted()
        
        variable.value = subject2
        subject2.onNext(2)
        //运行结果：11122
    }
    
    //MARK:---------------------连接操作（Connectable Observable Operators）---------------------
    //1、connectable
//    可连接的序列（Connectable Observable）：
//    （1）可连接的序列和一般序列不同在于：有订阅时不会立刻开始发送事件消息，只有当调用 connect()之后才会开始发送值。
//    （2）可连接的序列可以让所有的订阅者订阅后，才开始发出事件消息，从而保证我们想要的所有订阅者都能接收到事件消息。
    func setConnectable()  {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance)
        //第一个订阅者，（立刻开始订阅）
        _ = interval
            .subscribe(onNext:{print("订阅1:\($0)")})
            .disposed(by: disposeBag)
        
        //第二个订阅，（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext:{print("订阅2:\($0)")})
                .disposed(by: self.disposeBag)
        }
        
    }
    /// 延迟执行
    ///
    /// - Parameters:
    ///   - delay: 延迟时间
    ///   - closure: 延迟执行的闭包
    public func delay(_ delay: Double, closure: @escaping () -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay){
            closure()
        }
    }
    
    //2、publish
//    publish 方法会将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始
    func setPublish() {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish()
        //第一个订阅者，（立刻开始订阅）
        _ = interval
            .subscribe(onNext:{print("订阅1:\($0)")})
            .disposed(by: disposeBag)
        
        //把事件推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅，（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext:{print("订阅2:\($0)")})
                .disposed(by: self.disposeBag)
        }
    }
    
    //3、replay
//    replay 同上面的 publish 方法相同之处在于：会将将一个正常的序列转换成一个可连接的序列。同时该序列不会立刻发送事件，只有在调用 connect 之后才会开始。
//    replay 与 publish 不同在于：新的订阅者还能接收到订阅之前的事件消息（数量由设置的 bufferSize 决定）。
    func setReplay() {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).replay(5)
        //第一个订阅者，（立刻开始订阅）
        _ = interval
            .subscribe(onNext:{print("订阅1:\($0)")})
            .disposed(by: disposeBag)
        
        //把事件推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅，（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext:{print("订阅2:\($0)")})
                .disposed(by: self.disposeBag)
        }
    }
    
    //4、multicast
//    multicast 方法同样是将一个正常的序列转换成一个可连接的序列。
//    同时 multicast 方法还可以传入一个 Subject，每当序列发送事件时都会触发这个 Subject 的发送。
    func setMulticast() {
        let subject = PublishSubject<Int>()
        //subject的订阅
        _ = subject
            .subscribe(onNext:{print("Subject：\($0)")})
            .disposed(by: disposeBag)
        
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).multicast(subject)
        //第一个订阅者，（立刻开始订阅）
        _ = interval
            .subscribe(onNext:{print("订阅1:\($0)")})
            .disposed(by: disposeBag)
        
        //把事件推迟了两秒
        delay(2) {
            _ = interval.connect()
        }
        
        //第二个订阅，（延迟5秒开始订阅）
        delay(5) {
            _ = interval
                .subscribe(onNext:{print("订阅2:\($0)")})
                .disposed(by: self.disposeBag)
        }
    }
    
    //5、refCount
//    refCount 操作符可以将可被连接的 Observable 转换为普通 Observable
//    即该操作符可以自动连接和断开可连接的 Observable。当第一个观察者对可连接的Observable 订阅时，那么底层的 Observable 将被自动连接。当最后一个观察者离开时，那么底层的 Observable 将被自动断开连接。
    func setRefCount() {
        let intervar = Observable<Int>.interval(1, scheduler: MainScheduler.instance).publish().refCount()
        
        _ = intervar
            .subscribe(onNext:{print("第一个订阅：\($0)")})
            .disposed(by: disposeBag)
        
        delay(5) {
            _ = intervar
                .subscribe(onNext:{print("第二个订阅：\($0)")})
                .disposed(by: self.disposeBag)
        }
    }
    
    //6、share（relay：）
//    该操作符将使得观察者共享源 Observable，并且缓存最新的 n 个元素，将这些元素直接发送给新的观察者。
//    简单来说 shareReplay 就是 replay 和 refCount 的组合。
    func setShareRelay()  {
        let interval = Observable<Int>.interval(1, scheduler: MainScheduler.instance).share(replay: 5)
        
        _ = interval
            .subscribe(onNext:{print("第一个订阅者：\($0)")})
            .disposed(by: disposeBag)
        
        delay(5) {
            _ = interval
                .subscribe(onNext:{print("第二个订阅者:\($0)")})
                .disposed(by: self.disposeBag)
        }
        
    }
    
    //MARK:---------------------错误处理操作（Error Handling Operators）-------------
    //1、catchErrorJustReturn
//    当遇到 error 事件的时候，就返回指定的值，然后结束
    func setCatchErrorJustReturn() {
        let sequenceThatFails = PublishSubject<String>()
        
        sequenceThatFails
            .catchErrorJustReturn("错误")
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("A")
        sequenceThatFails.onNext("B")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("C")
        //运行结果：A，B，C，错误
    }
    
    //2、catchError
//    该方法可以捕获 error，并对其进行处理。
//    同时还能返回另一个 Observable 序列进行订阅（切换到新的序列）。
    func setCatchError() {
        let sequenceThatFails = PublishSubject<String>()
        let recoverySequence = Observable.of("1","2","3")
        
        sequenceThatFails
            .catchError {
                print("error:",$0)
                return recoverySequence
            }
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        
        sequenceThatFails.onNext("A")
        sequenceThatFails.onNext("B")
        sequenceThatFails.onError(MyError.A)
        sequenceThatFails.onNext("C")
        //运行结果：A,B,error:A,1,2,3
    }
    
    //3、retry
//    使用该方法当遇到错误的时候，会重新订阅该序列。比如遇到网络请求失败时，可以进行重新连接。
//    retry() 方法可以传入数字表示重试次数。不传的话只会重试一次
    func setRetry() {
        var count = 1
        
        let sequenceThatError = Observable<String>.create { observer in
            observer.onNext("a")
            observer.onNext("b")
            
            //让第一个订阅发生错误时
            if count == 1 {
                observer.onError(MyError.A)
                print("Error encounted")
                count += 1
            }
            observer.onNext("c")
            observer.onNext("d")
            observer.onCompleted()
            return Disposables.create()
        }
        
        sequenceThatError
            .retry(2)       //重复两次，参数为空，重复一次
            .subscribe(onNext:{print($0)})
            .disposed(by: disposeBag)
        //运行结果：a,b,Error encounted,a,b,c,d
    }
}

//通过对 Reactive 类进行扩展
extension Reactive where Base : UILabel {
    public var fontSize:Binder<CGFloat> {
        return Binder(self.base) {label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}

//通过对 UI 类进行扩展
extension UILabel {
    //绑定属性
    public var fontSize:Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
