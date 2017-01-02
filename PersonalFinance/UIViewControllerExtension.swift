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
    // MARK: - UINavigationController 扩展
    func setNavigationBackItemBlank() {
        // 修改导航栏返回键的文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "    ", style: .plain, target: nil, action: nil)
        // 修改返回键的颜色 为白色
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }
    
    
    func setNavigationBarHidden() {
        // 设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default);
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    
    
    // MARK: - Simple 框架的 Alert
    func showSimpleAlertWithOneBtn(_ title: String, msg: String, handler: ((SimpleAlert.Action?) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: nil, okHandler: handler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showSimpleAlertWithTwoBtn(_ title: String, msg: String, cancelHandler: ((SimpleAlert.Action?) -> Void)? = nil, okHandler: ((SimpleAlert.Action?) -> Void)? = nil) {
        let alert = self.createSimpleAlert(title, msg: msg, cancelHandler: cancelHandler, okHandler: okHandler)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func showCustomViewAlert(_ cusView: UIView, cancelTitle: String? = nil, oKTitle: String, cancelHandler: ((SimpleAlert.Action?) -> Void)? = nil, okHandler:  ((SimpleAlert.Action?) -> Void)? = nil) {
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
    
    func showSystemAlertWithOneBtn(_ title: String, msg: String, handler: ((UIAlertAction) -> Void)? = nil) {
        let alert = self.createSystemAlert(title, msg: msg, cancelHandler: nil, okHandler: handler)
        self.present(alert, animated: true, completion: nil)
    }
    
    func showSystemAlertWithTwoBtn(_ title: String, msg: String, cancelHandler: @escaping ((UIAlertAction) -> Void), okHandler: @escaping ((UIAlertAction) -> Void)) {
        let alert = self.createSystemAlert(title, msg: msg, cancelHandler: cancelHandler, okHandler: okHandler)
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - 私有函数
    fileprivate func createSimpleAlert(_ title: String, msg: String, cancelHandler: ((SimpleAlert.Action!) -> Void)? = nil, okHandler: ((SimpleAlert.Action!) -> Void)? = nil) ->SimpleAlert.Controller {
        let alert = SimpleAlert.Controller(title: title, message: msg, style: .Alert)
        
        // 可以没有取消按钮，但是一定有确定按钮
        if cancelHandler != nil {
            alert.addAction(SimpleAlert.Action(title: "取消", style: .Destructive, handler: cancelHandler))
        }
        
        alert.addAction(SimpleAlert.Action(title: "确定", style: .OK, handler: okHandler))
        
        return alert
    }
    
    fileprivate func createSystemAlert(_ title: String, msg: String, cancelHandler: ((UIAlertAction) -> Void)? = nil, okHandler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        if cancelHandler != nil {
            alert.addAction(UIAlertAction(title: "取消", style: .destructive, handler: cancelHandler))
        }
        
        alert.addAction(UIAlertAction(title: "确定", style: .default, handler: okHandler))
        
        return alert
    }
    
    
}


