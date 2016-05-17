//
//  DealMoneyFormat.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/16.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class DealMoneyFormat: NSObject {
    // 配置 金额
    var hasDecimalPoint = false
    var decimalBeforePoint: String = ""
    var decimalAfterPoint: String = ""
    
    override init() {
        super.init()
    }
    
    // MARK: - 处理金额数据格式
    
    /**
     处理金额数据格式：使之保持一个 ￥0.00 的格式
     
     - parameter text: 待处理的数字文本
     
     - returns: 处理好的数字文本
     */
    func dealWithDecimalMoney(text: String) -> String {
        
        let money: String = text.substringFromIndex(text.startIndex.advancedBy(1)).stringByReplacingOccurrencesOfString(",", withString: "", options: [], range: nil)
        
        if  money.characters.count >= 11 || Double(money) == 0.0 {
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

}
