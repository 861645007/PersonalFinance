//
//  DataAnalysisViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/5/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import CoreData
import SwiftDate


struct QuarterConsumeCategory {
    let categoryIcon: UIImage
    let categoryProgressValue: Double
    let categoryName: String
    let categoryDescribe: String
    
    init(icon: UIImage, progressValue: Double, name: String, describe: String) {
        self.categoryIcon          = icon
        self.categoryProgressValue = progressValue
        self.categoryName          = name
        self.categoryDescribe      = describe
    }
    
}


class DataAnalysisViewModel: NSObject {
    
    var quarterExpense: Double = 0.0
    var quarterOverviewInfo: [(String, String)] = []
    var quarterCategorysTop3: [QuarterConsumeCategory] = []
    
    
    override init() {
        super.init()
        
        quarterOverviewInfo = self.quarterOverviewData().reverse()
        quarterExpense = self.setQuarterExpense()
        quarterCategorysTop3 = self.gainQuarterCategorysTop3()
    }
    

    
    // MARK: - 私有变量
    
    // MARK: - 本月概览
    private func quarterOverviewData() -> [(String, String)] {
        return (1...3).map {[unowned self] in
            let month = NSDate() - $0.months
            return ("\(month.month)月", "\(self.monthExpense(month).convertToStrWithTwoFractionDigits())元")
        }
    }
    
    
    private func monthExpense(month: NSDate) -> Double {
        return SingleConsume.fetchExpensesInThisMonth(month)
    }
    
    // 获取一个季度的总消费额
    private func setQuarterExpense() -> Double {
        return (1...3).reduce(0.0) {
            return $0 + SingleConsume.fetchExpensesInThisMonth(NSDate() - $1.months)
        }
    }
    
    
    // MARK: - 季度类型消费Top3
    
    // 获取一个季度类型消费的Top3
    private func gainQuarterCategorysTop3() -> [QuarterConsumeCategory] {
        return self.gainQuarterCategorys().sort({ (category1, category2) -> Bool in
            category1.categoryProgressValue > category2.categoryProgressValue
        })
    }
    
    // 获取一个季度所有的类型消费
    private func gainQuarterCategorys() -> [QuarterConsumeCategory] {
        
        let quarterCategorysFetchedResultsController: NSFetchedResultsController = SingleConsume.fetchConsumeWithCategoryGroupInQuarter(NSDate())
        
        var quarterCategorys: [QuarterConsumeCategory] = []
        
        for section in quarterCategorysFetchedResultsController.sections! {
            
            // 获取 category
            let category = (section.objects?.first as! SingleConsume).consumeCategory
            
            // 当前 category 的总金额
            let quarterMoney = (section.objects as! [SingleConsume]).reduce(0.0, combine: {
                return $0 + ($1.money?.doubleValue)!
            })
            
            // 当前 category 的描述
            let describe = "你消费了\(section.objects!.count)笔，共\(quarterMoney)元"
            
            // 当前 progress bar 的 value
            let progressValue = (quarterMoney / quarterExpense) * 100
            
            quarterCategorys.append(QuarterConsumeCategory(icon: UIImage(data: (category?.iconData)!)!, progressValue: progressValue, name: (category?.name)!, describe: describe))
        }
        
        return quarterCategorys
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
