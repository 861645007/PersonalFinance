//
//  AddNewCustomViewController.swift
//  PersonalFinance
//
//  Created by ziye on 16/2/2.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MMNumberKeyboard

class AddNewCustomViewController: UIViewController {
    
    @IBOutlet weak var customTypeCollectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    
    
    var addNewCustomVM: AddNewCustomViewModel!
    var keyboardView: UIView!
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addNewCustomVM = AddNewCustomViewModel()
        
        // 设置键盘
        self.createNumberKeyBoard()
        self.filterInput()

        // 添加键盘上方的自定义View
        self.keyboardView = self.createCustonKeyBoardView()
        self.prepareKeyboardNotifation()
        self.view.addSubview(self.keyboardView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addNewCustomVM.gainAllConsumeType()
        self.numberTextField.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - 数字 输入处理
    func filterInput() {
        self.numberTextField.rac_textSignal().filter({ (object: AnyObject!) -> Bool in
            let text = object as! String
            return text != "￥0.00"
            }).map { (object: AnyObject!) -> AnyObject! in
                let text = object as! String
                
                return self.addNewCustomVM.dealWithDecimalMoney(text)
                }.subscribeNext { (object: AnyObject!) -> Void in
                    self.numberTextField.text = object as? String
        }
    }
    
    // MARK: - 配置数字键盘
    func createNumberKeyBoard() {
        let keyboard = MMNumberKeyboard(frame: CGRectZero)
        keyboard.allowsDecimalPoint = true
        keyboard.delegate = self
        
        self.numberTextField.inputView = keyboard
    }
    
    // 创建一个键盘上方的 View
    func createCustonKeyBoardView() ->UIView {
        let customView: UIView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 40, UIScreen.mainScreen().bounds.width, 40))
        customView.backgroundColor = UIColor.whiteColor()
        
        let selectTimeBtn = UIButton(frame: CGRectMake(10, 5, 80, 30))
        selectTimeBtn.setTitle("改时间", forState: .Normal)
        selectTimeBtn.addTarget(self, action: "selectTime", forControlEvents: .TouchUpInside)
        self.setButtonStyleOfKeyboard(selectTimeBtn)
        customView.addSubview(selectTimeBtn)
        
        
        let commentBtn = UIButton(frame: CGRectMake(100, 5, 80, 30))
        commentBtn.setTitle("写备注", forState: .Normal)
        commentBtn.addTarget(self, action: "noteDownComment", forControlEvents: .TouchUpInside)
        self.setButtonStyleOfKeyboard(commentBtn)
        customView.addSubview(commentBtn)

        return customView
    }
    
    func selectTime() {
        print("点击了一下")
    }
    
    func noteDownComment() {
        
    }
    
    
    func setButtonStyleOfKeyboard(button: UIButton) {
        button.backgroundColor = UIColor.clearColor()
        
        button.layer.cornerRadius = 2.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.grayColor().CGColor
        
        button.setTitleColor(UIColor.grayColor(), forState: .Normal)
        button.setTitleColor(UIColor.lightGrayColor(), forState: .Highlighted)
        button.titleLabel?.font = UIFont.systemFontOfSize(13)
    }
    
    // MARK: - 为键盘上方的 View 配置操作
    func prepareKeyboardNotifation() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeKeyboardShowNotifation:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeKeyboardHideNotifation:", name: UIKeyboardWillHideNotification, object: nil)
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


extension AddNewCustomViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        
        
        print("section: \(indexPath.section), row: (\(indexPath.row))")
        
    }
    
}

extension AddNewCustomViewController: UICollectionViewDataSource {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addNewCustomVM.consumeTypeArr!.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell: CustomTypeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ConsumeTypeCollectionViewCell", forIndexPath: indexPath) as! CustomTypeCollectionViewCell
        
        cell.prepareCollectionCell(addNewCustomVM.consumeTypeArr![indexPath.row])
        
        return cell
    }
}

extension AddNewCustomViewController: MMNumberKeyboardDelegate {
    func numberKeyboardShouldReturn(numberKeyboard: MMNumberKeyboard!) -> Bool {
        return true
    }
}


