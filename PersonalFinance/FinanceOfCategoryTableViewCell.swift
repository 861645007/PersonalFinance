//
//  FinanceOfCategoryTableViewCell.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/8.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class FinanceOfCategoryTableViewCell: UITableViewCell {

    @IBOutlet weak var categoryIcon: UIImageView!
    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var categoryRatio: UILabel!
    @IBOutlet weak var categoryMoney: UILabel!
    
    @IBOutlet weak var selectedFlagView: UIView!
    
    var lastSelectedState: Bool = false
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.contentView.layer.masksToBounds = true
        self.contentView.layer.cornerRadius = 5.0
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected && lastSelectedState == false {
            self.selectedFlagView.isHidden = false
            self.cellisSelectedAnimation()
            
            self.backgroundColor = UIColor(red:170/255.0, green:138/255.0, blue:179/255.0, alpha:0.5)
            
            lastSelectedState = true
        }else {
            
            if lastSelectedState {
                self.cellisCanceledAnimation()
            }
            self.backgroundColor = UIColor.clear
            
            lastSelectedState = false
        }
    }
    
    
    func prepareCollectionCellForChartView(_ financeCategory: FinanceOfCategory) {
        self.categoryName.text = financeCategory.categoryName
        self.categoryMoney.text = "￥" + financeCategory.categoryMoney.convertToStrWithTwoFractionDigits()
        self.categoryIcon.image = UIImage(data: financeCategory.iconData! as Data)
        
        // 将选中指示调颜色 改为图片主要颜色
        self.categoryIcon.image?.getColors(completionHandler: {[unowned self] (colors) in
            self.selectedFlagView.backgroundColor = colors.primaryColor
            })
    }
    
    func cellisSelectedAnimation() {
        self.selectedFlagView.transform = CGAffineTransform(scaleX: 1.0, y: 0.01)
        
        UIView.animate(withDuration: 1.5, delay: 0, usingSpringWithDamping: 0.35, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: { [unowned self] in
            self.selectedFlagView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)

            }, completion: nil)
    }
    
    func cellisCanceledAnimation() {
        self.selectedFlagView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.curveEaseIn], animations: { [unowned self] in
            self.selectedFlagView.transform = CGAffineTransform(scaleX: 1.0, y: 0.000001)
            
        }) { [unowned self] _ in
            self.selectedFlagView.isHidden = true
        }
    }

}
