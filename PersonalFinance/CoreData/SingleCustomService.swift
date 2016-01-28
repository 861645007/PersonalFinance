//
//  SingleCustomService.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData
import Timepiece

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
    查询今天的所有消费记录
    
    - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
    */
    func fetchCustomRecordWithToday() ->NSFetchedResultsController {
        let today = NSDate()
        let todayBegin = today.change(hour: 0, minute: 0, second: 0)
        let todayEnd = todayBegin + 1.day
    
        let predicate = NSPredicate(format: "time >= %@ AND time <= %@", todayBegin, todayEnd)

        return self.fetchCustomWithFetchedResult(predicate, cacheName: "TodayCustom")
    }
    
    /**
     查询当月的所有消费记录
     
     - returns: 返回一个 NSFetchedResultsController 类型，以便 TableView 使用
     */
    func fetchCustomRecordWithCurrentMonth() ->NSFetchedResultsController {
        let today = NSDate()
        let monthBegin = today.change(day: 1, hour: 0, minute: 0, second: 0)
        let monthEnd = NSDate.gainNextMonthWithToday(monthBegin)
        
        let predicate = NSPredicate(format: "time >= %@ AND time <= %@", monthBegin, monthEnd)
        
        return self.fetchCustomWithFetchedResult(predicate, cacheName: "TodayCustom")
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
    
    // MARK: - 删除消费记录
    
}


extension NSDate {
    class func gainNextMonthWithToday(today: NSDate) -> NSDate {
        let comps = NSDateComponents()
        comps.month = 1
        let calender = NSCalendar(identifier: NSCalendarIdentifierGregorian)
        return calender!.dateByAddingComponents(comps, toDate: today, options: .WrapComponents)!
    }
}
