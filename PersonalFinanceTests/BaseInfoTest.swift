//
//  BaseInfoTest.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import XCTest
@testable import PersonalFinance

class BaseInfoTest: XCTestCase {
    
    var baseInfo: BaseInfo!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        baseInfo = BaseInfo.sharedBaseInfo
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGainMonthbudget() {
        baseInfo.saveMonthBudget(12.0)
        let budget = baseInfo.gainMonthBudget()
        
        XCTAssert(budget == 12.0, "saveMonthBudget Can't Unit Test")
        
        baseInfo.saveMonthBudget(18.0)
        
        let budget1 = baseInfo.gainMonthBudget()
        
        XCTAssert(budget1 == 18.0, "saveMonthBudget Can't Unit Test")
    }
    
    func testGainMonthExpense() {
        baseInfo.saveMonthExpense(12.0)
        let monthExpense = baseInfo.gainMonthExpense()
        
        XCTAssert(monthExpense == 12.0, "saveMonthExpense Can't Unit Test")
        
        baseInfo.saveMonthExpense(18.0)
        
        let monthExpense2 = baseInfo.gainMonthExpense()
        
        XCTAssert(monthExpense2 == 18.0, "saveMonthExpense Can't Unit Test")
    }
    
    func testGainDayExpense() {
        baseInfo.saveDayExpense(12.0)
        let dayExpense = baseInfo.gainDayExpense()
        
        XCTAssert(dayExpense == 12.0, "saveDayExpense Can't Unit Test")
        
        baseInfo.saveDayExpense(18.0)
        
        let dayExpense2 = baseInfo.gainDayExpense()
        
        XCTAssert(dayExpense2 == 18.0, "saveDayExpense Can't Unit Test")
    }
    
    func testGainNewExpense() {
        baseInfo.saveNewExpense(13.0)
        let newExpense = baseInfo.gainNewExpense()
        
        XCTAssert(newExpense == 13.0, "saveNewExpense Can't Unit Test")
        
        baseInfo.saveNewExpense(18.0)
        
        let newExpense2 = baseInfo.gainNewExpense()
        
        XCTAssert(newExpense2 == 18.0, "saveNewExpense Can't Unit Test")
    }
}
