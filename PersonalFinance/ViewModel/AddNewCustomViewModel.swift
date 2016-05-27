//
//  AddNewCustomViewModel.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/2.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation

enum ConsumeOperationStatus {
    case AddNewConsume
    case EditConsumeDetail
}

class AddNewCustomViewModel: NSObject {
    
    let baseInfo: BaseInfo = BaseInfo.sharedBaseInfo
    
    var consumeTypeArr: [ConsumeCategory]?
    
    let dealMoneyFormat = DealMoneyFormat()
    
    let currentState: ConsumeOperationStatus!
    let currentConsume: SingleConsume?
 
    init(state: ConsumeOperationStatus? = .AddNewConsume, consume: SingleConsume? = nil) {
        self.currentState = state
        self.currentConsume = consume
        
        super.init()
    }
    
    // MARK: - 设置初始化数据
    func setDefaultMoney() -> String {
        return (currentState == .AddNewConsume) ? "￥0.00" : "￥\(self.currentConsume!.money!.doubleValue.convertToStrWithTwoFractionDigits())"
    }
    
    // 配置默认消费类型
    func setDefaultCategory() -> ConsumeCategory? {
        return (currentState == .AddNewConsume) ? self.gainCategoryWithCusOther() : ConsumeCategory(id: (currentConsume?.consumeCategory!.id!.intValue)!, name: (currentConsume?.consumeCategory!.name)!, icon: currentConsume!.consumeCategory!.iconData!)
    }
    
    func setDefaultTime() -> String {
        return (currentState == .AddNewConsume) ? self.gainToday() : "\(currentConsume!.time!.month)月\(currentConsume!.time!.day)日"
    }
    
    func setDefaultComment() -> String {
        return (currentState == .AddNewConsume) ? "" : (currentConsume?.comment)!
    }
    
    /**
     获取 所有的 Consume-Category
     */
    func gainAllConsumeType() {
        consumeTypeArr = Category.fetchAllConsumeCategoryWithUsed().map { (category: Category) in
            ConsumeCategory(id: (category.id?.intValue)!, name: category.name!, icon: category.iconData!)
        }
        
        consumeTypeArr?.append(ConsumeCategory(id: 10000, name: "新增", icon: UIImagePNGRepresentation(UIImage(named: "AddCustomType")!)!))
    }
    
    // MARK: - 保存
    func saveConsumeInfo(category: Int32, photo: NSData, comment: String, money: Double, time: NSDate) {
        if currentState == .EditConsumeDetail {
            self.modifyConsume((currentConsume?.id?.intValue)!, category: category, photo: photo, comment: comment, money: money, time: time)
        }else {
            self.saveNewConsume(category, photo: photo, comment: comment, money: money, time: time)
        }
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
     新增一条消费记录
     
     - parameter category: 消费的类别
     - parameter photo:    消费图片（可无）
     - parameter comment:  消费备注（可无）
     - parameter money:    消费金额
     - parameter time:     消费时间
     */
    private func saveNewConsume(category: Int32, photo: NSData, comment: String, money: Double, time: NSDate)  {
        // 在数据库里新增一条记录
        SingleConsume.addNewSingleCustom(category, photo: photo, comment: comment, money: money, time: time)
        
        ShareWithGroupOperation.sharedGroupOperation.saveNewDayExpense(baseInfo.dayExpense())
    }
    
    // 修改一条记录
    /**
     新增一条消费记录
     
     - parameter category: 消费的类别
     - parameter photo:    消费图片（可无）
     - parameter comment:  消费备注（可无）
     - parameter money:    消费金额
     - parameter time:     消费时间
     */
    private func modifyConsume(id: Int32, category: Int32, photo: NSData, comment: String, money: Double, time: NSDate)  {
        // 在数据库里修改一条记录
        SingleConsume.modifySingleCustom(id, category: category, photo: photo, comment: comment, money: money, time: time)
    }
    
    /**
     获取今日时间
     
     - returns: 返回今日时间（形如：xx月xx日）
     */
    private func gainToday() -> String {
        let today = NSDate()
        return "\(today.month)月\(today.day)日"
    }
    
    private func gainCategoryWithCusOther() ->ConsumeCategory? {
        for category: ConsumeCategory in consumeTypeArr! {
            if category.name == "一般" {
                return category
            }
        }
        return nil
    }
    
}

