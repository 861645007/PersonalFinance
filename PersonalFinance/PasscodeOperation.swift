//
//  PasscodeOperation.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
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
    
    
    func setPasscode(vc: UIViewController, handler: (Void -> Void)) {
        let createPasscodeVC: VENTouchLockCreatePasscodeViewController = VENTouchLockCreatePasscodeViewController()
        
        createPasscodeVC.willFinishWithResult = { finished in
            createPasscodeVC.dismissViewControllerAnimated(true, completion: {
                handler()
            })
        }
        
        vc.presentViewController(createPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
    }
    
    func showPasscode(vc: UIViewController) {
        if self.hasPasscodeExist() {
            let showPasscodeVC: VENTouchLockEnterPasscodeViewController = VENTouchLockEnterPasscodeViewController()
            vc.presentViewController(showPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
        }else {
            vc.showSimpleAlertWithOneBtn("密码不存在", msg: "请先设置一个密码", handler: { (action) in
            })
        }        
    }
    
    func deletePasscode(vc: UIViewController, handler: (Void -> Void)) {
        VENTouchLock.sharedInstance().deletePasscode()
        handler()
    }
    
    
    func hasPasscodeExist() -> Bool {
        return VENTouchLock.sharedInstance().isPasscodeSet()
    }
    
    // MARK: - 私有函数
    private func isCanUseTouchId() -> Bool {
        return VENTouchLock.canUseTouchID()
    }
    
}
