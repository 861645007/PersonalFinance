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
import PDTSimpleCalendar
import SimpleAlert

// ConsumeCategory 结构体
struct ConsumeCategory {
    var id: Int32
    var name: String?
    var iconData: NSData?
    
    init(id: Int32, name: String, icon: NSData) {
        self.id = id
        self.name = name
        self.iconData = icon
    }
}

class AddNewCustomViewController: UIViewController {
    
    @IBOutlet weak var customTypeCollectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!
    
    
    var consumeDate: NSDate = NSDate()
    var consumeCategoryID: Int32 = 0
    var pdtCalendar: PDTSimpleCalendarViewController?
    
    
    var addNewCustomVM: AddNewCustomViewModel!
    var keyboardView: UIView!
    var selectTimeBtn: UIButton!
    var commentBtn: UIButton!
    
    var commentString: String? = ""
    
    var lastPosition: Int = 0
    

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
        
        // 配置初始化 category 数据
        self.addNewCustomVM.gainAllConsumeType()
        self.changeConsumeCategoryInfo(self.addNewCustomVM.gainCategoryWithCusOther())
        
        // 配置 UICollectionView 的滚动
        self.customTypeCollectionView.alwaysBounceVertical = true
        
        
        // 修改导航栏返回键的文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "    ", style: .Plain, target: nil, action: nil)
        // 修改返回键的颜色 为略粉色
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.976, green:0.904, blue:0.965, alpha:1)
    }
    
    // 配置 category 数据
    func changeConsumeCategoryInfo(consumeCategory: ConsumeCategory?) {
        if consumeCategory == nil {
            return
        }
        
        self.categoryImage.image = UIImage(data: (consumeCategory!.iconData)!)
        self.consumeCategoryID = consumeCategory!.id
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if Category.fetchAllConsumeCategoryWithUsed().count == 0 {
            self.navigationController?.popViewControllerAnimated(true)
            return
        }
        
        self.numberTextField.becomeFirstResponder()
        self.addNewCustomVM.gainAllConsumeType()
        self.customTypeCollectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        print("ViewController中didReceiveMemoryWarning调用")
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
            return (object as! String) != "￥0.00"
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
        keyboard.returnKeyTitle = "完成一笔"
        
        self.numberTextField.inputView = keyboard
    }
    
    // MARK: - 创建一个键盘上方的 View
    func createCustonKeyBoardView() ->UIView {
        let customView: UIView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height - 40, UIScreen.mainScreen().bounds.width, 40))
        customView.backgroundColor = UIColor.whiteColor()
        
        selectTimeBtn = UIButton(frame: CGRectMake(10, 5, 80, 30))
        selectTimeBtn.setTitle(self.addNewCustomVM.gainToday(), forState: .Normal)
        selectTimeBtn.addTarget(self, action: #selector(selectTime), forControlEvents: .TouchUpInside)
        self.setButtonStyleOfKeyboard(selectTimeBtn)
        customView.addSubview(selectTimeBtn)
        
        commentBtn = UIButton(frame: CGRectMake(100, 5, 80, 30))
        commentBtn.setTitle("写备注", forState: .Normal)
        commentBtn.addTarget(self, action: #selector(noteDownComment), forControlEvents: .TouchUpInside)
        self.setButtonStyleOfKeyboard(commentBtn)
        customView.addSubview(commentBtn)

        return customView
    }
    
    func selectTime() {
        self.gotoSimpleCalender()
    }
    
    func noteDownComment() {
        self.createPopView()
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
    
    // MARK: - 配置时间选择器
    
    // 跳转时间选择器
    func gotoSimpleCalender() {
        
        // 首先创建一个时间选择器
        if (pdtCalendar == nil) {
            pdtCalendar = PDTSimpleCalendarViewController()
            pdtCalendar?.delegate = self
            pdtCalendar?.weekdayHeaderEnabled = true
            
            // 设置时间选择器的开始和结束时间
            let offsetComponents = NSDateComponents()
            offsetComponents.month = 3
            pdtCalendar!.lastDate = pdtCalendar!.calendar.dateByAddingComponents(offsetComponents, toDate: NSDate(), options: .WrapComponents)
            
            offsetComponents.month = -4
            pdtCalendar!.firstDate = pdtCalendar!.calendar.dateByAddingComponents(offsetComponents, toDate: NSDate(), options: .WrapComponents)
            
            PDTSimpleCalendarViewCell.appearance().circleTodayColor = UIColor(red:217/255.0, green:217/255.0, blue:213/255.0, alpha:255/255.0)
            PDTSimpleCalendarViewCell.appearance().circleSelectedColor = UIColor(red:49/255.0, green:97/255.0, blue:157/255.0, alpha:255/255.0)
            
            // 默认显示当前日期
            pdtCalendar?.scrollToDate(NSDate(), animated: true)
            
            pdtCalendar?.edgesForExtendedLayout = .None
            
            pdtCalendar?.title = "选择时间"
            pdtCalendar?.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "完成", style: .Done, target: self, action: #selector(selectDateDone))
        }
        
        // 实现跳转
        self.navigationController?.pushViewController(pdtCalendar!, animated: true)
    }
    
    // 关闭 时间选择器
    func selectDateDone() {
        // 返回原界面
        pdtCalendar?.navigationController?.popViewControllerAnimated(true)
        // 获取所选择的时间
        let time = "\(consumeDate.month)月\(consumeDate.day)日"
        self.selectTimeBtn.setTitle(time, forState: .Normal)
    }

    // MARK: - 配置一个弹出框    
    func createPopView() {
        // 创建一个自定义的view
        let cusView = UIView(frame: CGRectMake(0, 0, 270, 100))
        cusView.backgroundColor = UIColor.whiteColor()
        
        let nameLabel = UILabel(frame: CGRectMake(0, 8, 270, 20))
        nameLabel.text = "备注"
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont.systemFontOfSize(20)
        cusView.addSubview(nameLabel)
        
        let textView: UITextView = UITextView(frame: CGRectMake(8, 30, 270 - 16, 64))
        textView.text = commentString
        textView.backgroundColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0)
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5.0
        textView.becomeFirstResponder()
        cusView.addSubview(textView)
        
        // 弹出自定义视图
        self.showCustomViewAlert(cusView, cancelTitle: "取消", oKTitle: "确定", cancelHandler: nil) {
            [weak self] (action) in
            if textView.text != "" {
                self!.commentString = textView.text
                self!.commentBtn.setTitle("已有备注", forState: .Normal)
                self!.commentBtn.layer.borderColor = UIColor.blueColor().CGColor
            }else {
                self!.commentBtn.setTitle("写备注", forState: .Normal)
                self!.commentBtn.layer.borderColor = UIColor.grayColor().CGColor
            }
        }
    }
}

