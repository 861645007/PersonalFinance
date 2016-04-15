//
//  SettingModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class SettingModel: NSObject {
    var imageName: String = ""
    var name: String = ""
    
    init(imageName: String, name: String) {
        self.imageName = imageName
        self.name = name
    }
    
}
