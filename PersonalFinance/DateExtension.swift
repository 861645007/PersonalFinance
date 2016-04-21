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
    func isThisDay(date: NSDate) ->Bool {
        if date.dayBegin() < self && self < date.dayEnd() {
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
        if date.monthBegin() < self && self < date.monthEnd() {
            return true
        }else {
            return false
        }
    }
    
    /**
     改变时间至 当前时区的时间
     
     - returns: 返回一个当前时间的时间
     */
    func tolocalTime() -> NSDate {
        let tz = NSTimeZone.localTimeZone()
        let seconds: NSInteger = tz.secondsFromGMTForDate(self)
        return NSDate(timeInterval: Double(seconds), sinceDate: self)
    }
}
