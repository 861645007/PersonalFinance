//
//  CoreDataStack.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    
    let modelName = "PersonalFinance"
    
    lazy var applicationDocumentsDictionary: NSURL = {
        let urls = NSFileManager.defaultManager().URLsForDirectory( .DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.count - 1]
    }()
    
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelUrl = NSBundle.mainBundle().URLForResource(self.modelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOfURL: modelUrl)!
    }()
    
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        let coordinator: NSPersistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        
        let url = self.applicationDocumentsDictionary.URLByAppendingPathComponent("\(self.modelName).sqlite")
        
        do {
            let options = [NSMigratePersistentStoresAutomaticallyOption : true];
            try coordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: url, options: options)
        }catch {
            print("error add persistent Store Coordinator")
        }
        
        return coordinator
    }()
    
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // 创建一个主线程的并发的 NSManagedObjectContext
        let managedObejctContext = NSManagedObjectContext(concurrencyType: .MainQueueConcurrencyType)
        // 设置它的 persistentStoreCoordinator 属性为我们之前创建的 persistentStoreCoordinator
        managedObejctContext.persistentStoreCoordinator = self.persistentStoreCoordinator
        
        return managedObejctContext
    }()
    
    func saveContext() {
        if managedObjectContext.hasChanges {
            do {
                try managedObjectContext.save()
            }catch {
                print("保存失败")
                abort()
            }
        }
    }    
}