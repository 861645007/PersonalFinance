//
//  BaseInfo.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

private let sharedInstance = BaseInfo()

class BaseInfo: NSObject {
    // 设置 单例
    class var sharedBaseInfo: BaseInfo {
        return sharedInstance
    }
    
    private let userDefault: NSUserDefaults = {
        return NSUserDefaults.standardUserDefaults()
    }()
    
    
    // MARK: - 每月预算
    func saveMonthBudget(value: NSNumber) {
        self.saveMoneyInfo(value.doubleValue, key: "MonthBudget")
    }
    
    func gainMonthBudget() ->NSNumber {
        return NSNumber(double: self.getMoneyInfo("MonthBudget"))
    }
    
    // MARK: - 最新消费
    func saveNewExpense(value: NSNumber) {
        self.saveMoneyInfo(value.doubleValue, key: "NewExpense")
    }
    
    func gainNewExpense() ->NSNumber {
        return NSNumber(double: self.getMoneyInfo("NewExpense"))
    }
    
    
    // MARK: - 每月支出
    func addMonthExpense(value: NSNumber) {
        let totalExpense = value.doubleValue + self.gainMonthExpense().doubleValue
        self.saveMoneyInfo(totalExpense, key: "MonthExpense")
    }
    
    func gainMonthExpense() ->NSNumber {
        return NSNumber(double: self.getMoneyInfo("MonthExpense"))
    }
    
    // MARK: - 每日支出
    func addDayExpense(value: NSNumber) {
        let totalExpense = value.doubleValue + self.gainDayExpense().doubleValue
        self.saveMoneyInfo(totalExpense, key: "DayExpense")
    }
    
    func gainDayExpense() ->NSNumber {
        return NSNumber(double: self.getMoneyInfo("DayExpense"))
    }
    
    // MARK: - 判断时间信息 ，当第一次进入的时候
    /**
    当每次进入的时候，判断一下时间信息，以设置各项信息
    
    - parameter date: 被判断的时间
    */
    func judgeTimeWhenFirstUseInEveryDay(date: NSDate) {
        if !self.isCurrentMonth(date) {
            self.addMonthExpense(0.0)
            self.addDayExpense(0.0)
        }else {
            if !self.isToday(date) {
                self.addDayExpense(0.0)
            }
        }
    }
    
    // MARK: - 当第一次进入应用的时候初始化各项基本数据
    /**
     当第一次进入应用的时候初始化各项基本数据
     */
    func initDataWhenFirstUse() {
        self.addDayExpense(0.0)
        self.saveMonthBudget(0.0)
        self.addMonthExpense(0.0)
        self.saveNewExpense(0.0)
        self.saveTime(NSDate())
    }
    
    // MARK: 是否用过引导页的标示
    func saveOnBoardSymbol() {
        self.userDefault.setBool(true, forKey: "HasOnborad")
        self.userDefault.synchronize()
    }
    
    func gainOnBoardSymbol() ->Bool {
        return self.userDefault.boolForKey("HasOnborad")
    }
}

// MARK: - 各项与时间相关的操作
extension BaseInfo {
    func isCurrentMonth(date: NSDate) ->Bool {
        if date.isInThisMonth(self.gainTime()) {
            return true
        }else {
            return false
        }
    }
    
    func isToday(date: NSDate) ->Bool {
        if date.isInThisDay(self.gainTime()) {
            return true
        }else {
            return false
        }
    }
    
    private func isNewDay(date: NSDate) ->Bool {
        let tomorrow = self.gainTime().dayEnd()
        
        if tomorrow.isLaterWithNewTime(date) {
            return true
        }
        return false
    }
    
    private func saveTime(date: NSDate) {
        self.saveTimeInfo(date, key: "today")
    }
    
    private func gainTime() ->NSDate {
        return self.getTimeInfo("today")
    }
    
}


// MARK: - NSUserDefault 操作
extension BaseInfo {
    private func saveMoneyInfo(value: Double, key: String) {
        self.userDefault.setDouble(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    private func getMoneyInfo(key: String) ->Double {
        return self.userDefault.doubleForKey(key)
    }
    
    private func saveTimeInfo(value: NSDate, key: String) {
        self.userDefault.setObject(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    private func getTimeInfo(key: String) ->NSDate {
        return self.userDefault.objectForKey(key) as! NSDate
    }
}
