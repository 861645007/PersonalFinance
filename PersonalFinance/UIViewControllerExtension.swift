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
    func showSimpleAlertWithOneBtn(title: String, msg: String, handler: ((SimpleAlert.Action!) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: nil, okHandler: handler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSimpleAlertWithTwoBtn(title: String, msg: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler: ((SimpleAlert.Action!) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: cancelHandler, okHandler: okHandler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    
    
    private func createSimpleAlert(title: String, msg: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler: ((SimpleAlert.Action!) -> Void)? = nil) ->SimpleAlert.Controller {
        let alert = SimpleAlert.Controller(title: title, message: msg, style: .Alert)
        
        // 可以没有取消按钮，但是一定有确定按钮
        if cancelHandler != nil {
            alert.addAction(SimpleAlert.Action(title: "取消", style: .Destructive, handler: cancelHandler))
        }
        
        alert.addAction(SimpleAlert.Action(title: "确定", style: .OK, handler: okHandler))
        
        return alert
    }
}


