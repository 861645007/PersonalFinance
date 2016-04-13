//
//  BaseDataInfoExtension.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/12.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation

extension Double {
    func convertToStrWithTwoFractionDigits() -> String {
        let numberFormat = NSNumberFormatter()
        numberFormat.numberStyle = .DecimalStyle
        numberFormat.maximumFractionDigits = 2
        return numberFormat.stringFromNumber(NSNumber(double: self))!
    }
}
