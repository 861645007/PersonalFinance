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
    var monthConsumeArr: [[String: [FinanceOfCategory]]]?
    var monthConsumeMoney: Double = 0.0
    
    override init() {
        super.init()
        
        singleConsumeService = SingleCustomService.sharedSingleCustomService
        categoryService = CategoryService.sharedCategoryService

        self.initData()
    }
    
    func initData() {
        monthConsumeArr = self.gainMonthConsumeInfo()
    }
    
    
    // MARK: - 私有函数
    
    /**
     获取今日所有的消费信息，并转化为 [[String: [FinanceOfCategory]]] （section：cells）数组（即 tableView 直接可用）
     
     - returns: 今日所有的消费信息
     */
    private func gainMonthConsumeInfo() ->[[String: [FinanceOfCategory]]] {
        let monthSingleConsumeWithFetchArr:[SingleCustom] = singleConsumeService.fetchConsumeRecordWithCurrentMonth()
        var newMonthConsumeArr: [[String: [FinanceOfCategory]]] = []
        
        var dayConsumeArr: [FinanceOfCategory] = []
        var dayStr = ""
        
        for singleConsume: SingleCustom in monthSingleConsumeWithFetchArr {
            // 判断 当前消费的时间 是否已经属于当前正在循环的日期（比如当前正在循环的日期为4月1日，当前消费日期为4月1日3点）
            // 若是，则直接把 当前消费信息加入到当前正在循环的日期的数组中；若不是，则进行一定处理
            if dayStr != "\(singleConsume.time?.month)月\(singleConsume.time?.day)日" {
                if dayStr != "" {
                    // 把整理好的一个 [section: cells] 数据加入到数组中， 并把 cells 数据数组置空
                    newMonthConsumeArr.append([dayStr: dayConsumeArr])
                    dayConsumeArr = []
                }
                // 处理时间信息
                dayStr = "\(singleConsume.time?.month)月\(singleConsume.time?.day)日"
            }
            
            let category: Category = categoryService.fetchConsumeCategoryWithId(singleConsume.category!)
            dayConsumeArr.append(FinanceOfCategory(iconData: category.iconData!, name: category.name!, ratio: 0.0, money: Double(singleConsume.money!)))
        }
        
        // 把最后一个消费信息加入到数组中
        newMonthConsumeArr.append([dayStr: dayConsumeArr])
        
        return newMonthConsumeArr
    }
    
    
    private func gainMonthConsumeMoney() -> Double {
        var money = 0.0
        for singleConsume: FinanceOfCategory in monthConsumeArr! {
            money += singleConsume.categoryMoney
        }
        return money
    }
    
}
