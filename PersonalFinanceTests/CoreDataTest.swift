//
//  CoreDataTest.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/28.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import CoreData
@testable import PersonalFinance

class CoreDataTest: CoreDataStack {
    
    override init() {
        super.init()
        self.persistentStoreCoordinator = {
            let psc = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel) 
            
            do {
                try psc.addPersistentStoreWithType(NSInMemoryStoreType, configuration: nil, URL: nil, options: nil)
            }catch {
                fatalError()
            }
            return psc
        }()
        
    }
}
