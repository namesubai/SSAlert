//
//  SSAlertAnimation.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation
public typealias PanProgress = CGFloat
public typealias PanCancelProgress = CGFloat
public typealias DimissIsCancel = Bool
public protocol SSAlertAnimation {
    /// 动画时间
    func animationDuration() -> TimeInterval
    /// 展示动画
    func showAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Void))?)
    /// 隐藏动画 
    func hideAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Bool))?)
    /// 刷新大小动画
    func refreshAnimationOfAnimationView(animationView: SSAlertView, viewSize: CGSize, animated: Bool, completion:(((Bool) -> Void))?)
    /// 拖拽隐藏动画，当是模态视图弹窗才有
    func panToDimissTransilatePoint(point: CGPoint, panViewFrame: CGRect) -> (PanProgress, PanCancelProgress)
}

