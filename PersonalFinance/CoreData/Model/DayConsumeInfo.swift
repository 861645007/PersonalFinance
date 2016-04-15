//
//  DayConsumeInfo.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class DayConsumeInfo: NSObject {
    
    var dateStr: String = ""
    var dayConsumeArr: [FinanceOfCategory]?
    var dayExpense: Double = 0.0
    
    override init() {
        self.dayConsumeArr = []
    }
    
    init(date: String, consume: [FinanceOfCategory], money: Double) {
        super.init()
        
        self.dateStr = date
        self.dayConsumeArr = consume
        self.dayExpense = money
    }
    
    func setDayConsumeInfoArr(financeCategory: FinanceOfCategory) {
        self.dayConsumeArr?.append(financeCategory)
    }
    
    func addDayExpense(money: Double) {
        self.dayExpense += money
    }
    
}
