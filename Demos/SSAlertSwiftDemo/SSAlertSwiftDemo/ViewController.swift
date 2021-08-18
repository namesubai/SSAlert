//
//  ViewController.swift
//  SSAlertSwiftDemo
//
//  Created by yangsq on 2021/8/13.
//

import UIKit
import SSAlert
import SnapKit

class CustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        ss_w = 200
        ss_h = 200
        
        let label = UILabel()
        label.text = "frame布局挣开";
        addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(50)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class AutoLayoutCustomView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .yellow
        
        
        let label = UILabel()
        label.text = "自动布局挣开";
        label.textAlignment = .center
        addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalTo(0)
            make.width.height.equalTo(200).priority(.high)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


class ViewController: UITableViewController {
    
    let titles = ["From Top",
                  "From Bottom",
                  "From Left",
                  "From Right",
                  "From Center",
                  "自定义alert，类似系统UIAlertView",
                  "自定义ActionSheet，类似系统ActionSheet",
                  "使用自带的SSAlertCommonView自定义"]
    
    let actions = [NSStringFromSelector(#selector(fromTop)),
                   NSStringFromSelector(#selector(fromBottom)),
                   NSStringFromSelector(#selector(fromLeft)),
                   NSStringFromSelector(#selector(fromRight)),
                   NSStringFromSelector(#selector(fromCenter)),
                   NSStringFromSelector(#selector(commonAlert)),
                   NSStringFromSelector(#selector(commonActionSheet)),
                   NSStringFromSelector(#selector(customAlertCommonView))]
    
    
    lazy var sizeLabel: UILabel = {
        let label = UILabel()
        label.text = "200"
        return label
    }()
    
    lazy var slilder: UISlider = {
        let slilder = UISlider()
        slilder.minimumValue = 200
        slilder.maximumValue = Float(self.view.frame.width)
        slilder.addTarget(self, action: #selector(sliderAction(slider:)), for: .valueChanged)
        return slilder
    }()
    
    var isAutoLayoutCustom: Bool = false
    var isModalPresent: Bool = false
    var alertView: SSAlertView?
    var customView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "SSAlertSwiftDemo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .plain, target: self, action: #selector(settingsAction))
    }

    
    @objc func fromTop() {
        showAlertView(state: .fromTop)
    }
    
    @objc func fromBottom() {
        showAlertView(state: .fromBottom)
    }
    
    @objc func fromLeft() {
        showAlertView(state: .fromLeft)
    }
    
    @objc func fromRight() {
        showAlertView(state: .fromRight)
    }
    
    @objc func fromCenter() {
        showAlertView(state: .fromCenter)
    }
    
    @objc func commonAlert() {
        if isModalPresent {
            let alertView = SSAlertView.modalAlertView(style: .alert, title: "自定义Alert弹窗", message: "自带自定义Alert弹窗，类似系统的UIAlertView",  cancelButton: "Cancel", otherButtons: ["OK"], fromViewController: self){ index in
                print(index)
            }
            alertView.show()
        } else {
            let alertView = SSAlertView.alertView(style: .alert, title: "自定义Alert弹窗", message: "自带自定义Alert弹窗，类似系统的UIAlertView",  cancelButton: "Cancel", otherButtons: ["OK"], onView: navigationController!.view){ index in
                print(index)
            }
            alertView.show()
        }
    }
    
    @objc func commonActionSheet() {
        if isModalPresent {
            let alertView = SSAlertView.modalAlertView(style: .actionSheet, title: "自定义ActionSheet弹窗", message: "自带自定义ActionSheet弹窗，类似系统的ActionSheet",  cancelButton: "Cancel", otherButtons: ["action1", "action2", "action3", "action4"], fromViewController: self) { index in
                print(index)
            }
            alertView.show()
        } else {
            let alertView = SSAlertView.alertView(style: .actionSheet, title: "自定义ActionSheet弹窗", message: "自带自定义ActionSheet弹窗，类似系统的ActionSheet",  cancelButton: "Cancel", otherButtons: ["action1", "action2", "action3", "action4"], onView: navigationController!.view) { index in
                print(index)
            }
            
            alertView.show()
        }
    }
    
    @objc func customAlertCommonView() {
        let action1 = SSAlertAction(style: .actionSheet, title: "自定义Action1") {
            print("自定义Action1")
        }
        action1.titleColor = .red
        action1.backgroundColor = .yellow
        action1.titleFont = UIFont.systemFont(ofSize: 18)
        action1.height = 80
        
        let action2 = SSAlertAction(style: .actionSheet, title: "自定义Action2") {
            print("自定义Action2")
        }
        action2.titleColor = .yellow
        action2.backgroundColor = .red
        action2.titleFont = UIFont.systemFont(ofSize: 22)
        action2.height = 55
        
        let commonView = SSAlertCommonView(title: "自定义SSAlertCommonView", message: "文本文本文本文本文本文本", style: .actionSheet, actions: [action1, action2])
        commonView.backgroundColor = .white
        let alertView = SSAlertView(customView: commonView, onView: navigationController!.view, animation: SSAlertDefaultAnmation(state: .fromBottom))
        alertView.show()
    }

    @objc func settingsAction() {
        let customView = UIView(frame: .zero)
        customView.ss_w = view.frame.width
        customView.ss_h = 300
        customView.backgroundColor = .yellow
        let label1 = UILabel()
        label1.text = "模态视图弹窗"
        customView.addSubview(label1)
        label1.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(30)
        }
        
        let switch1 = UISwitch()
        switch1.setOn(isModalPresent, animated: false)
        switch1.addTarget(self, action: #selector(switch1Action(s:)), for: .touchUpInside)
        customView.addSubview(switch1)
        switch1.snp.makeConstraints { make in
            make.left.equalTo(label1.snp.right).offset(20)
            make.centerY.equalTo(label1)
        }
        
        let label2 = UILabel()
        label2.text = "自动布局custom"
        customView.addSubview(label2)
        label2.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(label1.snp.bottom).offset(15)
        }
        
        let switch2 = UISwitch()
        switch2.setOn(isAutoLayoutCustom, animated: false)
        switch2.addTarget(self, action: #selector(switch2Action(s:)), for: .touchUpInside)
        customView.addSubview(switch2)
        switch2.snp.makeConstraints { make in
            make.left.equalTo(label2.snp.right).offset(20)
            make.centerY.equalTo(label2)
        }
        
        let alertView = SSAlertView(customView: customView, onView: navigationController!.view)
        alertView.animation = SSAlertDefaultAnmation(state: .fromBottom)
        alertView.show()
    }
    
    func showAlertView(state: SSAlertDefaultAnmation.State){
        var customView = CustomView() as UIView
        if isAutoLayoutCustom {
            customView = AutoLayoutCustomView() as UIView
        }
        if isModalPresent {
            let pushButton = UIButton(type: .system)
            pushButton.setTitle("push", for: .normal)
            pushButton.addTarget(self, action: #selector(pushAction), for: .touchUpInside)
            customView.addSubview(pushButton)
            pushButton.snp.makeConstraints { make in
                make.center.equalToSuperview()
            }
            let alertView = SSAlertView(customView: customView, fromViewController: self)
            self.alertView = alertView
        } else {
            let alertView = SSAlertView(customView: customView, onView: navigationController!.view)
            self.alertView = alertView
        }
        
        customView.addSubview(sizeLabel)
        sizeLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        customView.addSubview(slilder)
        slilder.snp.makeConstraints { make in
            make.top.equalTo(sizeLabel.snp.bottom).offset(15)
            make.bottom.equalTo(-30)
            make.left.equalTo(20)
            make.right.equalTo(-20).priority(.low)
            make.height.equalTo(20).priority(.low)
        }
        self.customView = customView
        let animation = SSAlertDefaultAnmation(state: state)
        alertView?.animation = animation
        alertView?.show()
       
        
    }
    
    @objc func pushAction() {
        alertView?.navigationController?.pushViewController(ViewController(), animated: true)
    }
    
    @objc func sliderAction(slider: UISlider) {
        sizeLabel.text = "\(slilder.value)"
        customView?.ss_w = CGFloat(slilder.value)
        customView?.ss_h = CGFloat(slilder.value)
        self.alertView?.refreshFrame(animated: false)
    }
    
    @objc func switch1Action(s: UISwitch) {
        isModalPresent = s.isOn
    }
    
    @objc func switch2Action(s: UISwitch) {
        isAutoLayoutCustom = s.isOn
    }
}

extension ViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UITableViewCell")!
        cell.textLabel?.text = titles[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.perform(NSSelectorFromString(actions[indexPath.row]))
    }
}

