//
//  UIViewControllerExtension.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/16.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import SimpleAlert

extension UIViewController {
    // MARK: - Simple 框架的 Alert
    func showSimpleAlertWithOneBtn(title: String, msg: String, handler: ((SimpleAlert.Action!) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: nil, okHandler: handler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSimpleAlertWithTwoBtn(title: String, msg: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler: ((SimpleAlert.Action!) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: cancelHandler, okHandler: okHandler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showCustomViewAlert(cusView: UIView, cancelTitle: String? = nil, oKTitle: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler:  ((SimpleAlert.Action!) -> Void)? = nil) {
        let alert = SimpleAlert.Controller(view: cusView, style: .Alert)
        
        if cancelTitle != nil {
            if cancelHandler == nil {
                alert.addAction(SimpleAlert.Action(title: cancelTitle!, style: .Destructive))
            }else {
                alert.addAction(SimpleAlert.Action(title: cancelTitle!, style: .Destructive, handler: cancelHandler))
            }            
        }        
        alert.addAction(SimpleAlert.Action(title: "确定", style: .OK, handler: okHandler))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - 系统风格的Alert
    
    func showSystemAlertWithOneBtn(title: String, msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = self.createSystemAlert(title, msg: msg, cancelHandler: nil, okHandler: handler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSystemAlertWithTwoBtn(title: String, msg: String, cancelHandler: ((UIAlertAction) -> Void), okHandler: ((UIAlertAction) -> Void)) {
        let alert = self.createSystemAlert(title, msg: msg, cancelHandler: cancelHandler, okHandler: okHandler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    // MARK: - 私有函数
    private func createSimpleAlert(title: String, msg: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler: ((SimpleAlert.Action!) -> Void)? = nil) ->SimpleAlert.Controller {
        let alert = SimpleAlert.Controller(title: title, message: msg, style: .Alert)
        
        // 可以没有取消按钮，但是一定有确定按钮
        if cancelHandler != nil {
            alert.addAction(SimpleAlert.Action(title: "取消", style: .Destructive, handler: cancelHandler))
        }
        
        alert.addAction(SimpleAlert.Action(title: "确定", style: .OK, handler: okHandler))
        
        return alert
    }
    
    private func createSystemAlert(title: String, msg: String, cancelHandler: ((UIAlertAction) -> Void)? = nil, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        
        if cancelHandler != nil {
            alert.addAction(UIAlertAction(title: "取消", style: .Destructive, handler: cancelHandler))
        }
        
        alert.addAction(UIAlertAction(title: "确定", style: .Default, handler: okHandler))
        
        return alert
    }
    
    
}


