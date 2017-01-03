//
//  DateExtension.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import SwiftDate

extension Date {
    func yearBegin() ->Date {
        return self.startOf(component: .year)
    }
    
    func yearEnd() ->Date {
        return self.endOf(component: .year)
    }
    
    func monthBegin() ->Date {
        return self.startOf(component: .month)
    }
    
    func monthEnd() ->Date {
        return self.endOf(component: .month)
    }
    
    func weekBegin() ->Date {
        return self.firstDayWithNextWeek(0) - 7.days
    }
    
    // 把下周的第一天的开始时间作为上一周的结束时间
    func weekEnd() ->Date {
        return self.firstDayWithNextWeek(0)
    }
    
    func dayBegin() ->Date {
        return self.startOf(component: .day)
    }
    
    func dayEnd() ->Date {
        return self.endOf(component: .day)
    }
    
    func quarterBegin() -> Date {
        return self.startOf(component: .quarter) - 3.months
    }
    
    func quarterEnd() -> Date {
        return self.startOf(component: .quarter)
    }
    
    func isLaterWithNewTime(_ newTime: Date) ->Bool {
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
    func isThisDay(_ date: Date) ->Bool {
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
    func isInThisMonth(_ date: Date) ->Bool {
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
    func tolocalTime() -> Date {
        let tz = TimeZone.autoupdatingCurrent
        let seconds: NSInteger = tz.secondsFromGMT(for: self)
        return Date(timeInterval: Double(seconds), since: self)
    }
    
    /**
     获取下月一号的 x 时
     
     - parameter hour: 指定的小时
     
     - returns: 下月一号的 x 时
     */
    func firstDayWithNextMonth(_ hour: Int) -> Date {
        return (self + 1.months).startOf(component: .month)
    }
    
    func firstDayOfWeek() -> Date {
        return self.startOf(component: .weekday)
    }
    
    
    func lastDayOfWeek() -> Date {
        return self.endOf(component: .weekday)
    }
    
    /**
     获取下个星期第一天的 x-8 时
     
     - parameter hour: 指定的小时
     
     - returns: 下个星期第一天的 x-8 时
     */
    func firstDayWithNextWeek(_ hour: Int) -> Date {
        return (self + 1.weeks).startOf(component: .weekday)
    }
}





















