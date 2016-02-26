//
//  CategoryServiceTest.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/10.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import XCTest
import CoreData
@testable import PersonalFinance

class CategoryServiceTest: XCTestCase {

    var coreDataStack: CoreDataTest!
    var categoryService: CategoryService!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        coreDataStack = CoreDataTest()
        categoryService = CategoryService()
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
    
    func testGainCategoryCount() {
        let count = categoryService.gainCategoryCount()
        
        XCTAssertEqual(count, 0, "Category 已经有数据了")
    }
    
    func testModidyCustomType() {
        categoryService.insertNewCustomCategory("学习", iconData: UIImagePNGRepresentation(UIImage(named: "Cus-Study")!)!)
        
        let studyType = categoryService.gainCustomType(NSPredicate(format: "id == %@", 1)).first
        XCTAssertEqual(studyType?.name, "学习", "查询的结果应该是第一条数据")
        
        categoryService.modifyCustomType(1, newName: "学习费用")
        
        let studyType1 = categoryService.gainCustomType(NSPredicate(format: "id == %@", 1)).first
        XCTAssertEqual(studyType1?.name, "学习费用", "查询的结果应该是修改后的第一条数据")
        
    }

}
