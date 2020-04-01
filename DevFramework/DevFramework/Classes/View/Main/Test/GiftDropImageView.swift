//
//  FreeGiftAnimation.swift
//  PopVoiceLive
//
//  Created by macode on 2019/12/26.
//  Copyright © 2019 Talla. All rights reserved.
//

import RxSwift
import UIKit

class GiftDropImageView: UIImageView {
    let tapGiftObserver: PublishSubject = PublishSubject<Any>()
    var animationTime = 10.0
    var imageHeight: CGFloat = 90.0
    var keyAnimation: CAKeyframeAnimation?
    private var tapGesture: UITapGestureRecognizer!

    /// 用户点击礼物，动画到背包中的动画
    /// - Parameter rect: 终点坐标
    func endPoint(rect: CGRect) -> Observable<Any> {
        return Observable<Any>.create { [unowned self] (observer) -> Disposable in
            UIView.animate(withDuration: 1, animations: {
                let centerX = rect.origin.x + rect.width / 2
                let centerY = rect.origin.y + rect.height / 2
                self.frame = CGRect(x: centerX, y: centerY, width: 10, height: 10)
            }) { animate in
                if animate {
                    self.removeAll()
                    observer.onNext("")
                }
            }
            return Disposables.create()
        }
    }

    func showAnimation(fromView: UIView) {
        fromView.addSubview(self)
        startAnimation()
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickGiftImageViewAction))
        fromView.addGestureRecognizer(tapGesture)
        perform(#selector(removeAll), with: "cancelAnimation", afterDelay: animationTime)
    }

    init(imageUrl: String) {
        super.init(frame: CGRect())
        loadSubviews()
    }

    private func loadSubviews() {
        image = UIImage(named: "icon_party_freegift")
        contentMode = UIView.ContentMode.scaleAspectFit
        frame = CGRect(x: screenWidth / 2, y: -imageHeight / 2, width: imageHeight, height: imageHeight)
    }

    private func startAnimation() {
        keyAnimation = CAKeyframeAnimation(keyPath: "position")
        let val = NSValue(cgPoint: CGPoint(x: screenWidth / 2, y: -30))
        let val1 = NSValue(cgPoint: CGPoint(x: 100 + Int(arc4random() % 201), y: 100 + Int(arc4random() % 101)))
        let val2 = NSValue(cgPoint: CGPoint(x: 100 + Int(arc4random() % 201), y: 300 + Int(arc4random() % 301)))
        let val3 = NSValue(cgPoint: CGPoint(x: 100.0 + (CGFloat)(Int(arc4random() % 201)), y: screenHeight + height))

        let values = [val, val1, val2, val3]
        keyAnimation!.values = values
        keyAnimation!.duration = animationTime
        keyAnimation!.timingFunction = CAMediaTimingFunction(name: .linear)
        keyAnimation!.isRemovedOnCompletion = false
        keyAnimation!.fillMode = CAMediaTimingFillMode.forwards
        keyAnimation!.calculationMode = CAAnimationCalculationMode.paced
        layer.add(keyAnimation!, forKey: "gift")
    }

    @objc private func clickGiftImageViewAction(sender: UITapGestureRecognizer) {
        let touchPoint = sender.location(in: superview)
//        guard let giftLayer = layer.presentation()?.hitTest(touchPoint) else { return }
//        layer.removeAllAnimations()
//        frame = giftLayer.frame
//        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(removeAll), object: "cancelAnimation")
//        tapGiftObserver.onNext("")
        if layer.presentation()?.hitTest(touchPoint) != nil {
            if keyAnimation != nil {
                CATransaction.begin()
                CATransaction.setAnimationDuration(1)
                layer.backgroundColor = UIColor.yellow.cgColor
                CATransaction.commit()
                
            }
        }
    }

    @objc private func removeAll() {
        layer.removeAllAnimations()
        if tapGesture != nil {
            self.superview?.removeGestureRecognizer(tapGesture)
            tapGesture.removeTarget(self, action: #selector(clickGiftImageViewAction))
            tapGesture = nil
        }
        removeFromSuperview()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
