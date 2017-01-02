//
//  SettingTableViewCell.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class SettingTableViewCell: UITableViewCell {

    
    @IBOutlet weak var settingNameLabel: UILabel!
    @IBOutlet weak var settingImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func prepareCollectionCell(_ settingModel: SettingModel) {
        self.settingImageView.image = UIImage(named: settingModel.imageName)
        self.settingNameLabel.text = settingModel.name
    }
}
