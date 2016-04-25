//
//  MainViewModel.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/31.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    var baseInfo: BaseInfo!
    
    override init() {
        super.init()
        
        baseInfo = BaseInfo.sharedBaseInfo
    }
    
    /**
     配置波浪小球的百分比
     
     - returns: 波浪小球的百分比
     */
    func configureWavePercent() -> CGFloat {
        if self.gainMonthBudget() == 0.0 {
            return 0.0
        }
        
        return CGFloat(self.gainMonthExpense() / self.gainMonthBudget())
    }
    
    func gainMonthExpense() ->Double {
        return baseInfo.monthExpense()
    }

    func gainMonthBudget() ->Double {
        return baseInfo.monthBudget()
    }
    
    func gainDayExpense() ->Double {
        return baseInfo.dayExpense()
    }
    
    func gainNewExpense() ->Double {
        return baseInfo.newExpense()
    }
}
