//
//  AddNewCustomViewModel.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/2.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation

enum CustomOperationStatus {
    case AddNewCustom
    case LookCustomDetail
    case EditCustomDetail
}

class AddNewCustomViewModel: NSObject {
    
    
    var categoryService: CategoryService!
    var singleConsumeService: SingleCustomService!
    var addNewConsumeVC: AddNewCustomViewController!
    var baseInfo: BaseInfo!
    
    var consumeTypeArr: [ConsumeCategory]?
    
    let dealMoneyFormat = DealMoneyFormat()
    
    override init() {
        super.init()
        
        categoryService = CategoryService.sharedCategoryService
        singleConsumeService = SingleCustomService.sharedSingleCustomService
        baseInfo = BaseInfo.sharedBaseInfo
    }    
 
    
    /**
     获取 所有的 Consume-Category
     */
    func gainAllConsumeType() {
        consumeTypeArr = []
        
        // 判断表里是否有数据，没有就先存入
        if categoryService.gainCategoryCount() == 0 {
            self.initializeConsumeType()
        }
        
        // 获取数据，并转换为 常规 数据类型（非Core Data中的存储类型）
        let consumeList = categoryService.fetchAllCustomType()
        
        for category: Category in consumeList {
            let consumeType = ConsumeCategory(id: (category.id?.intValue)!, name: category.name!, icon: category.iconData!)
            consumeTypeArr?.append(consumeType)
        }
        consumeTypeArr?.append(ConsumeCategory(id: 10000, name: "新增", icon: UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)!))
        
    }
    
    
    func gainCategoryWithCusOther() ->ConsumeCategory? {
        for category: ConsumeCategory in consumeTypeArr! {
            if category.name == "一般" {
                return category
            }
        }
        
        return nil
    }
    
    
    /**
     获取今日时间
     
     - returns: 返回今日时间（形如：xx月xx日）
     */
    func gainToday() -> String {
        let today = NSDate()
        return "\(today.month)月\(today.day)日"
    }
    
    /**
     新增一条消费记录
     
     - parameter category: 消费的类别
     - parameter photo:    消费图片（可无）
     - parameter comment:  消费备注（可无）
     - parameter money:    消费金额
     - parameter time:     消费时间
     */
    func saveNewConsume(category: Int32, photo: NSData, comment: String, money: Double, time: NSDate)  {
        // 在数据库里新增一条记录
        singleConsumeService.addNewSingleCustom(category, photo: photo, comment: comment, money: money, time: time)
        
        // 修改基础各类数据：每 月/日 消费、最新消费
        baseInfo.addMonthExpense(NSNumber(double: money))
        baseInfo.addDayExpense(NSNumber(double: money))
        baseInfo.saveNewExpense(NSNumber(double: money))
    }
    
    
    // MARK: - 处理金额数据格式
    
    /**
     处理金额数据格式：使之保持一个 ￥0.00 的格式
     
     - parameter text: 待处理的数字文本
     
     - returns: 处理好的数字文本
     */
    func dealWithDecimalMoney(text: String) -> String {
        return dealMoneyFormat.dealWithDecimalMoney(text)
    }
    
    
    
    
    // MARK: - 私有函数
    
    /**
     向 CoreData 里存入 预存入的数据
     */
    private func initializeConsumeType() {
        // 获取预备文件里的数据
        let plistDic = OperatePlist().gainDataWithFileName("Consume-Type")
        
        // 循环插入数据
        for (iconName, name) in plistDic {
            categoryService.insertNewCustomCategory(name, iconData: UIImagePNGRepresentation(UIImage(named: iconName)!)!)
        }
    }
    
}

