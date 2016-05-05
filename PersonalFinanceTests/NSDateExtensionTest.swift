//
//  NSDateExtensionTest.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/29.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import XCTest
import SwiftDate
@testable import PersonalFinance

class NSDateExtensionTest: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
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
    
    
    func testFirstDayWithNextWeek() {
        let nextWeek = NSDate().firstDayWithNextWeek(8)
        let currentWeek = nextWeek - 7.days
        
        XCTAssert(nextWeek.month == 5 && nextWeek.day == 1, "Good")
        XCTAssert(currentWeek.month == 4 && currentWeek.day == 24, "\(currentWeek)")
    }
    
}
