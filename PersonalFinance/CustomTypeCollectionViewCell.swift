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
    
    func prepareCollectionCell(category: Category) {
        self.consumeImageView.image = UIImage(data: category.iconData!)
        self.consumeTypeLabel.text = category.name
    }
}
