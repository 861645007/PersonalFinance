//
//  PrepareLocalNotification.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/23.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

struct NotificationAction {
    var name = ""
    var id = ""
    
    init(name: String, id: String) {
        self.name = name
        self.id = id
    }
}

class PrepareLocalNotification: NSObject {
    static let sharedInstance = PrepareLocalNotification()
    
    private override init() {
        super.init()
    }
    
    // MARK: - 创建本地通知
    func createLocalNotification(bodyInfo: String, fireDate: NSDate, categoryID: String? = nil) -> UILocalNotification {
        let localNotification: UILocalNotification = UILocalNotification()
        
        localNotification.fireDate                   = fireDate
        localNotification.alertBody                  = bodyInfo
        localNotification.applicationIconBadgeNumber = 1
        localNotification.soundName                  = UILocalNotificationDefaultSoundName
        localNotification.category                   = categoryID
        
        return localNotification
    }
    
    func createLocalNotificationWithTwoAction(bodyInfo: String, fireDate: NSDate, categoryID: String, workAction: NotificationAction, relaxAction: NotificationAction) -> UILocalNotification {
        
        let workingAction = self.createNotificationAction(workAction.name, id: workAction.id, activationMode: true)
        
        let relaxingAction = self.createNotificationAction(relaxAction.name, id: relaxAction.id, activationMode: false)
        
        registerNotificationCategory(categoryID, actions: [workingAction, relaxingAction])
        
        return self.createLocalNotification(bodyInfo, fireDate: fireDate, categoryID: categoryID)
    }
    
    //MARK: - Notification Category 设置
    
    /**
     创建一个 Category
     
     - parameter identifier: Category 的 ID（这个非常重要）
     - parameter actions:    按钮集合
     */
    func registerNotificationCategory(identifier: String, actions: [UIUserNotificationAction]) {
        
        let notificationCompleteCategory: UIMutableUserNotificationCategory = UIMutableUserNotificationCategory()
        //记住这个identifier ，待会用
        notificationCompleteCategory.identifier = identifier
        notificationCompleteCategory.setActions(actions, forContext: .Default)
        notificationCompleteCategory.setActions(actions, forContext: .Minimal)
        
        // 在用 Category 的时候必须要注册一下
        self.registerUserNotificationSettings([notificationCompleteCategory])
    }
    
    
    // MARK: - 创建交互按钮
    /**
     创建一个本地通知弹出框的交互按钮
     
     - parameter title:          按钮显示名称
     - parameter id:             按钮的identifier
     - parameter activationMode: 点击后是否跳转到APP里
     
     - returns: 返回一个交互按钮
     */
    func createNotificationAction(title: String, id: String, activationMode: Bool) -> UIMutableUserNotificationAction {
        let notificationAction: UIMutableUserNotificationAction = UIMutableUserNotificationAction()
        notificationAction.title = title
        notificationAction.identifier = id
        // 是否作为 destructive 样式提醒
        notificationAction.destructive = false
        // 执行这个操作的时候是否要解锁设备
        notificationAction.authenticationRequired = false
        // 是否唤醒App
        notificationAction.activationMode = activationMode ? UIUserNotificationActivationMode.Foreground: UIUserNotificationActivationMode.Background
        
        return notificationAction
    }
    
    
    
    // MARK: - 调用本地通知
    /**
     调用一个本地通知
     
     - parameter notification: 被调用的通知
     */
    func scheduleLocalNotification(notification: UILocalNotification) {
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
    }
    
    
    // MARK: - 注册本地通知
    func registerUserNotificationSettings(notificationCategory: [AnyObject]? = nil) {
        let set = (notificationCategory != nil) ? NSSet(array: notificationCategory!) as? Set<UIUserNotificationCategory> : nil
        
        UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Sound , .Alert , .Badge], categories: set ))
    }
    
    
    // MARK: - 移除
    func removeAll() {
        UIApplication.sharedApplication().cancelAllLocalNotifications()
    }
    
    func remove(notification: UILocalNotification) {
        UIApplication.sharedApplication().cancelLocalNotification(notification)
    }
    
    func removeBadgeNumber() {
        UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    }
    
}
