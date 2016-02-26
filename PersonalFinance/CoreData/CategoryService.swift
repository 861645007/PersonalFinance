//
//  CategoryService.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/10.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData

private let sharedInstance = CategoryService()

class CategoryService {
    let managedObjectConext: NSManagedObjectContext!
    let coreDataStack: CoreDataStack!
    
    // 设置 单例
    class var sharedCategoryService: CategoryService {
        return sharedInstance
    }
    
    init() {
        coreDataStack = CoreDataStack()
        managedObjectConext = coreDataStack.managedObjectContext
    }
    
    
    // MARK: - 新增消费类型
    func insertNewCustomCategory(name: String, iconData: NSData) {
        let id = self.gainCategoryCount() + 1
        let category: Category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: self.managedObjectConext) as! Category

        category.id = NSNumber(int: id)
        category.name = name
        category.iconData = iconData
        
        self.coreDataStack.saveContext()
    }
    
    func createAddType() -> Category {
        let addCategory: Category = NSEntityDescription.insertNewObjectForEntityForName("Category", inManagedObjectContext: self.managedObjectConext) as! Category
        addCategory.name = "新增"
        addCategory.iconData = UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)
        
        return addCategory
    }
    
    // MARK: - 查询
    /**
    获取 Category 表中的所有数据
    
    - returns: 返回 Category 表中的所有数据
    */
    func fetchAllCustomType() ->[Category] {
        return self.gainCustomType(nil)
    }
    
    // 查询 Category 表
    func gainCustomType(predicate: NSPredicate?) ->[Category] {
        let fetchRequest: NSFetchRequest = NSFetchRequest(entityName: "Category")
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
        return self.executeFetchRequest(fetchRequest)
    }
    
    // 用 managedObjectConext 做查询
    private func executeFetchRequest(fetchRequest: NSFetchRequest) ->[Category] {
        do {
            let result = try self.managedObjectConext.executeFetchRequest(fetchRequest) as! [Category]
            
            return result
        }catch let error as NSError {
            print("查询数据错误: \(error.userInfo)")
            abort()
        }
    }
        
    
    /**
     查询 消费类型数据库表 里的数据量
     
     - returns: custom-type 的数目
     */
    func gainCategoryCount() ->Int32 {
        let fetchRequest = NSFetchRequest(entityName: "Category")
        
        return Int32(self.managedObjectConext.countForFetchRequest(fetchRequest, error: nil))
    }
    
    
    // 修改
    func modifyCustomType(id: NSNumber, newName: String) {
        let predicate: NSPredicate = NSPredicate(format: "id == %@", id)
        let category = self.gainCustomType(predicate).first
        
        category?.name = newName
        
        self.coreDataStack.saveContext()
    }
    
    
    
}