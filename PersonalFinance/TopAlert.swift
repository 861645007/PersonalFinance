//
//  TopAlert.swift
//  CNBlogsClient
//
//  Created by 王焕强 on 15/6/4.
//  Copyright (c) 2015年 &#29579;&#28949;&#24378;. All rights reserved.
//

import UIKit

class TopAlert: NSObject {
    
    //******* 已经完成的基础操作 *******
    /**
    一个表示成功的 topAlertView
    
    - parameter alertInfo:  alertView 显示的信息
    - parameter parentView: alertVeiw 所显示的视图
    */
    func createSuccessTopAlert(_ alertInfo: String, parentView: UIView, dismissBlock: @escaping ()->()? = nil) {
        let topAlertView = self.createBaseTopAlert(MozAlertTypeSuccess, alertInfo: alertInfo, parentView: parentView)
        topAlertView.dismissBlock = dismissBlock
    }
    
    /**
    一个表示失败的 topAlertView
    
    - parameter alertInfo:  alertView 显示的信息
    - parameter parentView: alertVeiw 所显示的视图
    */
    func createFailureTopAlert(_ alertInfo: String, parentView: UIView) {
        self.createBaseTopAlert(MozAlertTypeError, alertInfo: alertInfo, parentView: parentView)
    }
    
    
    //*******  基本操作  *******
    /**
    基本的弹出 topAlertView （只是基本的展示信息）
    
    - parameter alertType:  alertView 类型
    - parameter alertInfo:  alertView 显示的信息
    - parameter parentView: alertVeiw 所显示的视图
    */
    func createBaseTopAlert(_ alertType: MozAlertType, alertInfo: String, parentView: UIView) -> MozTopAlertView {
        return MozTopAlertView.show(with: alertType, text: alertInfo, parentView: parentView)
    }
    
    /**
    一个 topAlertView， 能在结束的时候操作block
    
    - parameter alertType:    alertView 类型
    - parameter alertInfo:    alertView 显示的信息
    - parameter parentView:   alertVeiw 所显示的视图
    - parameter dismissBlock: 结束时要执行的 Block 操作
    */
    func createBaseTopAlertWithBlock(_ alertType: MozAlertType, alertInfo: String, parentView: UIView, dismissBlock: @escaping ()->()) {
        let topAlertView =  MozTopAlertView.show(with: alertType, text: alertInfo, parentView: parentView)
        topAlertView?.dismissBlock = dismissBlock
    }
    
    /**
    带按钮的 topAlertView
    
    - parameter alertType:  alertView 类型
    - parameter alertInfo:  alertView 显示的信息
    - parameter btnText:    按钮的信息
    - parameter parentView: alertVeiw 所显示的视图
    - parameter doBlock:    点击按钮所要执行的操作
    */
    func createBaseTopAlertWithBtn(_ alertType: MozAlertType, alertInfo: String, btnText: String, parentView: UIView, doBlock: @escaping ()->()) {
        MozTopAlertView.show(with: alertType, text: alertInfo, doText: btnText, do: { () -> Void in
            doBlock()
        }, parentView: parentView)
    }
}
