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
    
    fileprivate let userDefault: UserDefaults = {
        return UserDefaults.standard
    }()
    
    
    // MARK: - 每月预算
    func saveMonthBudget(_ value: NSNumber) {
        self.saveMoneyInfo(value.doubleValue, key: "MonthBudget")
    }
    
    func monthBudget() ->Double {
        return self.getMoneyInfo("MonthBudget")
    }
    
    // MARK: - 最新消费
    func newExpense() ->Double {
        guard let consume: SingleConsume = SingleConsume.fetchLastConsumeRecord() else {
            return 0.0
        }
        
        return consume.money!.doubleValue
    }
    
    // MARK: - 每周支出
    func weekExpense() ->Double {
        return SingleConsume.fetchExpensesInThisWeek(Date())
    }
    
    // MARK: - 每月支出
    func monthExpense() ->Double {
        return SingleConsume.fetchExpensesInThisMonth(Date())
    }
    
    // MARK: - 每日支出
    func dayExpense() ->Double {
        return SingleConsume.fetchExpensesInThisDay(Date())
    }
    
    
    
    // MARK: - 当第一次进入应用的时候初始化各项基本数据
    /**
     当第一次进入应用的时候初始化各项基本数据
     */
    func initDataWhenFirstUse() {
        self.saveMonthBudget(0.0)
        self.saveTime(Date())
    }
    
    // MARK: 是否用过引导页的标示
    func saveOnBoardSymbol() {
        self.userDefault.set(true, forKey: "HasOnborad")
        self.userDefault.synchronize()
    }
    
    func gainOnBoardSymbol() ->Bool {
        return self.userDefault.bool(forKey: "HasOnborad")
    }
}

// MARK: - 各项与时间相关的操作
extension BaseInfo {
    func isCurrentMonth(_ date: Date) ->Bool {
        if date.isInThisMonth(self.gainTime()) {
            return true
        }else {
            return false
        }
    }
    
    func isToday(_ date: Date) ->Bool {
        if date.isThisDay(self.gainTime()) {
            return true
        }else {
            return false
        }
    }
    
    fileprivate func isNewDay(_ date: Date) ->Bool {
        let tomorrow = self.gainTime().dayEnd()
        
        if tomorrow.isLaterWithNewTime(date) {
            return true
        }
        return false
    }
    
    func saveTime(_ date: Date) {
        self.saveTimeInfo(date, key: "today")
    }
    
    fileprivate func gainTime() ->Date {
        return self.getTimeInfo("today")
    }
    
}


// MARK: - NSUserDefault 操作
extension BaseInfo {
    fileprivate func saveMoneyInfo(_ value: Double, key: String) {
        self.userDefault.set(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    fileprivate func getMoneyInfo(_ key: String) ->Double {
        return self.userDefault.double(forKey: key)
    }
    
    fileprivate func saveTimeInfo(_ value: Date, key: String) {
        self.userDefault.set(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    fileprivate func getTimeInfo(_ key: String) ->Date {
        return self.userDefault.object(forKey: key) as! Date
    }
}
