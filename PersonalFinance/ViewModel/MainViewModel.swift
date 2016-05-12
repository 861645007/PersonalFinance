//
//  MainViewModel.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/31.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class MainViewModel: NSObject {
    let baseInfo: BaseInfo = BaseInfo.sharedBaseInfo
    
    override init() {
        super.init()
    }
    
    /**
     配置波浪小球的百分比
     
     - returns: 波浪小球的百分比
     */
    func configureProgressBarPercent() -> CGFloat {
        return self.baseInfo.monthBudget() == 0.0 ? 0.0 : CGFloat(self.baseInfo.monthExpense() / self.baseInfo.monthBudget())
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
    
    func gainWeekExpense() ->Double {
        return baseInfo.weekExpense()
    }
    
    
    
    // MARK: - 跳转
    func monthOrWeekConsumesVM(state: MonthOrWeekVCState) -> MonthConsumeViewModel {
        return MonthConsumeViewModel(state: state, today: NSDate())
    }
}
