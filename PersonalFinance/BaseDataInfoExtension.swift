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
        let numberFormat = NumberFormatter()
        numberFormat.numberStyle = .decimal
        numberFormat.minimumFractionDigits = 2
        numberFormat.maximumFractionDigits = 2
        
        return numberFormat.string(from: NSNumber(value: self as Double))!
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
    
    func setGradientColor(_ startColor: UIColor, endColor: UIColor) {
        let gradient = CAGradientLayer()
        gradient.frame = self.frame
        gradient.colors = [startColor, endColor]

        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func snapshot() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0)
        self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image!
    }
}

















