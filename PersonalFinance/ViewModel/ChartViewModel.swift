//
//  ChartViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/8.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Charts
import CoreData
import SwiftDate

class ChartViewModel: NSObject {
    
    var consumeTypeArr: [ConsumeCategory]?
    
    var currentMonthWithCategory: NSDate?
    
    // MARK: - 图形部分变量
        /// 饼图数据的专用
    var consumeCategoryArr: [FinanceOfCategory]?
    var consumeExpensesInSevenDays: [Double] = []
    var consumeExpensesInLastThirdWeeks: [[Double]] = []
    
    let weekdays: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    let weeks: [String] = ["前两周", "前一周", "本周"]
    var sevenDays: [String] = []
    
    
    override init() {
        super.init()
        
        // 变量处理
        currentMonthWithCategory = NSDate().endOf(.Month)
        
        // 获取 category 的数据
        self.gainAllConsumeType()
        
        self.setConsumeCategoryArrWithDate(currentMonthWithCategory!)
        self.setConsumeExpenseInSevenDaysWithTheDate()
        self.setConsumeExpensesInLastThirdWeeks()
    }
    
    
    
    // MARK: - 数据解析
    func setConsumeCategoryArrWithDate(date: NSDate) {
        // 按 category 分组 进行数据获取
        self.gainDataWithCategory(date)
    }
    
    /**
     设置七天内的数据数组
     */
    func setConsumeExpenseInSevenDaysWithTheDate() {
        sevenDays = gainDaysWithSevenDays(NSDate())
        consumeExpensesInSevenDays = self.gainExpensesWithSevenDays(NSDate())
    }
    
    /**
     获取近三周的所有消费记录
     */
    func setConsumeExpensesInLastThirdWeeks() {
        consumeExpensesInLastThirdWeeks = self.gainExpensesWithLastThridWeeks(NSDate())
    }
    
    
    // MARK: - TableView 数据
    func gainNumberOfSection() -> Int {
        return (self.consumeCategoryArr?.count)!
    }
    
    func gainFinanceCategoryAt(index: NSInteger) -> FinanceOfCategory {
        return self.consumeCategoryArr![index]
    }
    
    
    // MARK: - 图上数据配置操作
    
    // 创建 图 的数据实例
    func createDataEntries(dataPointLengths: Int, values: [Double]) -> [ChartDataEntry] {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPointLengths {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        return dataEntries
    }
    
    // MARK: - 环形图
    
    func gainDateForPreMonthWithCategory() ->NSDate {
        currentMonthWithCategory = currentMonthWithCategory! - 1.months
        return currentMonthWithCategory!
    }
    
    func gainDateForNextMonthWithCategory() ->NSDate {
        currentMonthWithCategory = currentMonthWithCategory! + 1.months
        return currentMonthWithCategory!
    }
    
    /**
     获取当月总消费额
     
     - returns: 当月总消费额
     */
    func gainTotalExpense() ->Double {
        var monthExpense = 0.0
        
        for financeCategory: FinanceOfCategory in consumeCategoryArr! {
            monthExpense += financeCategory.categoryMoney
        }
        return monthExpense
    }
    
    // 获取 各项名称
    func gainCategoryNamesWithPie() ->[String] {
        var categoryNames: [String] = []
        
        for financeCategory: FinanceOfCategory in consumeCategoryArr! {
            categoryNames.append(financeCategory.categoryName)
        }
        return categoryNames
    }
    
    // 获取各项值
    func gainCategoryRatioWithPie() ->[Double] {
        var categoryRatio: [Double] = []
        
        for financeCategory: FinanceOfCategory in consumeCategoryArr! {
            categoryRatio.append(financeCategory.categoryRatio)
        }
        return categoryRatio
    }
    
    // 设置颜色
    func setColorWithPie() -> [NSUIColor]{
        let colors: NSMutableArray = NSMutableArray()
        colors.addObjectsFromArray(ChartColorTemplates.vordiplom())
        colors.addObjectsFromArray(ChartColorTemplates.joyful())
        colors.addObjectsFromArray(ChartColorTemplates.colorful())
        colors.addObjectsFromArray(ChartColorTemplates.liberty())
        colors.addObjectsFromArray(ChartColorTemplates.pastel())
        colors.addObject(UIColor(red: 51.0/255, green: 181.0/255, blue: 229.0/255, alpha: 1.0))
        
        return colors.copy() as! [NSUIColor]
    }
    
    func setPieChartCenterText(centerStr: String) -> NSAttributedString {
        // 设置所需要的格式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
        
        let attribute1 = [NSParagraphStyleAttributeName: paragraphStyle]
        
        let attribute2 = [NSForegroundColorAttributeName: UIColor(red: 51/255.0, green: 181/255.0, blue: 229/255.0, alpha: 1.0),  NSFontAttributeName: UIFont(name: "Chalkduster", size: 18.0)!]
        
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: centerStr)
        centerText.addAttributes(attribute1, range: NSMakeRange(0, 3))
        centerText.addAttributes(attribute2, range: NSMakeRange(3, centerText.length - 3))
        
        return centerText
    }
    
