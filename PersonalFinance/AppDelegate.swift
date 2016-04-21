//
//  AppDelegate.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import VENTouchLock
import Fabric
import Crashlytics

import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        
        // 配置 Core Data
        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("PersonalFinance.sqlite")
        
//        var magicalRecordSetupFinished = false
//        MagicalRecord.setupCoreDataStackWithiCloudContainer("iCloud.com.huanqiang.PersonalFinance", contentNameKey: "PersonalFinance_DataStore", localStoreNamed: "PersonalFinance.sqlite", cloudStorePathComponent: nil) {
//            magicalRecordSetupFinished = true
//        }
//        while !magicalRecordSetupFinished {
//            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
//        }        
//        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.persistentStoreDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.persistentStoreWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil)
        
//        // 配置 NSUserDefaults iCloud Sync
//        MKiCloudSync.startWithPrefix("")
        
        // 配置 Fabric, Crashlytics
        Fabric.with([Crashlytics.self])
        
        // 配置密码锁
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        
        VENTouchLock.sharedInstance().setKeychainService("com.wanghuanqiang.PersonalFinance", keychainAccount: (infoDictionary!["CFBundleDisplayName"] as! String), touchIDReason: "通过Home键验证已有的手机指纹", passcodeAttemptLimit: 10, splashViewControllerClass: SampleSplashViewController().classForCoder)
        
        // 初始化基础数据 和 加载引导页面
        let sharedBaseInfo = BaseInfo.sharedBaseInfo
        if !sharedBaseInfo.gainOnBoardSymbol() {
            sharedBaseInfo.saveOnBoardSymbol()
            sharedBaseInfo.initDataWhenFirstUse()
            
            Category.initializeConsumeCategory()
            
            self.gotoOnBoardVC()
        }
        
        // 判断所存的时间是不是今天（新的一天），不是的话，进行操作
        sharedBaseInfo.judgeTimeWhenFirstUseInEveryDay(NSDate())        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    // 跳转至 引导页
    func gotoOnBoardVC() {
        self.window?.rootViewController = OnBoardPageManager.onBoardPageManager.configOnboardVC()
    }
    
    func persistentStoreDidChange(notification: NSNotification) {
        NSLog("Persistent store did change")
    }
    
    func persistentStoreWillChange(notification: NSNotification) {
        print("\(notification.name)")
        
        let keys = notification.userInfo?.keys
        
        print("WillChange:  \(keys)")
        
        let values = notification.userInfo?.values
        
        print("WillChange:  \(values)")
        
        let persistent: NSPersistentStoreCoordinator = notification.object as! NSPersistentStoreCoordinator
        
        print("WillChange:  \(persistent.name)")
        print("WillChange:  \(persistent.persistentStores)")
    }


}

