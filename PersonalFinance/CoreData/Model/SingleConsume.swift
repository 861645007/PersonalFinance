//
//  SingleConsume.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/17.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class SingleConsume: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    // MARK: - 新增消费记录
    class func addNewSingleCustom(category: Int32, photo: NSData, comment: String, money: Double, time: NSDate) {
        let singleConsume: SingleConsume = SingleConsume.MR_createEntity()!
        
        singleConsume.category = NSNumber(int: category)
        singleConsume.photo    = photo
        singleConsume.comment  = comment
        singleConsume.money    = NSNumber(double: money)
        singleConsume.time     = time.tolocalTime()
        singleConsume.consumeCategory = Category.fetchConsumeCategoryWithId(NSNumber(int: category))
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    
    // MARK: - 查询消费记录
    /**
     按年查询 一年的消费记录 to 走势图
     
     - parameter date: 一年中的任意日期
     
     - returns: 一年的消费记录
     */
    class func fetchConsumeWithYearTrendChart(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    /**
     按月查询 一个月的消费记录 to 走势图
     
     - parameter date: 一个月中的任意日期
     
     - returns: 一个月的消费记录
     */
    class func fetchConsumeWithMonthTrendChart(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    
    /**
     获取一个月的 环形图 的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据 to 走势图
     */
    class func fetchConsumeWithPieChart(date: NSDate) ->NSFetchedResultsController {
        let predicate = self.createPredicateWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
        
//        let request = SingleConsume.MR_requestAllWithPredicate(predicate)
        return SingleConsume.MR_fetchAllGroupedBy("category", withPredicate: predicate, sortedBy: "time", ascending: true)
    }
    
    
    // MARK: 消费列表使用的查询数据
    
    /**
     查询今天的所有消费记录
     
     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    class func fetchConsumeRecordWithToday() ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(NSDate().dayBegin(), dateEnd: NSDate().dayEnd())
    }
    
    /**
     查询当月的所有消费记录
     
     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    class func fetchConsumeRecordWithCurrentMonth() ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(NSDate().monthBegin(), dateEnd: NSDate())
    }
    
    
    //MARK: - 私有函数
    
    /**
     查询一段时间内的 消费记录，并按照时间顺序排列，Category进行分组
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 一段时间内的 消费记录
     */
    private static func fetchCustomWithRangeDate(dateBegin: NSDate, dateEnd: NSDate) ->[SingleConsume] {
        let predicate = self.createPredicateWithRangeDate(dateBegin, dateEnd: dateEnd)
        
        return SingleConsume.MR_findAllSortedBy("time", ascending: true, withPredicate: predicate) as! [SingleConsume]
    }
    
    /**
     按时间段创建一个正则表达式
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 正则表达式
     */
    private static func createPredicateWithRangeDate(dateBegin :NSDate, dateEnd: NSDate) -> NSPredicate {
        return NSPredicate(format: "time >= %@ AND time <= %@", dateBegin, dateEnd)
    }
}
