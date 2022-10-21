//
//  SSAlertDefaultAnmation.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation
extension SSAlertDefaultAnmation {
    public enum State {
        case fromTop, fromLeft, fromBottom, fromRight, fromCenter
    }
}


open class SSAlertDefaultAnmation: NSObject {
    public var state: State
    /// 中心点偏移原来位置位移
    public var centerOffset: CGPoint = .zero
    /// 动画的时间
    public var duration: TimeInterval = 0.3
    /// 展示动画是否开启弹簧效果
    public var isSpringShowAnimation: Bool = true
    /// 滑动消失距离触发
    public var panDimissProgress: CGFloat = 0.4
    public var usingSpringWithDamping: CGFloat = 0.8
    public var initialSpringVelocity: CGFloat = 0.5
    private weak var animationView: SSAlertView? = nil
    public init(state: State) {
        self.state = state
        super.init()
    }
    
    private func animation(animated: Bool, isSpringAnimation: Bool = true, animations: @escaping (() -> Void), completion: ((Bool) -> Void)? = nil) {
        if animated {
            if isSpringAnimation {
                UIView.animate(withDuration: animationDuration(),
                               delay: 0,
                               usingSpringWithDamping: usingSpringWithDamping,
                               initialSpringVelocity: initialSpringVelocity,
                               options: [],
                               animations: animations,
                               completion: completion)
            } else {
                UIView.animate(withDuration: animationDuration(),
                               animations: animations,
                               completion: completion)
            }
            
        } else {
            animations()
            if let completion = completion {
                completion(true)
            }
        }
    }
    
    
    public func setCenterOffset(center offset: CGPoint, duration: TimeInterval = 0.3, animated: Bool = true, completion:((Bool) -> Void)?) {
        self.duration = duration
        self.animation(animated: animated, animations: {
            self.animationView?.transform = CGAffineTransform.init(translationX: offset.x, y: offset.y)
        }, completion: completion)
        
    }
}

extension SSAlertDefaultAnmation: SSAlertAnimation {
    public func animationDuration() -> TimeInterval {
        return duration
    }
    
