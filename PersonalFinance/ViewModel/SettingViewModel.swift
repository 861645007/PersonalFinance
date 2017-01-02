//
//  SettingViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import CoreData

struct SettingModel {
    var imageName: String = ""
    var name: String = ""
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
}

class SettingViewModel: NSObject {

    var settingData: [[SettingModel]] = [[], []]
    
    override init() {
        super.init()
        self.setSettingData()
    }
    
    func setSettingData() {
        settingData = [[], []]
        
        if PasscodeOperation.sharedPasscodeOperation.hasPasscodeExist() {
            settingData[0].append(SettingModel(imageName: "password", name: "关闭密码锁"))
        }else {
            settingData[0].append(SettingModel(imageName: "password", name: "开启密码锁"))
        }        
        
        settingData[0].append(SettingModel(imageName: "budget", name: "设置月预算"))
        
        
        if self.hasDataInLastQuarter() {
            settingData[0].append(SettingModel(imageName: "dataAnalysis", name: "上季度消费分析报表"))
        }
        
//        settingData[0].append(SettingModel(imageName: "cloudBackups", name: "开启云备份"));
        settingData[1].append(SettingModel(imageName: "goodEvaluate", name: "好评鼓励"))
        settingData[1].append(SettingModel(imageName: "aboutApp", name: "关于APP"))
    }
    
    
    // MARK: - TableView 操作
    func numberOfSection() -> NSInteger {
        return settingData.count
    }    
    
    func numberOfItemsInSection(_ section: NSInteger) -> NSInteger {
        return settingData[section].count
    }
    
    func titleAtIndexPath(_ indexPath: IndexPath) -> SettingModel {
        return settingData[indexPath.section][indexPath.row]
    }
    
    func nameAtIndexPathWithFirst() -> String {
        return settingData[0][0].name
    }
    
    // MARK: - 判断上季度有没有数据
    func hasDataInLastQuarter() -> Bool {
        
        let quarterCategorysFetchedResultsController: NSFetchedResultsController = SingleConsume.fetchConsumeWithCategoryGroupInQuarter(Date())
        
        return quarterCategorysFetchedResultsController.fetchedObjects?.count == 0 ? false : true
    }
    
    
}
