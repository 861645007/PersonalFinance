//
//  SingleCustomService.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData

class SingleCustomService {
    
    let managedObjectConext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
    init() {
        coreDataStack = CoreDataStack()
        managedObjectConext = coreDataStack.managedObjectContext
    }
    
    // MARK: - 新增消费记录
    func addNewSingleCustom(category: Int32, photo: NSData, comment: String, money: Int32, time: NSDate) {
        let singleCustom: SingleCustom = NSEntityDescription.insertNewObjectForEntityForName("SingleCustom", inManagedObjectContext: self.managedObjectConext) as! SingleCustom
        
        singleCustom.category = NSNumber(int: category)
        singleCustom.photo    = photo
        singleCustom.comment  = comment
        singleCustom.money    = NSNumber(int: money)
        singleCustom.time     = time
        
        self.coreDataStack.saveContext()
    }
        
    // MARK: - 查询消费记录
    /**
    按年查询 一年的消费记录
    
    - parameter date: 日期
    
    - returns: 一年的消费记录
    */
    func fetchCustomWithTrendChart(date: NSDate) ->[SingleCustom] {
        return self.fetchCustomWithRangeDate(date.yearBegin(), dateEnd: date.yearEnd())
    }
    
    /**
    获取 环形图 的数据
    
    - returns: 一个 SingleCustom 的实例数据
    */
    func fetchCustomForCircularDiagram(date: NSDate) ->[SingleCustom] {
        return self.fetchCustomWithRangeDate(date.monthBegin(), dateEnd: date.monthEnd())
    }
    
    /**
     查询一段时间内的 消费记录，并按照时间顺序排列，Category进行分组
     
     - parameter dateBegin: 开始时间
     - parameter dateEnd:   结束时间
     
     - returns: 一段时间内的 消费记录
     */
    private func fetchCustomWithRangeDate(dateBegin :NSDate, dateEnd: NSDate) ->[SingleCustom] {
        let predicate = NSPredicate(format: "time >= %@ AND time <= %@", dateBegin, dateEnd)
        let fetchRequest = self.gainFetchRequestForChart(predicate, group: ["Category"])
        return self.executeFetchRequest(fetchRequest)
    }
    
    // 获取一个 NSFetchRequest 实例
    private func gainFetchRequestForChart(predicate: NSPredicate, group: [String]) ->NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "SingleCustom")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "Time", ascending: true)]
        // 让查询结果按 组 分类
        fetchRequest.propertiesToGroupBy = group
        
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
    
    // MARK: 消费列表使用的查询数据
    
    /**
    查询今天的所有消费记录
    
    - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
    */
    func fetchCustomRecordWithToday() ->NSFetchedResultsController {
        let today = NSDate()
        let predicate = NSPredicate(format: "time >= %@ AND time <= %@", today.dayBegin(), today.dayEnd())

        return self.fetchCustomWithFetchedResult(predicate, cacheName: "TodayCustom")
    }
    
    /**
     查询当月的所有消费记录

     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    func fetchCustomRecordWithCurrentMonth() ->NSFetchedResultsController {
        let today = NSDate()
        let predicate = NSPredicate(format: "time >= %@ AND time <= %@", today.monthBegin(), today.monthEnd())
        
        return self.fetchCustomWithFetchedResult(predicate, cacheName: "MonthCustom")
    }
    
    
    private func fetchCustomWithFetchedResult(predicate: NSPredicate, cacheName: String) ->NSFetchedResultsController {
        let fetchRequest = NSFetchRequest(entityName: "SingleCustom")
        
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "Time", ascending: true)]
        
        
        let fetchedResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.managedObjectConext, sectionNameKeyPath: "Time", cacheName: cacheName)
        
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



