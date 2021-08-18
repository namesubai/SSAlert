//
//  SSAlertCommonView.swift
//  SSAlert
//
//  Created by yangsq on 2021/8/13.
//

import Foundation

public extension SSAlertAction {
    enum Style {
        case alert
        case actionSheet
    }
}


public class SSAlertAction: NSObject {
    public var title: String
    public var titleFont = UIFont.systemFont(ofSize: 16)
    public var titleColor: UIColor? = nil
    public var height: CGFloat = 55
    public var backgroundColor: UIColor? = nil
    public private(set) var style: Style
    private var addAction:(() -> Void)? = nil
    public init(style: Style, title: String, addAction: (() -> Void)? = nil) {
        self.style = style
        self.title = title
        self.addAction = addAction
        if style == .alert {
            height = 50
        }
        super.init()
    }
    func triggerAction() {
        if let addAction = addAction {
            addAction()
        }
    }
}



extension SSAlertCommonView {
    public static var alertMaxWidth = UIScreen.main.bounds.width * 0.7
    public static var actionSheetMaxWidth = UIScreen.main.bounds.width
    public static var buttonSpace: CGFloat = 0.5

    public static var safeAreaBottomMargin: CGFloat {
        if #available(iOS 11.0, *) {
          return  UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        }
        return 0
    }
}

public class SSAlertCommonView: UIView {
    
    public lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    public lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()
    
    public lazy var buttonView: UIView = {
        let view = UIView()
        return view
    }()
    
    public var lineColor: UIColor? = nil {
        didSet {
            lineArray.forEach { lineView in
                lineView.backgroundColor = lineColor
            }
        }
    }
    
    public var lineEdgeInsets: UIEdgeInsets = .zero {
        didSet {
            refreshFrame()
        }
    }
    public private(set) var style: SSAlertAction.Style
    public private(set) var actions: [SSAlertAction]
    public private(set) var title: String?
    public private(set) var message: String?
    
    private var buttonArray: [UIButton] = []
    private var lineArray: [UIView] = []
    private var hasText = false
  
    
    public init(title: String? = nil, message: String? = nil, style: SSAlertAction.Style, actions:[SSAlertAction] = []) {
        self.title = title
        self.message = message
        self.style = style
        self.actions = actions
        super.init(frame: .zero)
        makeUI()
    }
    
