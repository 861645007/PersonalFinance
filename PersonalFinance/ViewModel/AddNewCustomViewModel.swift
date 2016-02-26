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
    
    var consumeTypeArr: [Category]?
    var categoryService: CategoryService!
    
    
    var hasDecimalPoint = false
    var decimalBeforePoint: String = ""
    var decimalAfterPoint: String = ""
    
    override init() {
        super.init()
        
        categoryService = CategoryService.sharedCategoryService
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
        
        consumeTypeArr = categoryService.fetchAllCustomType()
//        consumeTypeArr?.append(self.categoryService.createAddType())
    }
    
    
    
    
    
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
                let decimalBeforePointLength = self.decimalBeforePoint.characters.count
                if decimalBeforePointLength == 1 {
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

