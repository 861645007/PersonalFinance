//
//  SingleCustom+CoreDataProperties.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension SingleCustom {

    @NSManaged var id: NSNumber?
    @NSManaged var category: NSNumber?
    @NSManaged var photo: NSData?
    @NSManaged var comment: String?
    @NSManaged var money: NSNumber?
    @NSManaged var time: NSDate?

}
