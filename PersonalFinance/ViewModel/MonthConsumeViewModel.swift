//
//  MonthConsumeViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/14.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import CoreData

enum MonthOrWeekVCState {
    case month
    case week
}

class MonthConsumeViewModel: NSObject {
    
    
    // VC 使用的变量
    var singleConsumes: [DayConsumeInfo]?
    var sectionIsShow: [Bool] = []
    var consumesMoney: Double = 0.0
    
    var vcState: MonthOrWeekVCState = .month
    
    let today: Date
    
    override init() {
        today = Date()
        
        super.init()
        self.initData()
    }
    
    init(state: MonthOrWeekVCState, today: Date) {
        self.today = today
        self.vcState = state
        
        
        super.init()
        self.initData()
    }
    
    func initData() {
        singleConsumes   = self.gainConsumesInfo()
        consumesMoney = self.gainConsumesMoney()
        sectionIsShow     = self.initSectionIsShow()
    }
    
    
    // MARK: - TableView 数据源
    func numberOfSections() -> NSInteger {
        return (singleConsumes?.count)!
    }
    
    func numberOfCellsInSection(_ section: NSInteger) -> NSInteger {
        return sectionIsShow[section] ? (singleConsumes![section].dayConsumeArr?.count)! : 0
    }
    
    
    func conusmeInfoAtIndexPath(_ indexPath: IndexPath) -> SingleConsume {
        return singleConsumes![indexPath.section].dayConsumeArr![indexPath.row]
    }
    
    func titleWithTimeForSection(_ section: NSInteger) -> String {
        return singleConsumes![section].dateStr
    }
    
    
    func titleWithMoneyForSection(_ section: NSInteger) -> String {
        return "￥" + singleConsumes![section].dayExpense.convertToStrWithTwoFractionDigits()
    }
    
    /**
     设置某一个 section 的 cell 是隐藏还是展开
     
     - parameter section: section 的 index
     */
    func setCellIsShowOfSection(_ section: NSInteger) {
        self.sectionIsShow[section] = !self.sectionIsShow[section]
    }
    
    // MARK: - 私有函数
    
    /**
     获取今日所有的消费信息，并转化为 [[String: [SingleConsume]]] （section：cells）数组（即 tableView 直接可用）
     
     - returns: 今日所有的消费信息
     */
    fileprivate func gainConsumesInfo() ->[DayConsumeInfo] {
        let singleConsumeWithFetchArr:[SingleConsume] = (self.vcState == .month) ? SingleConsume.fetchConsumeRecordInThisMonth(Date()) : SingleConsume.fetchConsumeRecordInThisWeek(Date())
        
        var newConsumeArr: [DayConsumeInfo] = []
        
        var dayConsumeInfo: DayConsumeInfo = DayConsumeInfo()
        
        for singleConsume: SingleConsume in singleConsumeWithFetchArr {
            // 判断 当前消费的时间 是否已经属于当前正在循环的日期（比如当前正在循环的日期为4月1日，当前消费日期为4月1日3点）
            // 若是，则直接把 当前消费信息加入到当前正在循环的日期的数组中；若不是，则进行一定处理
            if dayConsumeInfo.dateStr != "\(singleConsume.time!.month)月\(singleConsume.time!.day)日" {
                if dayConsumeInfo.dateStr != "" {
                    // 把整理好的一个 [section: cells] 数据加入到数组中， 并把 cells 数据数组置空
                    newConsumeArr.append(dayConsumeInfo)
                    dayConsumeInfo = DayConsumeInfo()
                }
                // 处理时间信息
                dayConsumeInfo.dateStr = "\(singleConsume.time!.month)月\(singleConsume.time!.day)日"
            }
            
            dayConsumeInfo.setDayConsumeInfoArr(singleConsume)
            dayConsumeInfo.addDayExpense(singleConsume.money!.doubleValue)
        }
        
        // 把最后一个消费信息加入到数组中
        if dayConsumeInfo.dayConsumeArr?.count != 0 {
            newConsumeArr.append(dayConsumeInfo)
        }        
        
        return newConsumeArr
    }
    
    fileprivate func gainConsumesMoney() -> Double {
        return (self.vcState == .month) ? SingleConsume.fetchExpensesInThisMonth(Date()) : SingleConsume.fetchExpensesInThisWeek(Date())
    }
    
    fileprivate func initSectionIsShow() -> [Bool] {
        return self.singleConsumes!.map {_ in 
            false
        }
    }
    
}
