//
//  AddNewConsumeCategoryViewModel.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/18.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class AddNewConsumeCategoryViewModel: NSObject {
    
    var categoryWithouUsedArr: [Category]?
    
    override init() {
        super.init()
        self.setCategoryWithouUsedArr()
    }
    
    func setCategoryWithouUsedArr() {
        categoryWithouUsedArr = self.gainAllConsumeCategoryWithoutUsed()
    }    
       
    
    //MARK: - UICollectionView Data Source
    func numberOfItemsInSection() ->NSInteger {
        return (categoryWithouUsedArr?.count)!
    }
    
    func imageAtIndexPath(index: NSInteger) -> UIImage {
        return UIImage(data: categoryWithouUsedArr![index].iconData!)!
    }
    
    private func gainAllConsumeCategoryWithoutUsed() -> [Category] {
        return Category.fetchAllConsumeCategoryWithoutUsed()
    }
    
    // MARK: - can Save New Category
    
    func saveNewCategory(text: String, image: UIImage) -> Bool {
        // 保存操作(text.isEmpty)
        if text == "" {
            return false
        }
        
        Category.insertNewConsumeCategory(text, iconData: UIImagePNGRepresentation(image)!, beUsed: true)
        return true
    }
    
    
    
    
    
    
}
