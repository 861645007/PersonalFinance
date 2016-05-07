//
//  BaseDataInfoExtension.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/12.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import Foundation
import UIKit

extension Double {
    func convertToStrWithTwoFractionDigits() -> String {
        let numberFormat = NSNumberFormatter()
        numberFormat.numberStyle = .DecimalStyle
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        
        return numberFormat.stringFromNumber(NSNumber(double: self))!
    }
    
}




extension UIView {
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = CGRectMake(rX, rY, rW, rH);
//    gradient.colors = [NSArray arrayWithObjects:
//    (id)[UIColor blackColor].CGColor,
//    (id)[UIColor grayColor].CGColor,
//    (id)[UIColor blackColor].CGColor,
//    nil];
//    [self.view.layer insertSublayer:gradient atIndex:0];
    
    func setGradientColor(startColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [startColor, endColor]

        self.layer.insertSublayer(gradient, atIndex: 0)
    }
}

















