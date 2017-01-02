//
//  OperatePlist.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/10.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class OperatePlist: NSObject {
    
    func gainDataWithFileName(_ fileName: String) -> [String: String] {
        //获取文件的完整路径
        let filePath = self.gainFilePath(fileName)
        return NSDictionary(contentsOfFile: filePath) as! [String: String]
    }
    
    // MARK: - 私有函数
    fileprivate func gainFilePath(_ fileName: String) -> String {
        return Bundle.main.path(forResource: fileName, ofType: "plist")!
    }
}
