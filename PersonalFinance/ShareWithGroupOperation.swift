//
//  ShareWithGroupOperation.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/21.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

private let sharedInstance = ShareWithGroupOperation()
private let MonthExpense = "MonthExpense"
private let DayExpense = "DayExpense"


class ShareWithGroupOperation: NSObject {
    
    private let userDefault: NSUserDefaults = {
        return NSUserDefaults(suiteName: "group.PersonalFinanceSharedDefaults")
    }()!
    
    // 设置 单例
    class var sharedGroupOperation: ShareWithGroupOperation {
        return sharedInstance
    }
    
    // MARK: - 每月支出
    func saveNewMonthExpense(value: Double) {
        saveMoneyInfo(value, key: MonthExpense)
    }
    
    func gainMonthExpense() ->Double {
        return self.getMoneyInfo(MonthExpense)
    }
    
    // MARK: - 每日支出    
    func saveNewDayExpense(value: Double) {
        self.saveMoneyInfo(value, key: DayExpense)
    }
    
    func gainDayExpense() ->Double {
        return self.getMoneyInfo(DayExpense)
    }
    
}

// MARK: - NSUserDefault 操作
extension ShareWithGroupOperation {
    private func saveMoneyInfo(value: Double, key: String) {
        self.userDefault.setDouble(value, forKey: key)
        self.userDefault.synchronize()
    }
    
    private func getMoneyInfo(key: String) ->Double {
        return self.userDefault.doubleForKey(key)
    }
}