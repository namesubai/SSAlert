//
//  SSAlertAnimationController.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation


class SSAlertAnimationController: UIViewController {
    private var isDimiss: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if !isDimiss {
            navigationController?.setNavigationBarHidden(false, animated: animated)
        }
    }
    
    override func dismiss(animated flag: Bool, completion: (() -> Void)? = nil) {
        super.dismiss(animated: flag, completion: completion)
        isDimiss = true
    }
}
