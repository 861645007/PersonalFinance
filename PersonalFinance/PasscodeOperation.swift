//
//  PasscodeOperation.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import SimpleAlert
import VENTouchLock

private let sharedInstance = PasscodeOperation()

class PasscodeOperation: NSObject {

    // 设置 单例
    class var sharedPasscodeOperation: PasscodeOperation {
        return sharedInstance
    }
    
    override init() {
        // 设置默认为 Touch ID 解锁
        VENTouchLock.setShouldUseTouchID(true)
    }
    
    
    func setPasscode(vc: UIViewController) {
        if self.isPasscodeExist() {
            vc.presentViewController(self.createAlertView("密码已存在", msg: "如果您想重新设置一个密码，请先删除原密码"), animated: true, completion: nil)
        }else {
            let createPasscodeVC: VENTouchLockCreatePasscodeViewController = VENTouchLockCreatePasscodeViewController()
            vc.presentViewController(createPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
        }
    }
    
    func showPasscode(vc: UIViewController) {
        if self.isPasscodeExist() {
            let showPasscodeVC: VENTouchLockEnterPasscodeViewController = VENTouchLockEnterPasscodeViewController()
            vc.presentViewController(showPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
        }else {
            vc.presentViewController(self.createAlertView("密码不存在", msg: "请先设置一个密码"), animated: true, completion: nil)
        }        
    }
    
    func deletePasscode(vc: UIViewController) {
        if self.isPasscodeExist() {
            VENTouchLock.sharedInstance().deletePasscode()
        }else {
            vc.presentViewController(self.createAlertView("密码不存在", msg: "请先设置一个密码"), animated: true, completion: nil)
        }
        
    }
    
    // MARK: - 私有函数
    private func isPasscodeExist() -> Bool {
        return VENTouchLock.sharedInstance().isPasscodeSet()
    }
    
    private func isCanUseTouchId() -> Bool {
        return VENTouchLock.canUseTouchID()
    }
    
    private func createAlertView(title: String, msg: String) -> SimpleAlert.Controller {
        let alert = SimpleAlert.Controller(title: title, message: msg, style: .Alert)
        
        alert.addAction(SimpleAlert.Action(title: "确定", style: .OK){ action in
            
        })
        return alert
    }
    
}