// MARK: - UICollectionViewDelegate 协议
extension AddNewCustomViewController: UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        collectionView.deselectItemAtIndexPath(indexPath, animated: true)
        if indexPath.row == (self.addNewCustomVM.consumeTypeArr?.count)! - 1 {
            
            let addNewConsumeCategoryVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewConsumeCategoryViewController")

            self.navigationController?.pushViewController(addNewConsumeCategoryVC!, animated: true)
            return
        }else {
            let category = self.addNewCustomVM.consumeTypeArr![indexPath.row]
            
            let cell: CustomTypeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("ConsumeTypeCollectionViewCell", forIndexPath: indexPath) as! CustomTypeCollectionViewCell
            cell.moveToMenu(self.categoryImage.center)
            
            self.changeConsumeCategoryInfo(category)
            
            
            self.numberTextField.becomeFirstResponder()
        }
    }
    
    
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let currentPostion: Int = Int(scrollView.contentOffset.y);
        if (currentPostion - lastPosition > 25) {
            // 上滑
            lastPosition = currentPostion;
            self.numberTextField.resignFirstResponder()
            
        }else if (lastPosition - currentPostion > 25) {
            // 下滑
            lastPosition = currentPostion;
//            self.numberTextField.becomeFirstResponder()
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource 协议
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

// MARK: - MMNumberKeyboardDelegate 协议
extension AddNewCustomViewController: MMNumberKeyboardDelegate {
    
    // 按下返回键操作
    func numberKeyboardShouldReturn(numberKeyboard: MMNumberKeyboard!) -> Bool {
        // 首先判断 金额是否为0，为0 不能保存
        if self.numberTextField.text == "￥0.00" {
            TopAlert().createFailureTopAlert("金额不能为 0", parentView: self.view)
            return false
        }
        
        // 获取消费金额
        let numberText = numberTextField.text
        let numberStr = numberText?.substringFromIndex((numberText?.startIndex.advancedBy(1))!)
        let money: Double = Double(numberStr!)!
        
        // 保存数据
        self.addNewCustomVM.saveNewConsume(consumeCategoryID, photo: NSData(), comment: commentString!, money: money, time: consumeDate)
        
        // 返回主页面
        self.navigationController?.popViewControllerAnimated(true)
        return true
    }
}


extension AddNewCustomViewController: PDTSimpleCalendarViewDelegate {
    func simpleCalendarViewController(controller: PDTSimpleCalendarViewController!, didSelectDate date: NSDate!) {
        consumeDate = date.tolocalTime()
    }
}

