//
//  SSAlertAnimationController.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation


class SSAlertAnimationController: UIViewController {
    var isDimiss: Bool = false
    var isHideStatusBar = false {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    var isShowNavWhenViewWillDisappear = true
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override var prefersStatusBarHidden: Bool  {
        return isHideStatusBar
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isDimiss, isShowNavWhenViewWillDisappear {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        isDimiss = true
    }
}


