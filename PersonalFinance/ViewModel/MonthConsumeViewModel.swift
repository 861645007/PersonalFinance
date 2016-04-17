//
//  MonthConsumeViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/14.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import CoreData

class MonthConsumeViewModel: NSObject {

    // 私有变量
    var singleConsumeService: SingleCustomService!
    var categoryService: CategoryService!
    
    // VC 使用的变量
    var monthConsumeArr: [DayConsumeInfo]?
    var monthConsumeMoney: Double = 0.0
    
    override init() {
        super.init()
        
        singleConsumeService = SingleCustomService.sharedSingleCustomService
        categoryService = CategoryService.sharedCategoryService

        self.initData()
    }
    
    func initData() {
        monthConsumeArr = self.gainMonthConsumeInfo()
        monthConsumeMoney = self.gainMonthConsumeMoney()
    }
    
    
    // MARK: - TableView 数据源
    func numberOfSections() -> NSInteger {
        return (monthConsumeArr?.count)!
    }
    
    func numberOfCellsInSection(section: NSInteger) -> NSInteger {
        return (monthConsumeArr![section].dayConsumeArr?.count)!
    }
    
    
    func conusmeInfoAtIndexPath(indexPath: NSIndexPath) -> FinanceOfCategory {
        return monthConsumeArr![indexPath.section].dayConsumeArr![indexPath.row]
    }
    
    func titleWithTimeForSection(section: NSInteger) -> String {
        return monthConsumeArr![section].dateStr
    }
    
    
    func titleWithMoneyForSection(section: NSInteger) -> String {
        return "￥" + monthConsumeArr![section].dayExpense.convertToStrWithTwoFractionDigits()
    }
    
    // MARK: - 私有函数
    
    /**
     获取今日所有的消费信息，并转化为 [[String: [FinanceOfCategory]]] （section：cells）数组（即 tableView 直接可用）
     
     - returns: 今日所有的消费信息
     */
    private func gainMonthConsumeInfo() ->[DayConsumeInfo] {
        let monthSingleConsumeWithFetchArr:[SingleConsume] = singleConsumeService.fetchConsumeRecordWithCurrentMonth()
        var newMonthConsumeArr: [DayConsumeInfo] = []
        
        var dayConsumeInfo: DayConsumeInfo = DayConsumeInfo()
        
        for singleConsume: SingleConsume in monthSingleConsumeWithFetchArr {
            // 判断 当前消费的时间 是否已经属于当前正在循环的日期（比如当前正在循环的日期为4月1日，当前消费日期为4月1日3点）
            // 若是，则直接把 当前消费信息加入到当前正在循环的日期的数组中；若不是，则进行一定处理
            if dayConsumeInfo.dateStr != "\(singleConsume.time!.month)月\(singleConsume.time!.day)日" {
                if dayConsumeInfo.dateStr != "" {
                    // 把整理好的一个 [section: cells] 数据加入到数组中， 并把 cells 数据数组置空
                    newMonthConsumeArr.append(dayConsumeInfo)
                    dayConsumeInfo = DayConsumeInfo()
                }
                // 处理时间信息
                dayConsumeInfo.dateStr = "\(singleConsume.time!.month)月\(singleConsume.time!.day)日"
            }
            
            let category: Category = categoryService.fetchConsumeCategoryWithId(singleConsume.category!)
            dayConsumeInfo.setDayConsumeInfoArr(FinanceOfCategory(iconData: category.iconData!, name: category.name!, ratio: 0.0, money: Double(singleConsume.money!)))
            dayConsumeInfo.addDayExpense(singleConsume.money!.doubleValue)
        }
        
        // 把最后一个消费信息加入到数组中
        if dayConsumeInfo.dayConsumeArr?.count != 0 {
            newMonthConsumeArr.append(dayConsumeInfo)
        }        
        
        return newMonthConsumeArr
    }
    
    private func gainMonthConsumeMoney() -> Double {
        var money = 0.0
        for dayConsume: DayConsumeInfo in monthConsumeArr! {
            money += dayConsume.dayExpense
        }
        return money
    }
    
}
