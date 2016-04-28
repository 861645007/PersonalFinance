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
//        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("PersonalFinance.sqlite")
        
        var magicalRecordSetupFinished = false
        MagicalRecord.setupCoreDataStackWithiCloudContainer("iCloud.com.huanqiang.PersonalFinance", contentNameKey: "PersonalFinance_DataStore", localStoreNamed: "PersonalFinance.sqlite", cloudStorePathComponent: nil) {
            magicalRecordSetupFinished = true
        }
        while !magicalRecordSetupFinished {
            NSRunLoop.currentRunLoop().runMode(NSDefaultRunLoopMode, beforeDate: NSDate.distantFuture())
        }
        
        // 注册一个通知: 当有数据从云端导入的时候，会进入这个 通知的回调函数
        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: NSPersistentStoreCoordinator.MR_defaultStoreCoordinator(), queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
            
            NSManagedObjectContext.MR_defaultContext().performBlock({ 
                NSManagedObjectContext.MR_defaultContext().mergeChangesFromContextDidSaveNotification(notification)
            })
            
            print(notification.userInfo)
        }
        
//        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreCoordinatorStoresDidChangeNotification, object: NSPersistentStoreCoordinator.MR_defaultStoreCoordinator(), queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
//            
//            print("Persistent Store Coordinator Stores Did Change Notification")
//            
//            let type = notification.userInfo![NSPersistentStoreUbiquitousTransitionTypeKey] as? UInt
//            
//            // 当 InitialImportCompleted 的时候导入初始化数据
//            if type == NSPersistentStoreUbiquitousTransitionType.InitialImportCompleted.rawValue {
//                print("InitialImportCompleted")
//                
//                if Category.fetchAllConsumeCategoryWithUsed().count == 0 {
//                    print("Category is nil")
//                    Category.initializeConsumeCategory()
//                }
//            }
//        }
        
        /*
         NSPersistentStoreCoordinatorStoresWillChangeNotification 的作用
         
         2、notification 的 userInfo 里面还包含了 一个 NSPersistentStoreUbiquitousTransitionType 的类型，用来表明本次通知的操作
         */
//        NSNotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreCoordinatorStoresWillChangeNotification, object: NSPersistentStoreCoordinator.MR_defaultStoreCoordinator(), queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
//            
//            let type = notification.userInfo![NSPersistentStoreUbiquitousTransitionTypeKey] as? UInt
//            // 当 InitialImportCompleted 的时候导入初始化数据
//            if type == NSPersistentStoreUbiquitousTransitionType.InitialImportCompleted.rawValue {
//                print("Will Change: InitialImportCompleted")
//                if Category.fetchAllConsumeCategoryWithUsed().count != 0 {
//                    Category.removeAllCategoryForICloud()
//                }
//            }
//        }
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(persistentStoreInitialImportCompleted(_:)), name: NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: nil)
//        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(persistentStoreDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
//
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(persistentStoreWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil)
        
        
        // 配置 NSUserDefaults iCloud Sync
        MKiCloudSync.startWithPrefix("")
        
        NSNotificationCenter.defaultCenter().addObserverForName(kMKiCloudSyncNotification, object: nil, queue: NSOperationQueue.mainQueue()) { (notification: NSNotification) in
//            <#code#>
        }
        
        // 配置 Fabric, Crashlytics
        Fabric.with([Crashlytics.self])
        
        
        // 配置密码锁
        let infoDictionary = NSBundle.mainBundle().infoDictionary
        
        VENTouchLock.sharedInstance().setKeychainService("com.wanghuanqiang.PersonalFinance", keychainAccount: (infoDictionary!["CFBundleDisplayName"] as! String), touchIDReason: "通过Home键验证已有的手机指纹", passcodeAttemptLimit: 10, splashViewControllerClass: SampleSplashViewController().classForCoder)
        
        // 注册本地通知
        PrepareLocalNotification.sharedInstance.registerUserNotificationSettings()
        
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
        
        
        // 通知测试
//        LocalNotification.sharedInstance.createContrastWithLastAndCurrentMonthNotification((50.0).convertToStrWithTwoFractionDigits())
//        LocalNotification.sharedInstance.createPercentWithMonthBudgetNotification(50.0)
        
        
        return true
    }
    
    
    
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        if url.scheme == "AppUrlType" {
            if url.host == "open" {
                NSNotificationCenter.defaultCenter().postNotificationName(AddNewConsumeInWidgetNotification, object: nil)
            }
            return true
        }
        
        return false
    }
    
    // MARK: - 接受通知事件
    func application(application: UIApplication, handleActionWithIdentifier identifier: String?, forLocalNotification notification: UILocalNotification, completionHandler: () -> Void) {
        
        if identifier == PercentInMonthBudgetWorkAction {
            NSNotificationCenter.defaultCenter().postNotificationName(ShowMonthConsumesVCNotification, object: nil)
        }
        
        completionHandler()
    }
    
    // 通知回调函数
    func application(application: UIApplication, didReceiveLocalNotification notification: UILocalNotification) {
        PrepareLocalNotification.sharedInstance.removeBadgeNumber()
        print("点击了按钮 didReceiveLocalNotification")
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
        print("Persistent Store Coordinator Stores Did Change Notification")
        
        let type = notification.userInfo![NSPersistentStoreUbiquitousTransitionTypeKey] as? UInt
        // 当 InitialImportCompleted 的时候导入初始化数据
        if type == NSPersistentStoreUbiquitousTransitionType.InitialImportCompleted.rawValue {
            print("InitialImportCompleted")
            
            if Category.fetchAllConsumeCategoryWithUsed().count == 0 {
                print("Category is nil")
                Category.initializeConsumeCategory()
            }
        }

    }
    
    func persistentStoreWillChange(notification: NSNotification) {
        
        let type = notification.userInfo![NSPersistentStoreUbiquitousTransitionTypeKey] as? UInt
        // 当 InitialImportCompleted 的时候导入初始化数据
        if type == NSPersistentStoreUbiquitousTransitionType.InitialImportCompleted.rawValue {
            print("Will Change: InitialImportCompleted")
            if Category.fetchAllConsumeCategoryWithUsed().count != 0 {
                print("Category has data")
                Category.removeAllCategoryForICloud()
            }
        }
    }
    
    func persistentStoreInitialImportCompleted(notification: NSNotification) {
        
        NSManagedObjectContext.MR_defaultContext().performBlock({
            NSManagedObjectContext.MR_defaultContext().mergeChangesFromContextDidSaveNotification(notification)
        })
        
        print(notification.userInfo)
        
        print(notification.userInfo?.keys)
    }

    
}

