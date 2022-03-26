//
//  SSAlertPresentAnimation.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation

typealias PanDimissAnimation = (CGPoint, CGRect) -> (PanProgress, PanCancelProgress)
typealias DimissAnimation = (DimissIsCancel) -> Void

class SSCustomInteractiveAnimation: UIPercentDrivenInteractiveTransition {
    private(set) var panGestureRecognizer: UIPanGestureRecognizer
    private var panDimissAnimation: PanDimissAnimation?
    private var dimissAnimation: DimissAnimation?

    init(panGestureRecognizer: UIPanGestureRecognizer,  panDimissAnimation: PanDimissAnimation?, dimissAnimation: DimissAnimation?) {
        self.panGestureRecognizer = panGestureRecognizer
        self.panDimissAnimation = panDimissAnimation
        self.dimissAnimation = dimissAnimation
        super.init()
        self.completionSpeed = 0.2
        panGestureRecognizer.addTarget(self, action: #selector(panAction(pan:)))
    }
    
    @objc private func panAction(pan: UIPanGestureRecognizer) {
        guard let view = pan.view else {
            return
        }
        let poin = pan.translation(in: view)
        var progress: CGFloat = 0
        var cancelProgress: CGFloat = 0.4
        if let panDimissAnimation = self.panDimissAnimation {
            let (tProgress, tCancelProgress) = panDimissAnimation(poin, pan.view!.frame)
            progress = tProgress
            cancelProgress = tCancelProgress
        }
        switch pan.state {
        case .began:
            pan.setTranslation(CGPoint(x: 0, y: 0), in: view)
        case .changed:
            update(progress)
        case .cancelled:
            cancel()
        case .ended:
            if progress > cancelProgress {
                finish()
                dimissAnimation?(false)
            } else {
                cancel()
                dimissAnimation?(true)
            }
        default:
            break
        }
    }
    
    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        super.startInteractiveTransition(transitionContext)
    }
    
    deinit {
        panGestureRecognizer.removeTarget(self, action: #selector(panAction(pan:)))
    }
}

class SSAlertPresentAnimation: NSObject {
    typealias AnimationCompletion = () -> Void
    var duration: TimeInterval = 0.35
    private var showAnimation: AnimationCompletion? = nil
    private var hideAnimation: AnimationCompletion? = nil
    private var endCompletion: AnimationCompletion? = nil
    private var panDimissAnimation: PanDimissAnimation? = nil
    private var dimissAnimation: DimissAnimation? = nil

    private var transitionContext: UIViewControllerContextTransitioning?
    private weak var nav: UINavigationController?
    private weak var animationView: UIView?
    private var panGestureRecognizer: UIPanGestureRecognizer?

    init(navigationViewController: UINavigationController, animationView: UIView, canPanDimiss: Bool = true) {
        self.nav = navigationViewController
        self.animationView = animationView
        super.init()
        if canPanDimiss {
            let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction(pan:)))
            pan.maximumNumberOfTouches = 1
            animationView.addGestureRecognizer(pan)
        }
    }
    
    @objc func panAction(pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            panGestureRecognizer = pan
            nav?.viewControllers[0].dismiss(animated: true, completion: {
                [weak self] in guard let self = self else { return }
                self.panGestureRecognizer = nil
            });
        }
    }
    
    func animationCompletion(showAnimation: AnimationCompletion? = nil,
                             hideAnimation: AnimationCompletion? = nil,
                             endCompletion: AnimationCompletion? = nil,
                             panDimissAnimation: PanDimissAnimation? = nil,
                             dimissAnimation: DimissAnimation? = nil) {
        if showAnimation != nil {
            self.showAnimation = showAnimation
        }
        if hideAnimation != nil {
            self.hideAnimation = hideAnimation
        }

        if endCompletion != nil {
            self.endCompletion = endCompletion
        }
        if panDimissAnimation != nil {
            self.panDimissAnimation = panDimissAnimation
        }
        if panDimissAnimation != nil {
            self.panDimissAnimation = panDimissAnimation
        }
        
        if dimissAnimation != nil {
            self.dimissAnimation = dimissAnimation
        }
    }
    
    @discardableResult
    func setCompleteTransitionIsHide(isHide: Bool) -> Bool {
        if let transitionContext = transitionContext {
            let isCancelled = transitionContext.transitionWasCancelled
            if !isCancelled {
                if isHide {
                    transitionContext.containerView.subviews.forEach { subView in
                        subView.removeFromSuperview()
                    }
                }
                
            }
            transitionContext.completeTransition(!isCancelled)
            return isCancelled
        }
       
        return false
    }
}

extension SSAlertPresentAnimation: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.panGestureRecognizer != nil {
            return SSCustomInteractiveAnimation(panGestureRecognizer: self.panGestureRecognizer!, panDimissAnimation: self.panDimissAnimation, dimissAnimation: dimissAnimation)
        }
        return nil
    }
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if self.panGestureRecognizer != nil {
            
            return SSCustomInteractiveAnimation(panGestureRecognizer: self.panGestureRecognizer!, panDimissAnimation: self.panDimissAnimation, dimissAnimation: dimissAnimation)
        }
        return nil
    }
}

extension SSAlertPresentAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return self.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let containerView = transitionContext.containerView

        if let fromVC = fromVC, let toVC = toVC {
            var fromView = fromVC.view
            var toView = toVC.view
            if transitionContext.responds(to: #selector(UIViewControllerContextTransitioning.view(forKey:))) {
                fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)
                toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
            }
            let isPresenting = toVC.presentingViewController == fromVC
            if isPresenting {
                if let toView = toView {
                    containerView.addSubview(toView)

                }
                if let showAnimation = self.showAnimation {
                    showAnimation()
                }
            } else {
                if let toView = toView, let fromView = fromView {
                    containerView.insertSubview(toView, belowSubview: fromView)

                }
                if let hideAnimation = self.hideAnimation {
                    hideAnimation()
                }
            }
         
            
        }
    
    }
    
    
    
    func animationEnded(_ transitionCompleted: Bool) {
        if let endCompletion = self.endCompletion, transitionCompleted, let transitionContext = transitionContext, transitionContext.isInteractive {
            endCompletion()
        }
    }
}
