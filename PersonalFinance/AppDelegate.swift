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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        UIApplication.sharedApplication().statusBarStyle = .LightContent
        UIApplication.shared.setStatusBarStyle(.lightContent, animated: true)
        
        // 配置 Core Data
//        MagicalRecord.setupCoreDataStackWithAutoMigratingSqliteStoreNamed("PersonalFinance.sqlite")
        
        var magicalRecordSetupFinished = false
        MagicalRecord.setupCoreDataStackWithiCloudContainer("iCloud.com.huanqiang.PersonalFinance", contentNameKey: "PersonalFinance_DataStore", localStoreNamed: "PersonalFinance.sqlite", cloudStorePathComponent: nil) {
            magicalRecordSetupFinished = true
        }
        while !magicalRecordSetupFinished {
            RunLoop.current.run(mode: RunLoopMode.defaultRunLoopMode, before: Date.distantFuture)
        }
        
        // 注册一个通知: 当有数据从云端导入的时候，会进入这个 通知的回调函数
        NotificationCenter.defaultCenter().addObserverForName(NSPersistentStoreDidImportUbiquitousContentChangesNotification, object: NSPersistentStoreCoordinator.MR_defaultStoreCoordinator(), queue: OperationQueue.mainQueue()) { (notification: Notification) in
            
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
        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(persistentStoreDidChange(_:)), name: NSPersistentStoreCoordinatorStoresDidChangeNotification, object: nil)
//
        NotificationCenter.defaultCenter().addObserver(self, selector: #selector(persistentStoreWillChange(_:)), name: NSPersistentStoreCoordinatorStoresWillChangeNotification, object: nil)
        
        
        // 配置 NSUserDefaults iCloud Sync
        Zephyr.debugEnabled = true
        Zephyr.addKeysToBeMonitored(["today", "MonthBudget"])
        Zephyr.sync()
        
        // 配置 Fabric, Crashlytics
        Fabric.with([Crashlytics.self])
        
        // 配置密码锁
        let infoDictionary = Bundle.main.infoDictionary
        
        VENTouchLock.sharedInstance().setKeychainService("com.wanghuanqiang.PersonalFinance", keychainAccount: (infoDictionary!["CFBundleDisplayName"] as! String), touchIDReason: "通过Home键验证已有的手机指纹", passcodeAttemptLimit: 10, splashViewControllerClass: SampleSplashViewController().classForCoder)
        
        // 注册本地通知
        PrepareLocalNotification.sharedInstance.registerUserNotificationSettings()
        PrepareLocalNotification.sharedInstance.removeBadgeNumber()
        
        // 初始化基础数据 和 加载引导页面
        let sharedBaseInfo = BaseInfo.sharedBaseInfo
        if !sharedBaseInfo.gainOnBoardSymbol() {
            sharedBaseInfo.saveOnBoardSymbol()
            sharedBaseInfo.initDataWhenFirstUse()
            
            Category.initializeConsumeCategory()
            
            self.gotoOnBoardVC()
        }
        
        // 判断所存的时间是不是今天（新的一天），不是的话，进行操作
        self.judgeTimeWhenFirstUseInEveryDay(Date())
        
        return true
    }
    
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.scheme == "AppUrlType" {
            if url.host == "open" {
                NotificationCenter.default.post(name: Notification.Name(rawValue: AddNewConsumeInWidgetNotification), object: nil)
            }
            return true
        }
        
        return false
    }
    
    // MARK: - 接受通知事件
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, for notification: UILocalNotification, completionHandler: @escaping () -> Void) {
        
        if identifier == PercentInMonthBudgetWorkAction {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ShowMonthConsumesVCNotification), object: nil)
        }else if (identifier == ModifyMonthBudgetWorkAction) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: ShowModifyMonthBudgetVCNotification), object: nil)
        }
        
        
        completionHandler()
    }
    
    // 通知回调函数
    func application(_ application: UIApplication, didReceive notification: UILocalNotification) {
        PrepareLocalNotification.sharedInstance.removeBadgeNumber()
        print("点击了按钮 didReceiveLocalNotification")
    }
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
        
        PrepareLocalNotification.sharedInstance.removeBadgeNumber()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    

    // 跳转至 引导页
    func gotoOnBoardVC() {
        self.window?.rootViewController = OnBoardPageManager.onBoardPageManager.configOnboardVC()
    }
    
    func persistentStoreDidChange(_ notification: Notification) {
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
    
    func persistentStoreWillChange(_ notification: Notification) {
        
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
    
    func persistentStoreInitialImportCompleted(_ notification: Notification) {
        
        NSManagedObjectContext.MR_defaultContext().performBlock({
            NSManagedObjectContext.MR_defaultContext().mergeChangesFromContextDidSaveNotification(notification)
        })
        
        print(notification.userInfo)
        
        print(notification.userInfo?.keys)
    }
    
    
    
    // MARK: - 判断时间信息 ，当第一次进入的时候
    /**
     当每次进入的时候，判断一下时间信息，以设置各项信息
     
     - parameter date: 被判断的时间
     */
    func judgeTimeWhenFirstUseInEveryDay(_ date: Date) {
        if !BaseInfo.sharedBaseInfo.isCurrentMonth(date) || !BaseInfo.sharedBaseInfo.isToday(date) {
            if !BaseInfo.sharedBaseInfo.isCurrentMonth(date) {
                // 注册每月预算通知
                LocalNotification.sharedInstance.createShowMonthBudgetNotification()
            }
            
            BaseInfo.sharedBaseInfo.saveTime(date)
            ShareWithGroupOperation.sharedGroupOperation.saveNewDayExpense(BaseInfo().dayExpense())
        }
    }

    
}

