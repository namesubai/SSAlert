//
//  UIViewFrameExtension.swift
//  Pods-SSAlertSwiftDemo
//
//  Created by yangsq on 2021/8/13.
//

import UIKit

public extension UIView {
    var ss_size: CGSize {
        get {
            frame.size
        }
        set {
            var frame = frame
            frame.size = newValue
            self.frame = frame
        }
    }
    
    var ss_origin: CGPoint {
        get {
            frame.origin
        }
        set {
            var frame = frame
            frame.origin = newValue
            self.frame = frame
        }
    }
    
    var ss_center: CGPoint {
        get {
            center
        }
        set {
            center = newValue
        }
    }
    
    var ss_x: CGFloat {
        get {
            frame.origin.x
        }
        set {
            var frame = frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }
    
    var ss_maxX: CGFloat {
        get {
            frame.maxX
        }
    }
    
    var ss_y: CGFloat {
        get {
            frame.origin.y
        }
        set {
            var frame = frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }
    
    var ss_maxY: CGFloat {
        get {
            frame.maxY
        }
        set {
            var frame = frame
            frame.origin.y = newValue - frame.height
            self.frame = frame
        }
    }
    
    var ss_w: CGFloat {
        get {
            frame.width
        }
        set {
            var frame = frame
            frame.size.width = newValue
            self.frame = frame
        }
    }
    
    var ss_h: CGFloat {
        get {
            frame.height
        }
        set {
            var frame = frame
            frame.size.height = newValue
            self.frame = frame
        }
    }
    
    var ss_centerX: CGFloat {
        get {
            center.x
        }
        set {
            var center = center
            center.x = newValue
            self.center = center
        }
    }
    
    var ss_centerY: CGFloat {
        get {
            center.y
        }
        set {
            var center = center
            center.y = newValue
            self.center = center
        }
    }
    
    func ss_moveToCenter() {
        if let superV = superview {
            ss_center = CGPoint(x: superV.frame.width / 2, y: superV.frame.height / 2)
        }
    }
}


