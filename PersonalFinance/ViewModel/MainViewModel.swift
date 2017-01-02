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
     配置进度调的百分比
     
     - returns: 进度条的百分比
     */
    func configureProgressBarPercent() -> CGFloat {
        return self.baseInfo.monthBudget() == 0.0 ? 0.0 : CGFloat(self.baseInfo.monthExpense() / self.baseInfo.monthBudget()) * 100
    }
    
    func gainProgressColor(_ value: CGFloat) -> UIColor {
        if(value >= 35 && value < 70) {
            return UIColor.green
        }else if(value >= 70) {
            return UIColor.red
        }else {
            return UIColor(red:0.317, green:0.662, blue:1, alpha:1)
        }
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
    func monthOrWeekConsumesVM(_ state: MonthOrWeekVCState) -> MonthConsumeViewModel {
        return MonthConsumeViewModel(state: state, today: Date())
    }
    
    
    func newDetailConsumeVM() -> AddNewCustomViewModel {
        return AddNewCustomViewModel(state: ConsumeOperationStatus.editConsumeDetail, consume: SingleConsume.fetchLastConsumeRecord())
    }
}
