//
//  SingleConsume+CoreDataProperties.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/17.
//  Copyright © 2016年 王焕强. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SingleConsume {

    @NSManaged var category: NSNumber?
    @NSManaged var comment: String?
    @NSManaged var id: NSNumber?
    @NSManaged var money: NSNumber?
    @NSManaged var photo: Data?
    @NSManaged var time: Date?
    @NSManaged var consumeCategory: Category?

}
