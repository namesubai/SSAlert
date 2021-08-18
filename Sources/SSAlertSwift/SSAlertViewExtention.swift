//
//  SSAlertViewExtention.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation

extension SSAlertView {
    @discardableResult
    public class func alertView(style: SSAlertAction.Style, title: String? = nil, message: String? = nil, cancelButton: String? = nil, otherButtons: [String] = [], onView: UIView, onTrigger:((Int) -> Void)? = nil) -> SSAlertView {
        var actionArray = [SSAlertAction]()
        var cancelAction: SSAlertAction? = nil
        var alertView: SSAlertView?
        if style == .alert {
            if let cancelButton = cancelButton, !cancelButton.isEmpty {
                cancelAction = SSAlertAction(style: style, title: cancelButton, addAction: {
                    if let onTrigger = onTrigger {
                        onTrigger(0)
                    }
                    alertView?.hide()
                })
                actionArray.append(cancelAction!)
            }
            otherButtons.forEach { title in
                let action = SSAlertAction(style: style, title: title) {
                    if let onTrigger = onTrigger {
                        let index = otherButtons.firstIndex(of: title)
                        onTrigger(cancelAction != nil ? (index! + 1) : index!)
                    }
                }
                actionArray.append(action)
            }
        }
        
        if style == .actionSheet {
            otherButtons.forEach { title in
                let action = SSAlertAction(style: style, title: title) {
                    if let onTrigger = onTrigger {
                        let index = otherButtons.firstIndex(of: title)
                        onTrigger(cancelAction != nil ? (index! + 1) : index!)
                    }
                }
                actionArray.append(action)
            }
            if let cancelButton = cancelButton, !cancelButton.isEmpty {
                cancelAction = SSAlertAction(style: style, title: cancelButton, addAction: {
                    if let onTrigger = onTrigger {
                        onTrigger(0)
                    }
                    alertView?.hide()
                })
                actionArray.append(cancelAction!)
            }
        }
        
        let customView = SSAlertCommonView(title: title, message: message, style: style, actions: actionArray)
        customView.backgroundColor = .white
        alertView = SSAlertView(customView: customView, onView: onView, animation: SSAlertDefaultAnmation(state: style == .actionSheet ? .fromBottom : .fromCenter), maskType: .black)
        alertView!.canTouchMaskHide = false
        if style == .alert {
            alertView!.layer.cornerRadius = 10
            alertView!.layer.masksToBounds = true
        }
        return alertView!
    }
    
    @discardableResult
    public class func modalAlertView(style: SSAlertAction.Style, title: String? = nil, message: String? = nil, cancelButton: String? = nil, otherButtons: [String] = [], fromViewController: UIViewController, navigationViewControllerClass: UINavigationController.Type = UINavigationController.self, onTrigger:((Int) -> Void)? = nil) -> SSAlertView {
        var actionArray = [SSAlertAction]()
        var cancelAction: SSAlertAction? = nil
        var alertView: SSAlertView?
        if style == .alert {
            if let cancelButton = cancelButton, !cancelButton.isEmpty {
                cancelAction = SSAlertAction(style: style, title: cancelButton, addAction: {
                    if let onTrigger = onTrigger {
                        onTrigger(0)
                    }
                    alertView?.hide()
                })
                actionArray.append(cancelAction!)
            }
            otherButtons.forEach { title in
                let action = SSAlertAction(style: style, title: title) {
                    if let onTrigger = onTrigger {
                        let index = otherButtons.firstIndex(of: title)
                        onTrigger(cancelAction != nil ? (index! + 1) : index!)
                    }
                }
                actionArray.append(action)
            }
        }
        
        if style == .actionSheet {
            otherButtons.forEach { title in
                let action = SSAlertAction(style: style, title: title) {
                    if let onTrigger = onTrigger {
                        let index = otherButtons.firstIndex(of: title)
                        onTrigger(cancelAction != nil ? (index! + 1) : index!)
                    }
                }
                actionArray.append(action)
            }
            if let cancelButton = cancelButton, !cancelButton.isEmpty {
                cancelAction = SSAlertAction(style: style, title: cancelButton, addAction: {
                    if let onTrigger = onTrigger {
                        onTrigger(0)
                    }
                    alertView?.hide()
                })
                actionArray.append(cancelAction!)
            }
        }
        let customView = SSAlertCommonView(title: title, message: message, style: style, actions: actionArray)
        customView.backgroundColor = .white
        alertView = SSAlertView(customView: customView,fromViewController: fromViewController, animation: SSAlertDefaultAnmation(state: style == .actionSheet ? .fromBottom : .fromCenter), navigationControllerClass: navigationViewControllerClass, maskType: .black)
        alertView!.canTouchMaskHide = false
        if style == .alert {
            alertView!.layer.cornerRadius = 10
            alertView!.layer.masksToBounds = true
        }
        return alertView!
    }
    
    
}
