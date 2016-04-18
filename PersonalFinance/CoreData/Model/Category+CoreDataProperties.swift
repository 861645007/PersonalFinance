//
//  Category+CoreDataProperties.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/18.
//  Copyright © 2016年 王焕强. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Category {

    @NSManaged var iconData: NSData?
    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var beUsed: NSNumber?
    @NSManaged var singleConsume: NSOrderedSet?

}
