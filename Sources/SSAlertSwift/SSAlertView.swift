//
//  SSAlertView.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import UIKit

extension SSAlertView {
    public enum BackgroundMaskType {
        /// 默认没有遮罩
        case none
        
        /// 透明遮罩
        case clear
        
        /// 黑色遮罩
        case black
    }
}


open class SSAlertView: UIView {
    /// customView 的内间距
    public var customEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            setNeedsDisplay()
            layoutIfNeeded()
        }
    }
    
    /// 展示和隐藏动画设置
    public var animation: SSAlertAnimation
    
    ///遮罩视图
    public private(set) var backgroundMask: UIView?
    
    /// 是否点击遮罩隐藏，默认点击会隐藏
    public var canTouchMaskHide: Bool = true
    /// 点击遮罩隐藏是否开启动画，默认nil,跟随展示的时候设置是否开启动画
    public var isTouchMaskHideAnimated: Bool? = nil
    
    /// 模态视图弹窗才有
    public private(set) weak var navigationController: UINavigationController?
    
    private var onView: UIView
    public private(set)  var maskType: BackgroundMaskType
    public private(set) var customView: UIView
    private weak var fromViewController: UIViewController?
    private weak var toViewContrller: UIViewController?
    private var presentAnimation: SSAlertPresentAnimation?
    private var canPanDimiss: Bool = false
    private var hideCompletion: (() -> Void)? = nil
    /// 初始化（普通视图弹窗）
    public init(customView: UIView,
                onView: UIView,
                animation: SSAlertDefaultAnmation = SSAlertDefaultAnmation(state: .fromCenter),
                maskType: BackgroundMaskType = .black) {
        self.animation = animation
        self.onView = onView
        self.maskType = maskType
        self.customView = customView
        super.init(frame: .zero)
        makeUI()
    }
    
    /// 初始化（模态视图弹窗）
    public convenience init(customView: UIView,
                fromViewController: UIViewController,
                animation: SSAlertDefaultAnmation = SSAlertDefaultAnmation(state: .fromCenter),
                navigationControllerClass: UINavigationController.Type = UINavigationController.self,
                maskType: BackgroundMaskType = .black,
                canPanDimiss: Bool = true) {
        let animaionVC = SSAlertAnimationController()
        self.init(customView: customView, onView: animaionVC.view, animation: animation, maskType: maskType)
        self.canPanDimiss = canPanDimiss
        self.fromViewController = fromViewController
        let nav = navigationControllerClass.init(rootViewController: animaionVC)
        nav.modalPresentationStyle = .custom
        self.navigationController = nav
        self.canPanDimiss = canPanDimiss
        let animation = SSAlertPresentAnimation(navigationViewController: nav, animationView: customView, canPanDimiss: canPanDimiss)
        self.navigationController!.transitioningDelegate = animation
        self.navigationController!.modalPresentationCapturesStatusBarAppearance = true
        self.presentAnimation = animation
        self.toViewContrller = animaionVC
        
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        backgroundMask?.frame = CGRect(x: 0, y: 0, width: onView.ss_w, height: onView.ss_h)
        customView.ss_x = customEdgeInsets.left
        customView.ss_y = customEdgeInsets.top
        customView.ss_w = frame.width - customEdgeInsets.left - customEdgeInsets.right
        customView.ss_h = frame.height - customEdgeInsets.top - customEdgeInsets.bottom
    }
    
    
    private func makeUI() {
        if maskType != .none {
            let backgroundMask = UIButton()
            backgroundMask.alpha = 0
            onView.addSubview(backgroundMask)
            backgroundMask.addTarget(self, action: #selector(backgroundMaskAction), for: .touchUpInside)
            self.backgroundMask = backgroundMask
            if maskType == .black {
                backgroundMask.backgroundColor = UIColor.black.withAlphaComponent(0.3)
            }
        }
        addSubview(customView)
        onView.addSubview(self)
    }
    /// 展示
    public func show(animated: Bool = true) {
        if navigationController != nil {
            presentView(animated: animated)
        } else {
            showView(animated: animated)
        }
    }
    /// 隐藏
    public func hide(animated: Bool = true) {
        if navigationController != nil {
            dimissView(animated: animated)
        } else {
            hideView(animated: animated)
        }
    }
    
    /// 展示（普通视图弹窗）
    /// - Parameter animated: 是否动画
    private func showView(animated: Bool = true) {
        isTouchMaskHideAnimated = animated
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        animation.showAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated, completion: nil)
    }
    /// 隐藏（普通视图弹窗）
    /// - Parameter animated: 是否动画
    private func hideView(animated: Bool = true) {
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        animation.hideAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated) { _ in
            return false
        }
        if let hideCompletion = hideCompletion {
            hideCompletion()
        }
    }
    /// 展示（模态视图弹窗）
    /// - Parameter animated: 是否动画
    private func presentView(animated: Bool = true) {
        isTouchMaskHideAnimated = animated
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        presentAnimation?.animationCompletion(showAnimation: {
            [weak self] in guard let self = self else { return }
            self.animation.showAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated) { _ in
                self.presentAnimation?.setCompleteTransitionIsHide(isHide: false)
            }
        })
        self.presentAnimation?.duration = animation.animationDuration()
        ///存在的问题： app当前显示的是弹窗界面，默认presnent出来的视图且modalPresentationStyle不是CurrentContext这这种，这个视图的presentingVC默认根控制器，例如存在tabbarVC的话就是tabbarVC，这个会造成一个问题：当这个视图dimiss的时候，会把所有的presentedVC都dimiss（其实调用dimiss的时候是调用当前视图的presentigngVC去dimiss,遵循随创建随释放）
        /// 这个通过设置 definesPresentationContext = true,modalPresentationStyle = UIModalPresentationOverCurrentContext，这样当前视图的presentigngVC为 self.navigationController,
        /// UIModalPresentationOverCurrentContext和 UIModalPresentationCurrentContext的区别是弹出的界面，前者不会把底部的视图stact移除，后者则会。
        self.navigationController?.definesPresentationContext = true
        self.navigationController?.modalPresentationStyle = .overCurrentContext
        self.fromViewController?.present(self.navigationController!, animated: animated, completion: nil)
        if canPanDimiss {
            dimissViewDragToHideAnimation(animated: animated)
        }
    }
    /// 隐藏（模态视图弹窗）
    /// - Parameter animated: 是否动画
    private func dimissView(animated: Bool = true) {
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        presentAnimation?.animationCompletion(hideAnimation: {
            [weak self] in guard let self = self else { return }
            self.animation.hideAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated) { _ in
                return self.presentAnimation!.setCompleteTransitionIsHide(isHide: true)
            }
        })
        self.presentAnimation?.duration = animation.animationDuration()
        self.toViewContrller?.dismiss(animated: animated, completion: {
            if let hideCompletion = self.hideCompletion {
                hideCompletion()
            }
        })
    }
    
    private func dimissViewDragToHideAnimation(animated: Bool) {
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        presentAnimation?.animationCompletion(hideAnimation: {
            [weak self] in guard let self = self else { return }
            self.animation.hideAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated) { _ in
                return self.presentAnimation!.setCompleteTransitionIsHide(isHide: true)
            }
        },endCompletion: {
            [weak self] in guard let self = self else { return }
            if let hideCompletion = self.hideCompletion {
                hideCompletion()
            }
        }, panDimissAnimation: { [weak self] point, frame in
             guard let self = self else { return 0 }
            return self.animation.panToDimissTransilatePoint(point: point, panViewFrame: frame)
        })
        self.presentAnimation?.duration = animation.animationDuration()
    }
    
    public func refreshFrame(animated: Bool = true) {
        var customSize = customView.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        if customView.ss_size != .zero {
            customSize = customView.ss_size
        }
        let size = CGSize(width: customSize.width + customEdgeInsets.left + customEdgeInsets.right, height: customSize.height + customEdgeInsets.top + customEdgeInsets.bottom)
        animation.refreshAnimationOfAnimationView(animationView: self, viewSize: size, animated: animated, completion: nil)
    }
    
    
    @objc private func backgroundMaskAction() {
        if canTouchMaskHide {
            if fromViewController != nil {
                dimissView(animated: isTouchMaskHideAnimated ?? false)
            } else {
                hideView(animated: isTouchMaskHideAnimated ?? false)
            }
        }
    }
    
    public func observeHideCompletion(completion: (() -> Void)?) {
        self.hideCompletion = completion
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


