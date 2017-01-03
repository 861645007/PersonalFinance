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
    
    
    func setPasscode(_ vc: UIViewController, handler: @escaping ((Void) -> Void)) {
        let createPasscodeVC: VENTouchLockCreatePasscodeViewController = VENTouchLockCreatePasscodeViewController()
        
        createPasscodeVC.willFinishWithResult = { finished in
            createPasscodeVC.dismiss(animated: true, completion: {
                handler()
            })
        }
        
        vc.present(createPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
    }
    
    func showPasscode(_ vc: UIViewController) {
        if self.hasPasscodeExist() {
            let showPasscodeVC: VENTouchLockEnterPasscodeViewController = VENTouchLockEnterPasscodeViewController()
            vc.present(showPasscodeVC.embeddedInNavigationController(), animated: true, completion: nil)
        }else {
            vc.showSimpleAlertWithOneBtn("密码不存在", msg: "请先设置一个密码", handler: { (action) in
            })
        }        
    }
    
    func deletePasscode(_ vc: UIViewController, handler: @escaping ((Void) -> Void)) {
        vc.showSystemAlertWithTwoBtn("确定删除密码?", msg: "如果您删除了密码，您的财务隐私将得不到很好地保护！", cancelHandler: { (action) in
                // 不做操作
            }) { (action) in
                VENTouchLock.sharedInstance().deletePasscode()
                handler()
        }
    }
    
    
    func hasPasscodeExist() -> Bool {
        return VENTouchLock.sharedInstance().isPasscodeSet()
    }
    
    // MARK: - 私有函数
    fileprivate func isCanUseTouchId() -> Bool {
        return VENTouchLock.canUseTouchID()
    }
    
}
