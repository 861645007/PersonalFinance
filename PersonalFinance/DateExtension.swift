//
//  DateExtension.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import Timepiece

extension NSDate {
    func yearBegin() ->NSDate {
        return self.beginningOfYear
    }
    
    func yearEnd() ->NSDate {
        return self.endOfYear
    }
    
    func monthBegin() ->NSDate {
        return self.beginningOfMonth
    }
    
    func monthEnd() ->NSDate {
        return self.endOfMonth
    }
    
    func dayBegin() ->NSDate {
        return self.beginningOfDay
    }
    
    func dayEnd() ->NSDate {
        return self.endOfDay
    }
    
    func isLaterWithNewTime(newTime: NSDate) ->Bool {
        if self > newTime {
            return true
        }else {
            return false
        }
    }
    
    /**
     判断是不是在指定的 那一天内
     
     - parameter date: 指定的日期
     
     - returns: 是返回true，不是返回false
     */
    func isInThisDay(date: NSDate) ->Bool {
        if self < date.beginningOfDay && self < date.endOfDay {
            return true
        }else {
            return false
        }
    }
    
    /**
     判断是不是在指定的 那一日期所在月份里
     
     - parameter date: 指定的日期
     
     - returns: 是返回true，不是返回false
     */
    func isInThisMonth(date: NSDate) ->Bool {
        if self < date.beginningOfMonth && self < date.endOfMonth {
            return true
        }else {
            return false
        }
    }
}
