//
//  FinanceOfCategory.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/12.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class FinanceOfCategory: NSObject {
   
    var iconData: NSData?
    var categoryName: String = ""
    var categoryRatio: Double = 0.0
    var categoryMoney: Double = 0
    
    
    init(iconData: NSData, name: String, ratio: Double, money: Double) {
        self.iconData = iconData
        self.categoryName = name
        self.categoryRatio = ratio
        self.categoryMoney = money
    }
}