    public func showAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion: (((Bool) -> Void))?) {
        guard let animationSuperView = animationView.superview else {
            return
        }
        self.animationView = animationView
        animationView.alpha = 1
        animationView.ss_size = viewSize
        switch state {
            case .fromBottom:
                animationView.ss_centerX = animationSuperView.ss_w / 2 + centerOffset.x
                animationView.ss_y = animationSuperView.ss_h
                animation(animated: animated, isSpringAnimation: isSpringShowAnimation, animations: { [weak self] in guard let self = self else { return }
                    animationView.transform = CGAffineTransform.init(translationX: 0, y: -animationView.ss_h + self.centerOffset.y)
                    animationView.backgroundMask?.alpha = 1;
                }, completion: completion)
                
            case .fromTop:
                animationView.ss_centerX = animationSuperView.ss_w / 2 + centerOffset.x
                animationView.ss_y = -animationView.ss_h
                animation(animated: animated, isSpringAnimation: isSpringShowAnimation, animations: { [weak self] in guard let self = self else { return }
                    animationView.transform = CGAffineTransform.init(translationX: 0, y: animationView.ss_h + self.centerOffset.y)
                    animationView.backgroundMask?.alpha = 1;
                }, completion: completion)
                
            case .fromLeft:
                animationView.ss_centerY = animationSuperView.ss_h / 2 + centerOffset.y
                animationView.ss_x = -animationView.ss_w
                animation(animated: animated, isSpringAnimation: isSpringShowAnimation, animations: {
                    animationView.transform = CGAffineTransform.init(translationX: animationView.ss_w + self.centerOffset.x, y: 0)
                    animationView.backgroundMask?.alpha = 1;
                }, completion: completion)
                
            case .fromRight:
                animationView.ss_centerY = animationSuperView.ss_h / 2 + centerOffset.y
                animationView.ss_x = animationSuperView.ss_w
                animation(animated: animated, isSpringAnimation: isSpringShowAnimation, animations: {
                    animationView.transform = CGAffineTransform.init(translationX: -animationView.ss_w + self.centerOffset.x, y: 0)
                    animationView.backgroundMask?.alpha = 1;
                }, completion: completion)
                
            case .fromCenter:
                animationView.ss_centerX = animationSuperView.ss_w / 2 + centerOffset.x
                animationView.ss_centerY = animationSuperView.ss_h / 2 + centerOffset.y
                animationView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                animationView.alpha = 0
                animation(animated: animated, isSpringAnimation: isSpringShowAnimation, animations: {
                    animationView.alpha = 1
                    animationView.transform = CGAffineTransform.identity
                    animationView.backgroundMask?.alpha = 1;
                }, completion: completion)
                
        }
    }
    
    public func hideAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion: (((Bool) -> Bool))?) {
        self.animationView = animationView
        animation(animated: animated, isSpringAnimation: false, animations: {
            if self.state == .fromCenter {
                animationView.alpha = 0
            } else {
                animationView.transform = CGAffineTransform.identity
            }
            animationView.backgroundMask?.alpha = 0
        }, completion: {
            finished in
            var isCancel = false
            if let completion = completion {
                isCancel = completion(finished)
            }
            if !isCancel {
                animationView.removeFromSuperview()
                animationView.backgroundMask?.removeFromSuperview()
                self.animationView = nil
            }
        })
    }
    
    public func refreshAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion: (((Bool) -> Void))?) {
        guard let animationSuperView = animationView.superview else {
            return
        }
        self.animationView = animationView
        animationView.alpha = 1
        animationView.ss_size = viewSize
        switch state {
            case .fromBottom:
                animationView.ss_centerX = animationSuperView.ss_w / 2.0 + centerOffset.x
                animation(animated: animated, animations: {
                    animationView.ss_y = animationSuperView.ss_h - viewSize.height + self.centerOffset.y
                }, completion: completion)
                
            case .fromTop:
                animationView.ss_centerX = animationSuperView.ss_w / 2.0 + centerOffset.x
                animation(animated: animated, animations: {
                    animationView.ss_y =  self.centerOffset.y
                }, completion: completion)
                
            case .fromLeft:
                animationView.ss_centerY = animationSuperView.ss_h / 2.0 + centerOffset.y
                animation(animated: animated, animations: {
                    animationView.ss_x =  self.centerOffset.x
                }, completion: completion)
                
            case .fromRight:
                animationView.ss_centerY = animationSuperView.ss_h / 2.0 + centerOffset.y
                animation(animated: animated, animations: {
                    animationView.ss_x = animationSuperView.ss_w - viewSize.width +  self.centerOffset.x
                }, completion: completion)
                
            case .fromCenter:
                animationView.alpha = 0
                animationView.ss_centerX = animationSuperView.ss_w / 2 + centerOffset.x
                animationView.ss_centerY = animationSuperView.ss_h / 2 + centerOffset.y
                animationView.transform = CGAffineTransform.init(scaleX: 1.5, y: 1.5)
                animation(animated: animated, animations: {
                    animationView.alpha = 1
                    animationView.transform = CGAffineTransform.identity
                }, completion: completion)
                
        }
    }
    
    public func panToDimissTransilatePoint(point: CGPoint, panViewFrame: CGRect) -> (PanProgress, PanCancelProgress) {
        var progress: CGFloat = 0
        switch state {
            case .fromTop:
                if point.y <= 0 {
                    progress = abs(point.y / panViewFrame.height)
                }
            case .fromBottom:
                if point.y >= 0 {
                    progress = abs(point.y / panViewFrame.height)
                }
                
            case .fromLeft:
                if point.x <= 0 {
                    progress = abs(point.x / panViewFrame.width)
                }
                
            case .fromRight:
                if point.x >= 0 {
                    progress = abs(point.x / panViewFrame.width)
                }
            case .fromCenter:
                progress = abs(point.y / panViewFrame.height)
        }
        return (progress, panDimissProgress)
    }
}


