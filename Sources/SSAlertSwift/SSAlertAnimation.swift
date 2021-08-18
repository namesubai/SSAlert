//
//  SSAlertAnimation.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation

public protocol SSAlertAnimation {
    func animationDuration() -> TimeInterval
    func showAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Void))?)
    func hideAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Bool))?)
    func refreshAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Void))?)
    func panToDimissTransilatePoint(point: CGPoint, panViewFrame: CGRect) -> CGFloat
}

