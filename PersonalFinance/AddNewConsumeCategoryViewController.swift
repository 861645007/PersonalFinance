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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .plain, target: self, action: #selector(addNewCategoryDone))
        
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
            self.navigationController?.popViewController(animated: true)
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
        let customView: UIView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40, width: UIScreen.main.bounds.width, height: 66))
        customView.backgroundColor = UIColor.white
        
        categoryImage = UIImageView(frame: CGRect(x: 20, y: 8, width: 50, height: 50))
        categoryImage.image = UIImage(named: "New-yan")
        customView.addSubview(categoryImage)
        
        categoryNameTextField = UITextField(frame: CGRect(x: 80, y: 13, width: 200, height: 40))
        categoryNameTextField.backgroundColor = UIColor(red:228/255.0, green:228/255.0, blue:228/255.0, alpha:255/255.0)
        categoryNameTextField.layer.masksToBounds = true
        categoryNameTextField.layer.cornerRadius = 5.0
        categoryNameTextField.becomeFirstResponder()
        customView.addSubview(categoryNameTextField)
        
        return customView
    }
    
    // MARK: - 为键盘上方的 View 配置操作
    func prepareKeyboardNotifation() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboardShowNotifation(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(changeKeyboardHideNotifation(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func changeKeyboardShowNotifation(_ notification: Notification) {
        let userInfo: [AnyHashable: Any] = notification.userInfo!
        let valueEndFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        let keyboardEndY = valueEndFrame.cgRectValue.origin.y
        self.notifationOperation(userInfo, keyboardY: keyboardEndY)
    }
    
    func changeKeyboardHideNotifation(_ notification: Notification) {
        let userInfo: [AnyHashable: Any] = notification.userInfo!
        let valueStartFrame: NSValue = userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue
        
        let keyboardStartY = valueStartFrame.cgRectValue.origin.y
        
        self.notifationOperation(userInfo, keyboardY: keyboardStartY)
    }
    
    func notifationOperation(_ userInfo: [AnyHashable: Any], keyboardY: CGFloat) {
        let duration = userInfo[UIKeyboardAnimationDurationUserInfoKey]
        let curve = userInfo[UIKeyboardAnimationCurveUserInfoKey]
        
        UIView.animate(withDuration: (duration! as AnyObject).doubleValue, animations: { () -> Void in
            UIView.setAnimationBeginsFromCurrentState(true)
            UIView.setAnimationCurve(UIViewAnimationCurve(rawValue: Int((curve! as AnyObject).int32Value))!)
            self.keyboardView.center = CGPoint(x: self.keyboardView.center.x, y: keyboardY - self.keyboardView.bounds.size.height/2.0);
        }) 
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
// MARK: UICollectionViewDataSource
extension AddNewConsumeCategoryViewController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.addNewConsumeCategoryVM.numberOfItemsInSection()
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: AddNewConsumeCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "AddNewConsumeCategoryCell", for: indexPath) as! AddNewConsumeCategoryCollectionViewCell
        
        // Configure the cell
        cell.categoryImageView.image = self.addNewConsumeCategoryVM.imageAtIndexPath(indexPath.row)
        
        return cell
    }
}

// MARK: UICollectionViewDelegate
extension AddNewConsumeCategoryViewController {
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexPath = collectionView.indexPathsForSelectedItems?.first
        self.categoryImage.image = self.addNewConsumeCategoryVM.imageAtIndexPath(indexPath!.row)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
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

