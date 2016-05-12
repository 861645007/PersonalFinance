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


enum ChartTimeModel {
    case Week
    case Month
    case Year
}

class ChartViewModel: NSObject {
    
    var consumeTypeArr: [ConsumeCategory]?
    
    var currentYear: NSDate
    var currentWeek: NSDate
    var currentMonth: NSDate
    
    // MARK: - 图形部分变量
    var consumesForPieChart: [FinanceOfCategory]?
    var consumesForBarChart: [Double] = []
    
    let weekdays: [String] = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"]
    let months: [String] = ["一月", "二月", "三月", "四月", "五月", "六月", "七月", "八月", "九月", "十月", "十一月", "十二月"]
    var daysOfMonth: [String] = []
    
    override init() {
        // 变量处理
        currentMonth = NSDate().startOf(.Month) + 12.hours
        currentWeek  = NSDate().startOf(.WeekOfYear) + 12.hours
        currentYear  = NSDate().startOf(.Year) + 12.hours
        
        super.init()
        
        // 获取 category 的数据
        self.gainAllConsumeType()
        
        self.setConsumesForChart(.Week)
    }
    
    
    
    // MARK: - 数据解析
    
    func setConsumesForChart(model: ChartTimeModel) {
        
        switch model {
        case .Week:
            self.perpareConsumesForChart(currentWeek, model: model)
        case .Month:
            self.perpareConsumesForChart(currentMonth, model: model)
        case .Year:
            self.perpareConsumesForChart(currentYear, model: model)
        }
    }
    
    func setCurrentTime(model: ChartTimeModel) -> String {
        switch model {
        case .Week:
            return "\(currentWeek.year)年-\(currentWeek.month)月  第\(currentWeek.weekOfYear)周"
        case .Month:
            return "\(currentMonth.year)年-\(currentMonth.month)月"
        case .Year:
            return "\(currentYear.year)年"
        }
    }
    
    // MARK: - TableView 数据
    func gainNumberOfSection() -> Int {
        return (self.consumesForPieChart?.count)!
    }
    
