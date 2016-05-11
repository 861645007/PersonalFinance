//
//  DateExtension.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import SwiftDate

extension NSDate {
    func yearBegin() ->NSDate {
        return self.startOf(.Year)
    }
    
    func yearEnd() ->NSDate {
        return self.endOf(.Year)
    }
    
    func monthBegin() ->NSDate {
        return self.startOf(.Month)
    }
    
    func monthEnd() ->NSDate {
        return self.endOf(.Month)
    }
    
    func weekBegin() ->NSDate {
        return self.firstDayWithNextWeek(0) - 7.days
    }
    
    // 把下周的第一天的开始时间作为上一周的结束时间
    func weekEnd() ->NSDate {
        return self.firstDayWithNextWeek(0)
    }
    
    func dayBegin() ->NSDate {
        return self.startOf(.Day)
    }
    
    func dayEnd() ->NSDate {
        return self.endOf(.Day)
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
    
    /**
     获取下月一号的 x 时
     
     - parameter hour: 指定的小时
     
     - returns: 下月一号的 x 时
     */
    func firstDayWithNextMonth(hour: Int) -> NSDate {
        if self.month == 12 {
            return NSDate(year: self.year + 1, month: 1, day: 1, hour: hour)
        }else {
            return NSDate(year: self.year, month:self.month + 1, day: 1, hour: hour)
        }
    }
    
    /**
     获取下个星期第一天的 x 时
     
     - parameter hour: 指定的小时
     
     - returns: 下个星期第一天的 x 时
     */
    func firstDayWithNextWeek(hour: Int) -> NSDate {
        let firstDayOfThisWeek = self.firstDayOfWeek()
        let lastDayOfThisWeek = self.lastDayOfWeek()
        
        if lastDayOfThisWeek < firstDayOfThisWeek {
            // 如果 这个星期的最后一天小于第一天的值，说明跨月了
            if self.month == 12 {
                // 如果这个月是12月，说明跨年了
                return NSDate(year: self.year + 1, month: 1, day: lastDayOfThisWeek! + 1, hour: hour)
            }else {
                return NSDate(year: self.year, month: self.month + 1, day: lastDayOfThisWeek! + 1, hour: hour)
            }
        }else {
            return NSDate(year: self.year, month: self.month, day: lastDayOfThisWeek!, hour: hour) + 1.days
        }
    }
}





