    // MARK: - 走势图
    
    // 创建数据集
    func createLineChartDataSets(dataEntries: [[ChartDataEntry]]) -> [LineChartDataSet] {
        var dataSets: [LineChartDataSet] = []
        let colors = [ChartColorTemplates.vordiplom(), ChartColorTemplates.colorful(), ChartColorTemplates.joyful()]
        
        for i in 0..<weeks.count {
            dataSets.append(self.createLineChartDataSet(weeks[i], dataEntries: dataEntries[i], colors: colors[i]))
        }
        
        return dataSets
    }
    
    
    private func createLineChartDataSet(lineName: String, dataEntries: [ChartDataEntry], colors: [NSUIColor]) -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: lineName)
        
        lineChartDataSet.colors = colors
        lineChartDataSet.drawCirclesEnabled = false
        
        return lineChartDataSet
    }
    
    
    // 创建 柱状图数据
    func createBarChartDataSet(lineName: String, dataEntries: [BarChartDataEntry]) -> BarChartDataSet {
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: lineName)
        barChartDataSet.setColors(self.setColorWithPie(), alpha: 1.0)
        return barChartDataSet
    }
    
    
    // MARK: - 私有函数
    
    /**
     按 category 分组 进行数据获取
     
     - parameter date: 所需要数据的月份
     */
    private func gainDataWithCategory(date: NSDate) {
        consumeCategoryArr = []
        
        let consumeArr: NSFetchedResultsController = SingleConsume.fetchConsumeWithPieChart(date)
        for section: NSFetchedResultsSectionInfo in consumeArr.sections! {
            // 获取 当前 消费类型
            var consumeCategory: ConsumeCategory!
            for consumeC: ConsumeCategory in consumeTypeArr! {
                if consumeC.id == Int32(section.name) {
                    consumeCategory = consumeC
                    break
                }
            }
            
            // 获取当前分类的金额
            var moneyOfCategory: Double = 0
            
            for consume: SingleConsume in section.objects as! [SingleConsume] {
                moneyOfCategory += (consume.money?.doubleValue)!
            }
            
            consumeCategoryArr!.append(FinanceOfCategory(iconData: consumeCategory.iconData!, name: consumeCategory.name!, ratio: 0.0, money: moneyOfCategory))
        }
        
        // 获取消费的比例
        let monthExpense = self.gainTotalExpense()
        for financeCategory: FinanceOfCategory in consumeCategoryArr! {
            financeCategory.categoryRatio = financeCategory.categoryMoney / monthExpense
        }
    }
    
    
    
    /**
     获取七天内每天的消费额
     
     - returns: 含 每天的消费额 数组
     */
    private func gainExpensesWithSevenDays(today: NSDate) -> [Double] {
        var expensesWithSavenDays: [Double] = []
        
        for i in 0..<7 {
            expensesWithSavenDays.append(SingleConsume.fetchExpensesInThisDay(today - i.days))
        }
        
        return expensesWithSavenDays.reverse()
    }
    
    private func gainDaysWithSevenDays(today: NSDate) -> [String] {
        var days: [String] = []
        for i in 0..<7 {
            if i == 0 {
                days.append("今日")
            }else {
                days.append("\((today - i.days).day)日")
            }
        }
        return days.reverse()
    }
    
    /**
     获取近三周内的每天消费额（返回的数据格式：[[上上周],[上周],[本周]] ）
     
     - parameter today: 今天的任意时间
     
     - returns: 返回三周的消费集合
     */
    func gainExpensesWithLastThridWeeks(today: NSDate) -> [[Double]] {
        
        // 获取一周之内的所有消费集合
        func gainExpenseWithWeek(firstDayOfWeek: NSDate) -> [Double] {
            var weekdayExpenses: [Double] = []
            
            for weekdayIndex in 0..<7 {
                weekdayExpenses.append(SingleConsume.fetchExpensesInThisDay(firstDayOfWeek - weekdayIndex.days))
            }
            return weekdayExpenses
        }
        
        let firstDayOfWeek: NSDate = today.firstDayWithNextWeek(8) - 7.days
        var allExpenses: [[Double]] = []
        
        for weekIndex in 0..<3 {
            allExpenses.append(gainExpenseWithWeek(firstDayOfWeek - (weekIndex * 7).days))
        }
        
        return allExpenses
    }
    
    
    /**
     获取 所有的 Consume-Category
     */
    private func gainAllConsumeType() {
        consumeTypeArr = []
        
        // 获取数据，并转换为 常规 数据类型（非Core Data中的存储类型）
        let consumeList = Category.fetchAllConsumeCategoryWithUsed()
        
        for category: Category in consumeList {
            let consumeType = ConsumeCategory(id: (category.id?.intValue)!, name: category.name!, icon: category.iconData!)
            consumeTypeArr?.append(consumeType)
        }
        consumeTypeArr?.append(ConsumeCategory(id: 10000, name: "新增", icon: UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)!))
    }    
}