    private func makeUI() {
        addSubview(containerView)
        if let title = title, !title.isEmpty {
            titleLabel.text = title
            containerView.addSubview(titleLabel)
            hasText = true
        }
        if let message = message, !message.isEmpty {
            messageLabel.text = message
            containerView.addSubview(messageLabel)
            hasText = true
        }
        
        if actions.count > 0 {
            addSubview(buttonView)
            actions.forEach { action in
                let button = UIButton(type: .system)
                button.setTitle(action.title, for: .normal)
                button.backgroundColor = backgroundColor
                if let backgroundColor = action.backgroundColor {
                    button.backgroundColor = backgroundColor
                }
                button.titleLabel?.font = action.titleFont
                button.setTitleColor(action.titleColor, for: .normal)
                button.addTarget(self, action: #selector(buttonAction(button:)), for: .touchUpInside)
                buttonView.addSubview(button)
                buttonArray.append(button)
                var isAddLineView = false
                if style == .actionSheet {
                    if hasText {
                        isAddLineView = true
                    } else {
                        if actions[actions.count - 1] != action {
                            isAddLineView = true
                        }
                    }
                } else {
                    if actions.count > 2 {
                        if hasText {
                            isAddLineView = true
                        } else {
                            if actions[actions.count - 1] != action {
                                isAddLineView = true
                            }
                        }
                    } else {
                        if actions.count == 1 {
                            if hasText {
                                isAddLineView = true
                            }
                        } else {
                            if hasText {
                                isAddLineView = true
                            } else {
                                if actions[actions.count - 1] != action {
                                    isAddLineView = true
                                }
                            }
                        }
                        
                    }
                }
                if isAddLineView {
                    let linView = UIView()
                    linView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
                    buttonView.addSubview(linView)
                    lineArray.append(linView)
                }
            }
        }
        
        refreshFrame()
    }
    
    private func refreshFrame() {
        let space: CGFloat = 15
        let viewMaxWidth = style == .alert ? SSAlertCommonView.alertMaxWidth : SSAlertCommonView.actionSheetMaxWidth
        var height: CGFloat = 0
        let width = viewMaxWidth
        let containerWidth = viewMaxWidth - space * 2
        var originY: CGFloat = 0
        var cotainerOriginY: CGFloat = 0
        if titleLabel.superview != nil {
            let titleSize = titleLabel.sizeThatFits(CGSize(width: containerWidth, height: CGFloat(MAXFLOAT)))
            titleLabel.ss_origin = CGPoint(x: 0, y: cotainerOriginY)
            titleLabel.ss_size = CGSize(width: containerWidth, height: titleSize.height)
            height += (titleSize.height + space)
            cotainerOriginY += (space + titleSize.height)
            originY = space
        }
        
        if messageLabel.superview != nil {
            let messageSize = messageLabel.sizeThatFits(CGSize(width: containerWidth, height: CGFloat(MAXFLOAT)))
            messageLabel.ss_origin = CGPoint(x: 0, y: cotainerOriginY)
            messageLabel.ss_size = CGSize(width: containerWidth, height: messageSize.height)
            height += (messageSize.height + space)
            cotainerOriginY += (space + messageSize.height)
            originY = space
        }
        
        containerView.ss_origin = CGPoint(x: space, y: originY)
        containerView.ss_size = CGSize(width: containerWidth, height: height)
        originY += height
        
        if !buttonArray.isEmpty {
            let buttonSpace: CGFloat = SSAlertCommonView.buttonSpace
            var buttonTotalHeight: CGFloat = 0
            var buttonTopY: CGFloat = 0
            if style == .actionSheet {
                for index in 0..<buttonArray.count {
                    let action = actions[index]
                    let button = buttonArray[index]
                    if lineArray.count == buttonArray.count {
                        let lineView = lineArray[index]
                        lineView.frame = CGRect(x: lineEdgeInsets.left, y: buttonTopY, width: width - lineEdgeInsets.left - lineEdgeInsets.right, height: buttonSpace)
                        buttonTopY += buttonSpace
                    }
                    
                    if lineArray.count == buttonArray.count - 1 {
                        if index < lineArray.count {
                            let lineView = lineArray[index]
                            lineView.frame = CGRect(x: lineEdgeInsets.left, y: buttonTopY + action.height, width: width - lineEdgeInsets.left - lineEdgeInsets.right, height: buttonSpace)
                            buttonTopY += buttonSpace
                        }
                    }
                    
                    if index == buttonArray.count - 1 {
                        button.ss_size = CGSize(width: width, height: action.height + SSAlertCommonView.safeAreaBottomMargin)
                        button.titleEdgeInsets = UIEdgeInsets(top: -SSAlertCommonView.safeAreaBottomMargin, left: 0, bottom: 0, right: 0)
                    } else {
                        button.ss_size = CGSize(width: width, height: action.height)
                    }
                    button.ss_origin = CGPoint(x: 0, y: buttonTopY)
                    buttonTopY += button.ss_h
                }
                buttonTotalHeight = buttonTopY
            }
            
            if style == .alert {
                if buttonArray.count > 2 {
                    buttonArray.forEach { button in
                        let index = buttonArray.firstIndex(of: button)
                        let action = actions[index!]
                        
                        if lineArray.count == buttonArray.count {
                            let lineView = lineArray[index!]
                            lineView.frame = CGRect(x: lineEdgeInsets.left, y: buttonTopY, width: width - lineEdgeInsets.left - lineEdgeInsets.right, height: buttonSpace)
                            buttonTopY += buttonSpace
                        }
                        if lineArray.count == buttonArray.count - 1 {
                            if index! < lineArray.count  {
                                let lineView = lineArray[index!]
                                lineView.frame = CGRect(x: lineEdgeInsets.left, y: buttonTopY + action.height, width: width - lineEdgeInsets.left - lineEdgeInsets.right, height: buttonSpace)
                                buttonTopY += buttonSpace
                            }
                        }
                        
                        button.ss_origin = CGPoint(x: 0, y: buttonTopY)
                        button.ss_size = CGSize(width: width, height: action.height)
                        buttonTopY += action.height
                    }
                    buttonTotalHeight = buttonTopY
                } else {
                    if buttonArray.count == 1 {
                        let button = buttonArray.first!
                        let action = actions.first!
                        if lineArray.count > 0 {
                            let lineView = lineArray.first!
                            lineView.frame = CGRect(x: lineEdgeInsets.left, y: buttonTopY, width: width - lineEdgeInsets.left - lineEdgeInsets.right, height: buttonSpace)
                            buttonTopY += buttonSpace
                        }
                        button.ss_origin = CGPoint(x: 0, y: buttonTopY)
                        button.ss_size = CGSize(width: width, height: action.height)
                        buttonTotalHeight = buttonTopY
                    } else {
                        let button1 = buttonArray.first!
                        let button2 = buttonArray.last!
                        let action1 = actions.first!
                        let action2 = actions.last!
                        let maxButtonHeight = max(action1.height, action2.height)
                        if hasText {
                            let lineView1 = lineArray.first!
                            lineView1.frame = CGRect(x: 0, y: buttonTopY, width: width, height: buttonSpace)
                            buttonTopY += buttonSpace
                        }
                        
                        button1.ss_origin = CGPoint(x: 0, y: buttonTopY)
                        button1.ss_size = CGSize(width: width / 2 - buttonSpace / 2, height: maxButtonHeight)
                        
                        
                        button2.ss_origin = CGPoint(x: button1.frame.maxX + buttonSpace, y: buttonTopY)
                        button2.ss_size = CGSize(width: width / 2 - buttonSpace / 2, height: maxButtonHeight)
                        
                        let lineView2 = lineArray.last!
                        lineView2.frame = CGRect(x: button1.frame.maxX, y: buttonSpace, width: buttonSpace, height: button1.ss_h)
                        buttonTopY += maxButtonHeight
                    }
                    buttonTotalHeight = buttonTopY
                }
            }
            
            buttonView.ss_origin = CGPoint(x: 0, y: originY)
            buttonView.ss_size = CGSize(width: width, height: buttonTotalHeight)
            height += buttonTotalHeight + (originY > 0 ? space : 0)

        }
        self.ss_size = CGSize(width: width, height: height)
    }
    
    @objc private func buttonAction(button: UIButton) {
        let index = buttonArray.firstIndex(of: button)
        let action = actions[index!]
        action.triggerAction()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
