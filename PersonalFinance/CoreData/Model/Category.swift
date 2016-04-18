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
    class func insertNewConsumeCategory(name: String, iconData: NSData) {
        let id = Category.gainCategoryCount()  + 1
        let category: Category = Category.MR_createEntity()!
        
        category.id = NSNumber(int: id)
        category.name = name
        category.iconData = iconData
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    /**
     向 CoreData 里存入 预存入数据
     */
    class func initializeConsumeCategory() {
        // 获取预备文件里的数据
        let plistDic = OperatePlist().gainDataWithFileName("Consume-Type")
        
        // 循环插入数据
        for (iconName, name) in plistDic {
            Category.insertNewConsumeCategory(name, iconData: UIImagePNGRepresentation(UIImage(named: iconName)!)!)
        }
    }
    
    // MARK: - 查询
    /*
    获取 Category 表中的所有数据
    
    - returns: 返回 Category 表中的所有数据
    */
    class func fetchAllConsumeCategory() ->[Category] {
        return Category.MR_findAllSortedBy("id", ascending: true) as! [Category]
    }
    
    
    class func fetchConsumeCategoryWithId(id: NSNumber) -> Category? {
        return Category.MR_findFirstByAttribute("id", withValue: id)
    }
    
    // 修改
    func modifyConsumeCategory(id: NSNumber, name: String) {
        let category = Category.fetchConsumeCategoryWithId(id)
        
        category?.name = name
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
    }
    
    
    // 私有方法
    private static func gainCategoryCount() ->Int32 {
        return Category.MR_numberOfEntities().intValue
    }
}
