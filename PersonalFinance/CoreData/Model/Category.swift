//
//  Category.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/17.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData
import MagicalRecord

class Category: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    // MARK: - 插入
    class func insertNewConsumeCategory(_ name: String, iconData: Data, beUsed: Bool) {
        
        let id = Category.gainCategoryCount() + 1
        let category: Category = Category.MR_createEntity()!
        
        category.id = NSNumber(value: id as Int32)
        category.name = name
        category.iconData = iconData
        category.beUsed = NSNumber(value: beUsed as Bool)
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    /**
     向 CoreData 里存入 预存入数据
     */
    class func initializeConsumeCategory() {
        // 获取 Consume-Type 预备文件里的数据
        let consumePlistDic = OperatePlist().gainDataWithFileName("Consume-Type")
        // 循环插入数据
        for (iconName, name) in consumePlistDic {
            Category.insertNewConsumeCategory(name, iconData: UIImagePNGRepresentation(UIImage(named: iconName)!)!, beUsed: true)
        }
        
        // 获取 NewConsume-Type 预备文件里的数据
        let newConsumePlistDic = OperatePlist().gainDataWithFileName("NewConsume-Type")        
        // 循环插入数据
        for iconName in newConsumePlistDic.keys {
            Category.insertNewConsumeCategory("", iconData: UIImagePNGRepresentation(UIImage(named: iconName)!)!, beUsed: false)
        }
    }
    
    
    
    // MARK: - 查询
    class func fetchAllConsumeCategoryWithoutUsed() ->[Category] {
        return Category.MR_findAllSortedBy("id", ascending: true, withPredicate: self.createPredicateWithBeUsed(false)) as! [Category]
    }
    
    /*
    获取 Category 表中所有被使用了的数据
    
    - returns: 返回 Category 表中的所有数据
    */
    class func fetchAllConsumeCategoryWithUsed() ->[Category] {
        return Category.MR_findAllSortedBy("id", ascending: true, withPredicate: self.createPredicateWithBeUsed(true)) as! [Category]
    }
    
    
    class func fetchConsumeCategoryWithId(_ id: NSNumber) -> Category? {
        return Category.MR_findFirstByAttribute("id", withValue: id)
    }
    
    // 修改
    func modifyConsumeCategory(_ id: NSNumber, name: String) {
        let category = Category.fetchConsumeCategoryWithId(id)
        
        category?.name = name
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    // MARK: - 删除
    class func removeAllCategoryForICloud() {
        for category in Category.MR_findAll()! {
            category.MR_deleteEntity()
        }
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    
    // 私有方法
    fileprivate static func gainCategoryCount() ->Int32 {
        return Category.MR_numberOfEntities().intValue
    }
    
    fileprivate static func createPredicateWithBeUsed(_ beUsed: Bool) -> NSPredicate {
        return NSPredicate(format: "beUsed == %@", NSNumber(value: beUsed as Bool))
    }
}
