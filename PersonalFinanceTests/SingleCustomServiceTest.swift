//
//  SingleCustomServiceTest.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/28.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import XCTest
import CoreData
@testable import PersonalFinance

class SingleCustomServiceTest: XCTestCase {
    
    var coreDataStack: CoreDataTest!
    var singleCustomService: SingleCustomService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = CoreDataTest()
        singleCustomService = SingleCustomService()
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
    
//    func testAddNewSingleCustom() {
//        expectationForNotification(NSManagedObjectContextDidSaveNotification, object: self.coreDataStack.managedObjectContext) { (notification: NSNotification!) -> Bool in
//            return true
//        }
//        
//        singleCustomService.addNewSingleCustom(2, photo: NSData(), comment: "1234", money: 3, time: NSDate())
//        
//        waitForExpectationsWithTimeout(2) { (error: NSError?) -> Void in
//            XCTAssertNil(error, "save did not occur")
//        }
//        
//    }
    
}
