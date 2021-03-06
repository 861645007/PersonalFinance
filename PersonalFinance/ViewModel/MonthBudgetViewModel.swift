//
//  MonthBudgetViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/5/5.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class MonthBudgetViewModel: NSObject {
    let baseInfo: BaseInfo = BaseInfo.sharedBaseInfo
    
    let dealMoneyFormat = DealMoneyFormat()
    
    override init() {
        super.init()
    }
    
    
    /**
     处理金额数据格式：使之保持一个 ￥0.00 的格式
     
     - parameter text: 待处理的数字文本
     
     - returns: 处理好的数字文本
     */
    func dealWithDecimalMoney(_ text: String) -> String {
        return dealMoneyFormat.dealWithDecimalMoney(text)
    }
    
    
    func saveMonthBudget(_ money: Double) {
        baseInfo.saveMonthBudget(NSNumber(value: money as Double))
    }
    
    func gainMonthBudget() -> String {
        return baseInfo.monthBudget().convertToStrWithTwoFractionDigits()
    }
    
    
    
}
