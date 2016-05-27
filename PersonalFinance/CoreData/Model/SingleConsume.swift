
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
        
        singleConsume.id       = NSNumber(int: Int32(SingleConsume.MR_countOfEntities()) + 1)
        singleConsume.category = NSNumber(int: category)
        singleConsume.photo    = photo
        singleConsume.comment  = comment
        singleConsume.money    = NSNumber(double: money)
        singleConsume.time     = time
        singleConsume.consumeCategory = Category.fetchConsumeCategoryWithId(NSNumber(int: category))
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
    }
    
    // MARK: - 修改消费信息    
    class func modifySingleCustom(id: Int32, category: Int32, photo: NSData, comment: String, money: Double, time: NSDate){
        let singleConsume: SingleConsume = SingleConsume.MR_findFirstByAttribute("id", withValue: NSNumber(int: id))!
        
        singleConsume.category = NSNumber(int: category)
        singleConsume.photo    = photo
        singleConsume.comment  = comment
        singleConsume.money    = NSNumber(double: money)
        singleConsume.time     = time
        singleConsume.consumeCategory = Category.fetchConsumeCategoryWithId(NSNumber(int: category))
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    // MARK: - 查询消费记录
    
    // MARK: - 查询图表页面所需的信息
    
    /**
     获取一个星期的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInWeek(date: NSDate) ->NSFetchedResultsController {
        return self.fetchCustomWithRangeDate(date.weekBegin(), dateEnd: date.weekEnd())
    }
    
    /**
     获取一个月的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInMonth(date: NSDate) ->NSFetchedResultsController {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    /**
     获取一年的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInYear(date: NSDate) ->NSFetchedResultsController {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    
    
    
    // MARK: 查询消费情况集合
    
    /**
     查询今天的所有消费记录
     
     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    class func fetchConsumeRecordInThisDay(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.dayBegin(), dateEnd: date.dayEnd())
    }
    
    class func fetchConsumeRecordInThisWeek(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.weekBegin(), dateEnd: date.weekEnd())
    }
    
    class func fetchConsumeRecordInThisMonth(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    
    class func fetchConsumeRecordInThisYear(date: NSDate) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    
    class func fetchLastConsumeRecord() ->SingleConsume? {        
        return SingleConsume.MR_findFirstWithPredicate(nil, sortedBy: "time", ascending: false)
    }
    
    
    // MARK: - 查询消费总额
    
    /**
     获取指定日期的消费总额
     
     - parameter day: 指定日期内的任意时刻
     
     - returns: 指定日期内的消费总额
     */
    class func fetchExpensesInThisDay(day: NSDate) -> Double {
        return SingleConsume.fetchConsumeRecordInThisDay(day).reduce(0.0, combine: {
            $0 + $1.money!.doubleValue
        })
    }
    
    class func fetchExpensesInThisWeek(day: NSDate) -> Double {
        return SingleConsume.fetchConsumeRecordInThisWeek(day).reduce(0.0, combine: {
            $0 + $1.money!.doubleValue
        })
    }
    
    class func fetchExpensesInThisMonth(day: NSDate) -> Double {
        return SingleConsume.fetchConsumeRecordInThisMonth(day).reduce(0.0, combine: {
            $0 + $1.money!.doubleValue
        })
    }
    
    
    
    
    //MARK: - 私有函数
    
    /**
     按Category进行分组查询一段时间内的 消费记录，并按照时间顺序排列
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 一段时间内的 消费记录（NSFetchedResultsController）
     */
    private static func fetchCustomWithRangeDate(dateBegin: NSDate, dateEnd: NSDate) ->NSFetchedResultsController {
        let predicate = self.createPredicateWithRangeDate(dateBegin, dateEnd: dateEnd)
        return SingleConsume.MR_fetchAllGroupedBy("category", withPredicate: predicate, sortedBy: "category,time", ascending: true)
    }
    
    /**
     查询一段时间内的 消费记录，并按照时间顺序排列
     
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
