//
//  SettingViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class SettingViewModel: NSObject {

    var settingData: [[SettingModel]] = [[],[]]
    
    
    
    override init() {
        super.init()
        self.setSettingData()
    }
    
    func setSettingData() {
        settingData[0].append(SettingModel(imageName: "password", name: "开启密码锁"));
        settingData[0].append(SettingModel(imageName: "budget", name: "设置月预算"));
        settingData[0].append(SettingModel(imageName: "cloudBackups", name: "开启云备份"));
        settingData[1].append(SettingModel(imageName: "goodEvaluate", name: "好评鼓励"));
        settingData[1].append(SettingModel(imageName: "aboutApp", name: "关于APP"));
    }
    
    
    
    func numberOfSection() -> NSInteger {
        return settingData.count
    }    
    
    func numberOfItemsInSection(section: NSInteger) -> NSInteger {
        return settingData[section].count
    }
    
    func titleAtIndexPath(indexPath: NSIndexPath) -> SettingModel {
        return settingData[indexPath.section][indexPath.row]
    }
    
    
    
}
