//
//  SingleCustomService.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData

private let sharedInstance = SingleCustomService()

class SingleCustomService {
    
    let managedObjectConext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
    // 设置 单例
    class var sharedSingleCustomService: SingleCustomService {
        return sharedInstance
    }
    
    init() {
        coreDataStack = CoreDataStack()
        managedObjectConext = coreDataStack.managedObjectContext
    }
    
    // MARK: - 新增消费记录
    func addNewSingleCustom(category: Int32, photo: NSData, comment: String, money: Double, time: NSDate) {
        let singleCustom: SingleCustom = NSEntityDescription.insertNewObjectForEntityForName("SingleCustom", inManagedObjectContext: self.managedObjectConext) as! SingleCustom
        
        singleCustom.category = NSNumber(int: category)
        singleCustom.photo    = photo
        singleCustom.comment  = comment
        singleCustom.money    = NSNumber(double: money)
        singleCustom.time     = time
        
        self.coreDataStack.saveContext()
    }
        
    // MARK: - 查询消费记录
    /**
    按年查询 一年的消费记录
    
    - parameter date: 一年中的任意日期
    
    - returns: 一年的消费记录
    */
    func fetchConsumeWithYearTrendChart(date: NSDate) ->[SingleCustom] {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    /**
     按月查询 一个月的消费记录
     
     - parameter date: 一个月中的任意日期
     
     - returns: 一个月的消费记录
     */
    func fetchConsumeWithMonthTrendChart(date: NSDate) -> [SingleCustom] {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    
    /**
    获取一个月的 环形图 的数据(按 Category 组分类)
    
    - returns: 一个 NSFetchedResultsController 的实例数据
    */
    func fetchConsumeWithPieChart(date: NSDate) ->NSFetchedResultsController {
        let predicate = self.createPredicateWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
        return self.fetchConsumeWithFetchedResult(predicate, sectionName: "category", cacheName: "CategoryCache")
    }
    
    
    // MARK: 消费列表使用的查询数据
    
    /**
    查询今天的所有消费记录
    
    - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
    */
    func fetchConsumeRecordWithToday() ->[SingleCustom] {
        return self.fetchCustomWithRangeDate(NSDate().dayBegin(), dateEnd: NSDate().dayEnd())
    }
    
    /**
     查询当月的所有消费记录

     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    func fetchConsumeRecordWithCurrentMonth() ->[SingleCustom] {
        return self.fetchCustomWithRangeDate(NSDate().monthBegin(), dateEnd: NSDate())
    }
    
    
    // MARK: - 私有函数
    
    /**
     按时间段创建一个正则表达式
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 正则表达式
     */
    private func createPredicateWithRangeDate(dateBegin :NSDate, dateEnd: NSDate) -> NSPredicate {
        return NSPredicate(format: "time >= %@ AND time <= %@", dateBegin, dateEnd)
    }
    
    /**
     查询一段时间内的 消费记录，并按照时间顺序排列，Category进行分组
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 一段时间内的 消费记录
     */
    private func fetchCustomWithRangeDate(dateBegin: NSDate, dateEnd: NSDate) ->[SingleCustom] {
        let predicate = self.createPredicateWithRangeDate(dateBegin, dateEnd: dateEnd)
        let fetchRequest = self.gainFetchRequest(predicate)
        return self.executeFetchRequest(fetchRequest)
    }
    
    // 获取一个 NSFetchRequest 实例
    private func gainFetchRequest(predicate: NSPredicate) ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SingleCustom")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "time", ascending: true)]
        
        return fetchRequest
    }
    
    
    // 用 managedObjectConext 做查询
    private func executeFetchRequest(fetchRequest: NSFetchRequest) ->[SingleCustom] {
        do {
            let result = try self.managedObjectConext.executeFetchRequest(fetchRequest) as! [SingleCustom]
            
            return result
        }catch let error as NSError {
            print("查询数据错误: \(error.userInfo)")
            abort()
        }
    }

    /**
     用 NSFetchedResultsController 方式获取
     
     - parameter predicate:   正则白哦大事
     - parameter sectionName: 分组名
     - parameter cacheName:   缓存名称
     
     - returns: 返回一个 NSFetchedResultsController 的实例
     */
    private func fetchConsumeWithFetchedResult(predicate: NSPredicate, sectionName: String, cacheName: String) ->NSFetchedResultsController {
        let fetchRequest = self.gainFetchRequest(predicate)
        
        let fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectConext, sectionNameKeyPath: sectionName, cacheName: cacheName)
        
        do {
            try fetchedResult.performFetch()
        }catch let error as NSError {
            print("查询数据错误: \(error.userInfo)")
            abort()
        }
        
        return fetchedResult
    }
    
    // MARK: - 修改消费记录
    func modifyCustomRecord(newSingleCustom: SingleCustom) {
        let fetchRequest = NSFetchRequest(entityName: "SingleCustom")
        
        fetchRequest.predicate = NSPredicate(format: "id == %@", newSingleCustom.id!)
        
        do {
            let singleCustom = (try self.managedObjectConext.executeFetchRequest(fetchRequest) as! [SingleCustom]).first!
            singleCustom.category = newSingleCustom.id
            singleCustom.photo    = newSingleCustom.photo
            singleCustom.comment  = newSingleCustom.comment
            singleCustom.money    = newSingleCustom.money
            singleCustom.time     = newSingleCustom.time
            
            self.coreDataStack.saveContext()
        }catch let error as NSError {
            print("error \(error.userInfo)")
        }
    }
    
    
    // MARK: - 删除消费记录
    
}



