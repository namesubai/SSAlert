# SSAlert
实际开发中经常遇到各种自定义的弹窗的需求，其中编写弹窗动画和遮罩就很繁琐，而且一个一个去写重复的代码，代码会变得更加冗余。

SSAlert封装了动画部分，而且支持自定义动画。可以快速构建弹窗，简单易用，基本可以满足大部分弹窗需求。自带常用自定义弹窗，类型系统的UIAlertView,UIActionSheet。
# 特性
- 支持OC、Swift版本
- 支持自定义弹窗内容，可以根据弹窗内容frame布局和自动布局确定弹窗大小
- 支持动画展示后刷新弹窗的大小
- 支带透明、黑色、无三种背景遮罩
- 自带从上、下、左、右、中弹出动画，动画支持弹簧效果，而且可以设置位置偏移量
- 支持自定义动画,动画隐藏回调
- 支持模态视图弹窗，支持拖拽隐藏
- 自带类似系统的弹窗UIAlertView,UIActionSheet
# 使用
## 1.导入代码
### Objective-C项目
1. pod  'SSAlert/OC'
2. #import <SSAlert/SSAlert.h>
### Swift项目
1. pod  'SSAlert/Swift'
1. import SSAlert
## 2.SSAlertView用法
### SSAlertView的初始化
SSAlertView的初始化有两种，一种是普通弹窗，一种是模态视图弹窗，两种的区别在于，前者是弹出一个View，后者是弹窗一个UIViewController。当需要点击弹窗上按钮不关闭弹窗跳转界面时候，可以使用模态视图弹窗。

普通弹窗初始化
```
 let customView = UIView()
 customView.frame = CGRect(x:0,y:0,width:200,height:200)
 let alertView = SSAlertView(customView: customView, onView: navigationController!.view)
```
模态视图弹窗初始化
```
let customView = UIView()
customView.frame = CGRect(x:0,y:0,width:200,height:200)
let alertView = SSAlertView(customView: customView, fromViewController: self)
```
### SSAlertView的动画设置

遵循 **SSAlertAnimation** 协议的自定义动画都可以设置 **SSAlertView** 的 **animation** 属性

 **SSAlertView**自带的动画效果：**SSAlertDefaultAnmation**，提供上、下、左、右、中弹出动画等
 ```
 let animation = SSAlertDefaultAnmation(state: .fromCenter)
 alertView.animation = animation
 ```
### SSAlertView的展示和隐藏
 ```
 alertView.show()
 alertView.hide()
 ```
### SSAlertView的大小刷新
```
 customView.frame = CGRect(x:0,y:0,width:400,height:400)
 alertView.refreshFrame()
```

## 3.自带类型系统UIAlert,UIActionSheet的用法
``` 
///
let alertView = SSAlertView.alertView(style: .alert, title: "自定义Alert弹窗", message: "自带自定义Alert弹窗，类似系统的UIAlertView",  cancelButton: "Cancel", otherButtons: ["OK"], onView: navigationController!.view){ index in
                print(index)
 }
alertView.show()
            
 ///
let alertView = SSAlertView.modalAlertView(style: .actionSheet, title: "自定义ActionSheet弹窗", message: "自带自定义ActionSheet弹窗，类似系统的ActionSheet",  cancelButton: "Cancel", otherButtons: ["action1", "action2", "action3", "action4"], fromViewController: self) { index in
                print(index)
}
alertView.show()
```

## 4.自定义SSAlertCommonView
```
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
```

更多用法请下载代码，观看[demo](https://github.com/namesubai/SSAlert),

觉得好用，手动点个Star❤️❤️❤️❤️
 
