//
//  OnBoardPageManager.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Onboard

private let onboardSharedInstance = OnBoardPageManager()

class OnBoardPageManager {
    
    class var onBoardPageManager: OnBoardPageManager {
        return onboardSharedInstance
    }

    func configOnboardVC() ->OnboardingViewController {
        let onboardVC = OnboardingViewController(backgroundImage: UIImage(named: "onBoardBg"), contents: self.generateOnBoardPage())!
        
        onboardVC.shouldMaskBackground = false
        
        // 隐藏最后一页的 skip 按钮 和 PageControl 控件
        onboardVC.shouldFadeTransitions = true
        onboardVC.fadePageControlOnLastPage = true
        onboardVC.fadeSkipButtonOnLastPage = true
        
        onboardVC.allowSkipping = true
        onboardVC.skipHandler = {
            self.handleOnboardingCompletion()
        }
        
        return onboardVC
    }

    
    fileprivate func generateOnBoardPage() ->[OnboardingContentViewController] {
        
        let firstPage: OnboardingContentViewController = OnboardingContentViewController(title: "第一页", body: "欢迎使用", image: nil, buttonText: nil){ () -> Void in
            self.handleOnboardingCompletion()
        }
        let secondPage: OnboardingContentViewController = OnboardingContentViewController(title: "第二页", body: "这是第二页", image: nil, buttonText: nil, action: nil)
        let thirdPage: OnboardingContentViewController = OnboardingContentViewController(title: "第三页", body: "这是第三页", image: nil, buttonText: "进入应用"){ () -> Void in
            self.handleOnboardingCompletion()
        }

        return [firstPage, secondPage, thirdPage]
    }
    
    //
    fileprivate func handleOnboardingCompletion() {
        let app = UIApplication.shared
        let appDelegate: AppDelegate = app.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "RootViewController")
    }
}
