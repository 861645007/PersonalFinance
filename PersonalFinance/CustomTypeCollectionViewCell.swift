//
//  CustomTypeCollectionViewCell.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/10.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class CustomTypeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var consumeImageView: UIImageView!
    @IBOutlet weak var consumeTypeLabel: UILabel!
    
    func prepareCollectionCell(_ category: ConsumeCategory) {
        self.consumeImageView.image = UIImage(data: category.iconData! as Data)
        self.consumeTypeLabel.text = category.name
    }
    
    
    // 动画操作
    func moveToMenu(_ center: CGPoint) {
        let oldCenter = self.consumeImageView.center
        
        UIView.animate(withDuration: 1.5, animations: { [weak self] in
            self!.consumeImageView.center.x = center.x
            self!.consumeImageView.center.y = center.y
        }, completion: { [weak self] (success: Bool) in
            if success {
                self!.consumeImageView.center = oldCenter
            }
        }) 
    }
}
