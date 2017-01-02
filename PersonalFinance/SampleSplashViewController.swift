//
//  SampleSplashViewController.swift
//  KeychainAccessTest
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import SimpleAlert
import VENTouchLock

class SampleSplashViewController: VENTouchLockSplashViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "SampleSplashViewController", bundle: nil)
        
        
        self.didFinishWithSuccess = {[weak self] (success: Bool, unlockType: VENTouchLockSplashViewControllerUnlockType) in
            if success {
                var logString = "Sample App Unlocked ";
                switch unlockType {
                case .TouchID:
                    logString.appendContentsOf(" with Touch ID.")
                case .Passcode:
                    logString.appendContentsOf(" with Passcode.")
                default:
                    break;
                }
                
                print(logString)
            }else {                
                let alert = SimpleAlert.Controller(title: "超出限制", message: "你已经超出了尝试次数", style: .Alert)
                
                alert.addAction(SimpleAlert.Action(title: "确定", style: .OK){ action in
                    
                    })
                self!.presentViewController(alert, animated: true, completion: nil)
            }
        }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func userTappedShowTouchIDuserTappedShowTouchID(_ sender: AnyObject) {
        self.showTouchID()
    }

    
    @IBAction func UserTapPassword(_ sender: AnyObject) {
        self.showPasscodeAnimated(true)
    }
    
}
