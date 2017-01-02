//
//  DayConsumeViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/13.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class DayConsumeViewModel: NSObject {
    
    // VC 使用的变量
    var dayConsumeArr: [SingleConsume]?
    var dayConsumeMoney: Double = 0.0
    let today: Date
    
    
    override init() {
        self.today = Date()
        
        super.init()
        self.initData()
    }
    
    init(today: Date) {
        self.today = today
        
        super.init()
        self.initData()
    }
    
    /**
     初始化数据
     */
    func initData() {
        dayConsumeArr = self.gainDayConsumeInfo(today)
        dayConsumeMoney = self.gainDayConsumeMoney(today)
    }
    
    
    // MARK: - TableView 数据操作
    
    func numberOfItemsInSection() -> NSInteger {
        return (self.dayConsumeArr?.count)!
    }
    
    func consumeInfoAtIndex(_ index: NSInteger) -> SingleConsume {
        return dayConsumeArr![index]
    }
    
    // MARK: - 私有函数
    
    /**
     获取今日所有的消费信息，并转化为FinanceOfCategory数组（即 tableView 直接可用）
     
     - returns: 今日所有的消费信息
     */
    fileprivate func gainDayConsumeInfo(_ today: Date) ->[SingleConsume] {
        return SingleConsume.fetchConsumeRecordInThisDay(today)
    }
    
    
    fileprivate func gainDayConsumeMoney(_ today: Date) -> Double {
        return SingleConsume.fetchExpensesInThisDay(today)
    }
    
    
    
}
