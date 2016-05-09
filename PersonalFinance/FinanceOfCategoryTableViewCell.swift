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
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if selected && lastSelectedState == false {
            self.selectedFlagView.hidden = false
            self.cellisSelectedAnimation()
            self.backgroundColor = UIColor(red:0.146, green:0.096, blue:0.212, alpha:1)
            
            lastSelectedState = true
        }else {
            
            if lastSelectedState {
                self.cellisCanceledAnimation()
            }
            self.backgroundColor = UIColor.clearColor()
            
            lastSelectedState = false
        }
    }
    
    
    func prepareCollectionCellForChartView(financeCategory: FinanceOfCategory) {
        self.categoryRatio.text = (financeCategory.categoryRatio * 100).convertToStrWithTwoFractionDigits() + "%"
        self.categoryName.text = financeCategory.categoryName
        self.categoryMoney.text = "￥" + financeCategory.categoryMoney.convertToStrWithTwoFractionDigits()
        self.categoryIcon.image = UIImage(data: financeCategory.iconData!)
    }
    
    func prepareCollectionCellForDayConsumeView(consume: SingleConsume) {
        self.categoryName.text = consume.consumeCategory?.name
        self.categoryMoney.text = "￥" + (consume.money?.doubleValue.convertToStrWithTwoFractionDigits())!
        self.categoryIcon.image = UIImage(data: (consume.consumeCategory?.iconData)!)
    }
    
    func cellisSelectedAnimation() {
        self.selectedFlagView.transform = CGAffineTransformMakeScale(1.0, 0.01)
        
        UIView.animateWithDuration(1.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.CurveEaseIn], animations: { [unowned self] in
            self.selectedFlagView.transform = CGAffineTransformMakeScale(1.0, 1.0)

            }, completion: nil)
    }
    
    func cellisCanceledAnimation() {
        self.selectedFlagView.transform = CGAffineTransformMakeScale(1.0, 1.0)
        
        UIView.animateWithDuration(1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: [.CurveEaseIn], animations: { [unowned self] in
            self.selectedFlagView.transform = CGAffineTransformMakeScale(1.0, 0.000001)
            
        }) { [unowned self] _ in
            self.selectedFlagView.hidden = true            
        }
    }

}
