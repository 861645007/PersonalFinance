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
    
    // 配置 金额
    var hasDecimalPoint = false
    var decimalBeforePoint: String = ""
    var decimalAfterPoint: String = ""
    
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
        
        if  text.characters.count >= 12 {
            var newText: String = text
            newText.removeAtIndex(newText.endIndex.advancedBy(-1))
            return newText
        }
        
        let lastChar = text.substringFromIndex(text.endIndex.advancedBy(-1))
        let decimalLater = text.substringFromIndex((text.rangeOfString(".")?.endIndex)!)
        
        if decimalLater.characters.count == 1 {
            // 说明是删除了数据
            
            if self.hasDecimalPoint {
                // 删除小数点前的数
                let decimalAfterPointLength = self.decimalAfterPoint.characters.count
                
                if decimalAfterPointLength == 2 {
                    self.decimalAfterPoint.removeAtIndex(self.decimalAfterPoint.endIndex.advancedBy(-1))
                    return "￥\(self.decimalBeforePoint).\(self.decimalAfterPoint)0"
                }else if decimalAfterPointLength == 1 {
                    self.decimalAfterPoint.removeAtIndex(self.decimalAfterPoint.endIndex.advancedBy(-1))
                    self.hasDecimalPoint = false
                    return "￥\(self.decimalBeforePoint).00"
                }
            }else {
                // 删除小数点后的数
                let decimalBeforePointLength = self.decimalBeforePoint.characters.count
                
                // 判断数是否已经被删完了
                if decimalBeforePointLength == 1 || decimalBeforePointLength == 0 {
                    self.decimalBeforePoint = ""
                    return "￥0.00"
                }else {
                    self.decimalBeforePoint.removeAtIndex(self.decimalBeforePoint.endIndex.advancedBy(-1))
                    return "￥\(self.decimalBeforePoint).00"
                }
            }
        }else if decimalLater.characters.count == 3 {
            // 说明是新增了数据
            if lastChar == "." {
                self.hasDecimalPoint = true
                if self.decimalBeforePoint == "" {
                    self.decimalBeforePoint = "0"
                }
                return "￥\(self.decimalBeforePoint).00"
            }else {
                if self.hasDecimalPoint {
                    if self.decimalAfterPoint.characters.count < 2 {
                        self.decimalAfterPoint += lastChar
                        
                        if self.decimalAfterPoint.characters.count == 1 {
                            return "￥\(self.decimalBeforePoint).\(self.decimalAfterPoint)0"
                        }
                    }
                    return "￥\(self.decimalBeforePoint).\(self.decimalAfterPoint)"
                }else {
                    self.decimalBeforePoint += lastChar
                    return "￥\(self.decimalBeforePoint).00"
                }
            }
        }
        return text
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

