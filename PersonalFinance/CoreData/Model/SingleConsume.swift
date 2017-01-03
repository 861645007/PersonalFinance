
//
//  SingleConsume.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/17.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData

class SingleConsume: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    // MARK: - 新增消费记录
    class func addNewSingleCustom(_ category: Int32, photo: Data, comment: String, money: Double, time: Date) {
        
        let singleConsume: SingleConsume = SingleConsume.mr_createEntity()!
        
        singleConsume.id       = NSNumber(value: Int32(SingleConsume.mr_countOfEntities()) + 1)
        singleConsume.category = NSNumber(value: category as Int32)
        singleConsume.photo    = photo
        singleConsume.comment  = comment
        singleConsume.money    = NSNumber(value: money as Double)
        singleConsume.time     = time
        singleConsume.consumeCategory = Category.fetchConsumeCategoryWithId(NSNumber(value: category as Int32))
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
        
    }
    
    // MARK: - 修改消费信息    
    class func modifySingleCustom(_ id: Int32, category: Int32, photo: Data, comment: String, money: Double, time: Date){
        let singleConsume: SingleConsume = SingleConsume.mr_findFirst(byAttribute: "id", withValue: NSNumber(value: id))!
        
        singleConsume.category = NSNumber(value: category as Int32)
        singleConsume.photo    = photo
        singleConsume.comment  = comment
        singleConsume.money    = NSNumber(value: money as Double)
        singleConsume.time     = time
        singleConsume.consumeCategory = Category.fetchConsumeCategoryWithId(NSNumber(value: category as Int32))
        
        NSManagedObjectContext.mr_default().mr_saveToPersistentStoreAndWait()
    }
    
    // MARK: - 查询消费记录
    
    // MARK: - 查询图表页面所需的信息
    
    /**
     获取一个星期的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInWeek(_ date: Date) ->NSFetchedResultsController<NSFetchRequestResult> {
        return self.fetchCustomWithRangeDate(date.weekBegin(), dateEnd: date.weekEnd())
    }
    
    /**
     获取一个月的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInMonth(_ date: Date) ->NSFetchedResultsController<NSFetchRequestResult> {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    /**
     获取一年的数据(按 Category 组分类)
     
     - returns: 一个 NSFetchedResultsController 的实例数据
     */
    class func fetchConsumeWithCategoryGroupInYear(_ date: Date) ->NSFetchedResultsController<NSFetchRequestResult> {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    // 季度
    class func fetchConsumeWithCategoryGroupInQuarter(_ date: Date) ->NSFetchedResultsController<NSFetchRequestResult> {
        return self.fetchCustomWithRangeDate(date.quarterBegin(), dateEnd: date.quarterEnd())
    }
    
    
    // MARK: 查询消费情况集合
    
    /**
     查询今天的所有消费记录
     
     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    class func fetchConsumeRecordInThisDay(_ date: Date) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.dayBegin(), dateEnd: date.dayEnd())
    }
    
    class func fetchConsumeRecordInThisWeek(_ date: Date) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.weekBegin(), dateEnd: date.weekEnd())
    }
    
    class func fetchConsumeRecordInThisMonth(_ date: Date) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    
    class func fetchConsumeRecordInThisYear(_ date: Date) ->[SingleConsume] {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    
    class func fetchLastConsumeRecord() ->SingleConsume? {        
        return SingleConsume.mr_findFirst(with: nil, sortedBy: "time", ascending: false)
    }
    
    
    // MARK: - 查询消费总额
    
    /**
     获取指定日期的消费总额
     
     - parameter day: 指定日期内的任意时刻
     
     - returns: 指定日期内的消费总额
     */
    class func fetchExpensesInThisDay(_ day: Date) -> Double {
        return SingleConsume.fetchConsumeRecordInThisDay(day).reduce(0.0, {
            $0 + $1.money!.doubleValue
        })
    }
    
    class func fetchExpensesInThisWeek(_ day: Date) -> Double {
        return SingleConsume.fetchConsumeRecordInThisWeek(day).reduce(0.0, {
            $0 + $1.money!.doubleValue
        })
    }
    
    class func fetchExpensesInThisMonth(_ day: Date) -> Double {
        return SingleConsume.fetchConsumeRecordInThisMonth(day).reduce(0.0, {
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
    fileprivate static func fetchCustomWithRangeDate(_ dateBegin: Date, dateEnd: Date) ->NSFetchedResultsController<NSFetchRequestResult> {
        let predicate = self.createPredicateWithRangeDate(dateBegin, dateEnd: dateEnd)
        return SingleConsume.mr_fetchAllGrouped(by: "category", with: predicate, sortedBy: "category,money", ascending: true)
    }
    
    /**
     查询一段时间内的 消费记录，并按照时间顺序排列
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 一段时间内的 消费记录
     */
    fileprivate static func fetchCustomWithRangeDate(_ dateBegin: Date, dateEnd: Date) ->[SingleConsume] {
        let predicate = self.createPredicateWithRangeDate(dateBegin, dateEnd: dateEnd)
        
        return SingleConsume.mr_findAllSorted(by: "time", ascending: true, with: predicate) as! [SingleConsume]
    }
    
    /**
     按时间段创建一个正则表达式
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 正则表达式
     */
    fileprivate static func createPredicateWithRangeDate(_ dateBegin :Date, dateEnd: Date) -> NSPredicate {
        return NSPredicate(format: "time >= %@ AND time <= %@", dateBegin as CVarArg, dateEnd as CVarArg)
    }
}
