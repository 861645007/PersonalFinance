//
//  DayConsumeViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/13.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class DayConsumeViewModel: NSObject {
    
    // 私有变量
    var singleConsumeService: SingleCustomService!
    var categoryService: CategoryService!
    
    // VC 使用的变量
    var dayConsumeArr: [FinanceOfCategory]?
    var dayConsumeMoney: Double = 0.0
    
    override init() {
        super.init()
        
        singleConsumeService = SingleCustomService.sharedSingleCustomService
        categoryService = CategoryService.sharedCategoryService
        self.initData()
    }
    
    /**
     初始化数据
     */
    func initData() {
        dayConsumeArr = self.gainDayConsumeInfo()
        dayConsumeMoney = self.gainDayConsumeMoney()
    }
    
    
    // MARK: - TableView 数据操作
    
    func numberOfItemsInSection() -> NSInteger {
        return (self.dayConsumeArr?.count)!
    }
    
    func consumeInfoAtIndex(index: NSInteger) -> FinanceOfCategory {
        return dayConsumeArr![index]
    }
    
    // MARK: - 私有函数
    
    /**
     获取今日所有的消费信息，并转化为FinanceOfCategory数组（即 tableView 直接可用）
     
     - returns: 今日所有的消费信息
     */
    private func gainDayConsumeInfo() ->[FinanceOfCategory] {
        let todaySingleConsumeWithFetchArr:[SingleCustom] = singleConsumeService.fetchConsumeRecordWithToday()
        var newDayConsumeArr: [FinanceOfCategory] = []
        
        for singleConsume: SingleCustom in todaySingleConsumeWithFetchArr {
            let category: Category = categoryService.fetchConsumeCategoryWithId(singleConsume.category!)
            
            newDayConsumeArr.append(FinanceOfCategory(iconData: category.iconData!, name: category.name!, ratio: 0.0, money: Double(singleConsume.money!)))
        }
    
        return newDayConsumeArr
    }
    
    
    private func gainDayConsumeMoney() -> Double {
        var money = 0.0
        for singleConsume: FinanceOfCategory in dayConsumeArr! {
            money += singleConsume.categoryMoney
        }
        return money
    }
    
    
    
}