    func gainFinanceCategoryAt(index: NSInteger) -> FinanceOfCategory {
        return self.consumesForPieChart![index]
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
    
    // MARK: - 时间操作
    
    func setMonthToPre() {
        currentMonth = currentMonth - 1.months
    }
    
    func setMonthToNext() {
        currentMonth = currentMonth + 1.months
    }
    
    func setWeekToPre() {
        currentWeek = currentWeek - 1.weeks
    }
    
    func setWeekToNext() {
        currentWeek = currentWeek + 1.weeks
    }
    
    func setYearToPre() {
        currentYear = currentYear - 1.years
    }
    
    func setYearToNext() {
        currentYear = currentYear + 1.years
    }
    
    // MARK: - 环形图
    /**
     获取当月总消费额
     
     - returns: 当月总消费额
     */
    func gainTotalExpense() ->Double {
        return consumesForPieChart!.reduce(0.0, combine: {
            $0 + $1.categoryMoney
        })
    }
    
    // 获取 各项名称
    func gainCategoryNamesWithPie() ->[String] {
        return consumesForPieChart!.map({ (financeCategory: FinanceOfCategory) in
            financeCategory.categoryName
        })
    }
    
    // 获取各项值
    func gainCategoryRatioWithPie() ->[Double] {
        return consumesForPieChart!.map({
            $0.categoryRatio
        })
    }
    
    // 设置颜色
    func setColorWithPie() -> [NSUIColor]{
        let colors: NSMutableArray = NSMutableArray()
        colors.addObjectsFromArray(ChartColorTemplates.joyful())
        colors.addObjectsFromArray(ChartColorTemplates.colorful())
        colors.addObjectsFromArray(ChartColorTemplates.liberty())
        colors.addObjectsFromArray(ChartColorTemplates.pastel())
        
        return colors.copy() as! [NSUIColor]
    }
    
    func setPieChartCenterText(centerStr: String) -> NSAttributedString {
        // 设置所需要的格式
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.Center
                
        let attribute2 = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let centerText: NSMutableAttributedString = NSMutableAttributedString(string: centerStr)
        centerText.addAttributes(attribute2, range: NSMakeRange(0, centerText.length))
        
        return centerText
    }
    
    // 创建 柱状图数据
    func createBarChartDataSet(lineName: String, dataEntries: [BarChartDataEntry]) -> BarChartDataSet {
        let barChartDataSet = BarChartDataSet(yVals: dataEntries, label: lineName)
        barChartDataSet.setColors(self.setColorWithPie(), alpha: 1.0)
        return barChartDataSet
    }
    
    func gainDaysWithMonth() -> [String] {
        return (0..<currentMonth.monthDays).map {
            return "\((currentMonth + $0.days).day)日"
        }
    }
    
    // MARK: - 私有函数：数据的获取
    // 数据设置
    private func perpareConsumesForChart(date: NSDate,model: ChartTimeModel) {
        // 配置饼图数据
        self.dealConsumesForPieChart(self.gainConsumeFetchedResultsController(date, model: model))
        // 配置柱状图数据
        self.consumesForBarChart = self.gainConsumesForBarChart(date, model: model)
    }
    
    /**
     处理按category分组获取的消费数据
     
     - parameter consumeFetchedResultsController: 所被处理的消费数据
     */
    private func dealConsumesForPieChart(consumeFetchedResultsController: NSFetchedResultsController) {
        self.consumesForPieChart = []
        
        for section in consumeFetchedResultsController.sections! {
            
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
            
            self.consumesForPieChart?.append(FinanceOfCategory(iconData: consumeCategory.iconData!, name: consumeCategory.name!, ratio: 0.0, money: moneyOfCategory))
        }
        
        // 获取消费的比例
        let monthExpense = self.gainTotalExpense()
        for financeCategory: FinanceOfCategory in self.consumesForPieChart! {
            financeCategory.categoryRatio = financeCategory.categoryMoney / monthExpense
        }
    }
    
    private func gainConsumeFetchedResultsController(date: NSDate, model: ChartTimeModel) -> NSFetchedResultsController {
        
        switch model {
        case .Week:
            return SingleConsume.fetchConsumeWithCategoryGroupInWeek(date)
        case .Month:
            return SingleConsume.fetchConsumeWithCategoryGroupInMonth(date)
        case .Year:
            return SingleConsume.fetchConsumeWithCategoryGroupInYear(date)
        }
    }
    
    
    /**
     获取一周内每天的消费额
     
     - returns: 含 每天的消费 数组
     */
    private func gainConsumesForBarChart(today: NSDate, model: ChartTimeModel) -> [Double] {
        
        switch model {
        case .Week:            
            return (0..<7).map({
                SingleConsume.fetchConsumeRecordInThisDay(today + $0.days).reduce(0.0, combine: {
                    $0 + $1.money!.doubleValue
                })
            })
        case .Month:
            return (0..<today.monthDays).map({
                SingleConsume.fetchConsumeRecordInThisDay(today + $0.days).reduce(0.0, combine: {
                    $0 + $1.money!.doubleValue
                })
            })
        case .Year:
            return (0..<12).map({
                SingleConsume.fetchConsumeRecordInThisMonth(today + $0.months).reduce(0.0, combine: {
                    $0 + $1.money!.doubleValue
                })
            })
        }
    }
    
    
    /**
     获取 所有的 Consume-Category
     */
    private func gainAllConsumeType() {
        consumeTypeArr = Category.fetchAllConsumeCategoryWithUsed().map { (category: Category) in
             ConsumeCategory(id: (category.id?.intValue)!, name: category.name!, icon: category.iconData!)
        }
        
        consumeTypeArr?.append(ConsumeCategory(id: 10000, name: "新增", icon: UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)!))
    }    
}
