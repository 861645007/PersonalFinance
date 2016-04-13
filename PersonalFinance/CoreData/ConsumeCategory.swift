//
//  ConsumeCategory.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/11.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class ConsumeCategory: NSObject {
    var id: Int32
    var name: String?
    var iconData: NSData?
    
    init(id: Int32, name: String, icon: NSData) {
        self.id = id
        self.name = name
        self.iconData = icon
    }
}
