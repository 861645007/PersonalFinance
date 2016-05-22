//
//  AddNewConsumeCategoryViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/18.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class AddNewConsumeCategoryViewController: UICollectionViewController {
    
    let addNewConsumeCategoryVM: AddNewConsumeCategoryViewModel = AddNewConsumeCategoryViewModel()
    var keyboardView: UIView!
    var categoryImage: UIImageView!
    var categoryNameTextField: UITextField!
    
    var lastPosition: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "新增类别"
        // Uncomment the following line to preserve selection between presentations
        self.collectionView?.alwaysBounceVertical = true
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Plain, target: self, action: #selector(addNewCategoryDone))
        
        // 添加键盘上方的自定义View
        self.keyboardView = self.createCustonKeyBoardView()
        self.prepareKeyboardNotifation()
        self.view.addSubview(self.keyboardView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func addNewCategoryDone() {
        
        // 保存操作
        if self.addNewConsumeCategoryVM.saveNewCategory(categoryNameTextField.text!, image: self.categoryImage.image!) {
            self.navigationController?.popViewControllerAnimated(true)
        }else {
            TopAlert().createFailureTopAlert("请输入类型名称", parentView: self.view)
            return
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    
    // MARK: - 创建一个键盘上方的 View
    func createCustonKeyBoardView() ->UIView {
        let customView: UIView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 40, UIScreen.mainScreen().bounds.width, 66))
        customView.backgroundColor = UIColor.whiteColor()
        
        categoryImage = UIImageView(frame: CGRectMake(20, 8, 50, 50))
        categoryImage.image = UIImage(named: "New-yan")
        customView.addSubview(categoryImage)
        
        categoryNameTextField = UITextField(frame: CGRectMake(80, 13, 200, 40))
        categoryNameTextField.backgroundColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha:255/255.0)
        categoryNameTextField.layer.masksToBounds = true
        categoryNameTextField.layer.cornerRadius = 5.0
        categoryNameTextField.becomeFirstResponder()
        customView.addSubview(categoryNameTextField)
        
        return customView
    }
    
    // MARK: - 为键盘上方的 View 配置操作
    func prepareKeyboardNotifation() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeKeyboardShowNotifation(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(changeKeyboardHideNotifation(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func changeKeyboardShowNotifation(notification: NSNotification) {
        let userInfo: [NSObject: AnyObject] = notification.userInfo!
        let valueEndFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        let keyboardEndY = valueEndFrame.CGRectValue().origin.y
        self.notifationOperation(userInfo, keyboardY: keyboardEndY)
    }
    
    func changeKeyboardHideNotifation(notification: NSNotification) {
        let userInfo: [NSObject: AnyObject] = notification.userInfo!
        let valueStartFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        let keyboardStartY = valueStartFrame.CGRectValue().origin.y
        
        self.notifationOperation(userInfo, keyboardY: keyboardStartY)
    }
    
    func notifationOperation(userInfo: [NSObject: AnyObject], keyboardY: CGFloat) {
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]
        
        UIView.animateWithDuration(duration!.doubleValue) { () -> Void in
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int(curve!.intValue))!)
            self.keyboardView.center = CGPointMake(self.keyboardView.center.x, keyboardY - self.keyboardView.bounds.size.height/2.0);
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: UICollectionViewDataSource
extension AddNewConsumeCategoryViewController {
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.addNewConsumeCategoryVM.numberOfItemsInSection()
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: AddNewConsumeCategoryCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("AddNewConsumeCategoryCell", forIndexPath: indexPath) as! AddNewConsumeCategoryCollectionViewCell
        
        // Configure the cell
        cell.categoryImageView.image = self.addNewConsumeCategoryVM.imageAtIndexPath(indexPath.row)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension AddNewConsumeCategoryViewController {
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let indexPath = collectionView.indexPathsForSelectedItems()?.first
        self.categoryImage.image = self.addNewConsumeCategoryVM.imageAtIndexPath(indexPath!.row)
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentPostion: Int = Int(scrollView.contentOffset.y);
        if (currentPostion - lastPosition > 25) {
            // 上滑
            lastPosition = currentPostion;
            self.categoryNameTextField.resignFirstResponder()
            
        }else if (lastPosition - currentPostion > 25) {
            // 下滑
            lastPosition = currentPostion;
        }
    }
}

