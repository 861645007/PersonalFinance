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

class ChartViewModel: NSObject {

    var singleConsumeService: SingleCustomService!
    var categoryService: CategoryService!
    var baseInfo: BaseInfo!
    
    var consumeTypeArr: [ConsumeCategory]?
        /// 饼图数据的专用
    var consumeCategoryArr: [FinanceOfCategory]?
    
    override init() {
        super.init()
        
        baseInfo = BaseInfo.sharedBaseInfo
        categoryService = CategoryService.sharedCategoryService
        singleConsumeService = SingleCustomService.sharedSingleCustomService
        
        // 获取 category 的数据
        self.gainAllConsumeType()
        
        self.gainDataWithCategory(NSDate())
    }
    
    
    
    // MARK: - 数据解析
    /**
     按 category 分组 进行数据获取
     
     - parameter date: 所需要数据的月份
     */
    func gainDataWithCategory(date: NSDate) {
        consumeCategoryArr = []
        
        let consumeArr:NSFetchedResultsController = singleConsumeService.fetchFinanceWithPieChart(date)
        for section: NSFetchedResultsSectionInfo in consumeArr.sections! {
            // 获取 当前 消费类型
            var consumeCategory: ConsumeCategory!
            for consumeC: ConsumeCategory in consumeTypeArr! {
                if consumeC.id == Int32(section.name) {
                    consumeCategory = consumeC
                }
            }
            // 获取当前分类的金额
            var moneyOfCategory: Double = 0
            
            for consume: SingleCustom in section.objects as! [SingleCustom] {
                moneyOfCategory += (consume.money?.doubleValue)!
                print(consume.money)
            }
            // 获取消费的比例
            let ratio: Double = moneyOfCategory / baseInfo.gainMonthExpense().doubleValue
            
            consumeCategoryArr?.append(FinanceOfCategory(iconData: consumeCategory.iconData!, name: consumeCategory.name!, ratio: ratio, money: moneyOfCategory))
        }
    }
        
    
    /**
     获取 所有的 Consume-Category
     */
    func gainAllConsumeType() {
        consumeTypeArr = []
        
        // 判断表里是否有数据，没有就先存入
        if categoryService.gainCategoryCount() == 0 {
            self.initializeConsumeType()
        }
        
        // 获取数据，并转换为 常规 数据类型（非Core Data中的存储类型）
        let consumeList = categoryService.fetchAllCustomType()
        
        for category: Category in consumeList {
            let consumeType = ConsumeCategory(id: (category.id?.intValue)!, name: category.name!, icon: category.iconData!)
            consumeTypeArr?.append(consumeType)
        }
        consumeTypeArr?.append(ConsumeCategory(id: 10000, name: "新增", icon: UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)!))
        
    }
    
    
    // MARK: - 图上数据配置操作
    
    // 创建 图 的数据实例
    func createDataEntries(dataPoints: [String], values: [Double]) -> [ChartDataEntry] {
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        
        return dataEntries
    }
    
    // MARK: - 环形图
    
    func gainTotalExpense() ->Double {
        return baseInfo.gainMonthExpense().doubleValue
    }
    
    // 获取 各项名称
    func gainCategoryNamesWithPie() -> [String] {
        var categoryNames: [String] = []
        
        for financeCategory: FinanceOfCategory in consumeCategoryArr! {
            categoryNames.append(financeCategory.categoryName)
        }
        return categoryNames
    }
    
    // 获取各项值
    func gainCategoryRatioWithPie() -> [Double] {
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
    
    func setCenterTextWithPie(centerStr: String) -> NSAttributedString {
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
    
    // 创建 走势图上点和图 的颜色
    func createGradientRef(pointColorStr: String, chartColorStr: String) -> CGGradientRef {
        let gradientColors = [ChartColorTemplates.colorFromString(pointColorStr).CGColor, ChartColorTemplates.colorFromString(chartColorStr).CGColor]
        return CGGradientCreateWithColors(nil, gradientColors, nil)!
    }
    
    // 创建数据
    func createLineChartDataSet(lineName: String, dataEntries: [ChartDataEntry], gradient: CGGradientRef) -> LineChartDataSet {
        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: lineName)
        
        lineChartDataSet.fillAlpha = 1.0
        lineChartDataSet.fill = ChartFill.fillWithLinearGradient(gradient, angle: 90.0)
        lineChartDataSet.drawCubicEnabled = true
        lineChartDataSet.drawFilledEnabled = true
        
        return lineChartDataSet
    }
    
    
    
    // MARK: - 私有函数
    
    /**
     向 CoreData 里存入 预存入的数据
     */
    private func initializeConsumeType() {
        // 获取预备文件里的数据
        let plistDic = OperatePlist().gainDataWithFileName("Consume-Type")
        
        // 循环插入数据
        for (iconName, name) in plistDic {
            categoryService.insertNewCustomCategory(name, iconData: UIImagePNGRepresentation(UIImage(named: iconName)!)!)
        }
    }
    
}
