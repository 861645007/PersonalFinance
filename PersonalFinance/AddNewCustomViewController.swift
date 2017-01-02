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
import PulsingHalo

// ConsumeCategory 结构体
struct ConsumeCategory {
    var id: Int32
    var name: String?
    var iconData: Data?
    
    init(id: Int32, name: String, icon: Data) {
        self.id = id
        self.name = name
        self.iconData = icon
    }
}

class AddNewCustomViewController: UIViewController {
    
    @IBOutlet weak var customTypeCollectionView: UICollectionView!
    @IBOutlet weak var numberTextField: UITextField!
    @IBOutlet weak var categoryImage: UIImageView!    
    
    var consumeDate: Date = Date()
    var consumeCategoryID: Int32 = 0
    var pdtCalendar: PDTSimpleCalendarViewController?
    
    
    var addNewCustomVM: AddNewCustomViewModel! = AddNewCustomViewModel()
    var keyboardView: UIView!
    var selectTimeBtn: UIButton!
    var commentBtn: UIButton!
    
    var commentString: String? = ""
    
    var lastPosition: Int = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 配置初始化 category 数据
        self.addNewCustomVM.gainAllConsumeType()
        self.changeConsumeCategoryInfo(self.addNewCustomVM.setDefaultCategory())
        self.numberTextField.text = self.addNewCustomVM.setDefaultMoney()
        self.commentString = self.addNewCustomVM.setDefaultComment()
        
        // 设置键盘
        self.createNumberKeyBoard()
        self.filterInput()
        
        // 添加键盘上方的自定义View
        self.keyboardView = self.createCustonKeyBoardView()
        self.prepareKeyboardNotifation()
        self.view.addSubview(self.keyboardView)       
        
        
        // 配置 UICollectionView 的滚动
        self.customTypeCollectionView.alwaysBounceVertical = true
        
        // 修改导航栏返回键的文字
        self.setNavigationBackItemBlank()
    }
    
    // 配置 category 数据
    func changeConsumeCategoryInfo(_ consumeCategory: ConsumeCategory?) {
        if consumeCategory == nil {
            return
        }
        
        self.categoryImage.image = UIImage(data: (consumeCategory!.iconData)!)
        self.consumeCategoryID = consumeCategory!.id
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Category.fetchAllConsumeCategoryWithUsed().count == 0 {
            self.navigationController?.popViewController(animated: true)
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
        let keyboard = MMNumberKeyboard(frame: CGRect.zero)
        keyboard.allowsDecimalPoint = true
        keyboard.delegate = self
        keyboard.returnKeyTitle = "完成一笔"
        
        self.numberTextField.inputView = keyboard
    }
    
    // MARK: - 创建一个键盘上方的 View
    func createCustonKeyBoardView() ->UIView {
        let customView: UIView = UIView(frame: CGRect(x: 0, y: UIScreen.main.bounds.height - 40, width: UIScreen.main.bounds.width, height: 40))
        customView.backgroundColor = UIColor.white
        
        selectTimeBtn = UIButton(frame: CGRect(x: 10, y: 5, width: 80, height: 30))
        selectTimeBtn.setTitle(self.addNewCustomVM.setDefaultTime(), for: UIControlState())
        selectTimeBtn.addTarget(self, action: #selector(selectTime), for: .touchUpInside)
        self.setButtonStyleOfKeyboard(selectTimeBtn)
        customView.addSubview(selectTimeBtn)
        
        commentBtn = UIButton(frame: CGRect(x: 100, y: 5, width: 80, height: 30))
        commentBtn.addTarget(self, action: #selector(noteDownComment), for: .touchUpInside)
        if commentString != "" {
            commentBtn.setTitle("已有备注", for: UIControlState())
            commentBtn.layer.borderColor = UIColor.blue.cgColor
        }else {
            commentBtn.setTitle("写备注", for: UIControlState())
            commentBtn.layer.borderColor = UIColor.gray.cgColor
        }
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
    
    
    func setButtonStyleOfKeyboard(_ button: UIButton) {
        button.backgroundColor = UIColor.clear
        
        button.layer.cornerRadius = 2.5
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        
        button.setTitleColor(UIColor.gray, for: UIControlState())
        button.setTitleColor(UIColor.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
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
    
    // MARK: - 配置时间选择器
    
    // 跳转时间选择器
    func gotoSimpleCalender() {
        
        // 首先创建一个时间选择器
        if (pdtCalendar == nil) {
            pdtCalendar = PDTSimpleCalendarViewController()
            pdtCalendar?.delegate = self
            pdtCalendar?.weekdayHeaderEnabled = true
            
            // 设置时间选择器的开始和结束时间
            var offsetComponents = DateComponents()
            offsetComponents.month = 2
            pdtCalendar!.lastDate = pdtCalendar!.calendar.dateByAddingComponents(offsetComponents, toDate: Date(), options: .WrapComponents)
            
            offsetComponents.month = -4
            pdtCalendar!.firstDate = pdtCalendar!.calendar.dateByAddingComponents(offsetComponents, toDate: Date(), options: .WrapComponents)
            
            PDTSimpleCalendarViewCell.appearance().circleTodayColor = UIColor(red:200/255.0, green:200/255.0, blue:200/255.0, alpha:1.0)
            PDTSimpleCalendarViewCell.appearance().circleSelectedColor = UIColor(red:49/255.0, green:97/255.0, blue:157/255.0, alpha:255/255.0)
            
            // 默认显示当前日期
            pdtCalendar?.selectedDate = Date()
            pdtCalendar?.scrollToDate(Date(), animated: true)
            
            // 设置时间选择器的View 距上为0（据 NavigationController）
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
        let cusView = UIView(frame: CGRect(x: 0, y: 0, width: 270, height: 100))
        cusView.backgroundColor = UIColor.white
        
        let nameLabel = UILabel(frame: CGRect(x: 0, y: 8, width: 270, height: 20))
        nameLabel.text = "备注"
        nameLabel.textAlignment = .center
        nameLabel.font = UIFont.systemFont(ofSize: 20)
        cusView.addSubview(nameLabel)
        
        let textView: UITextView = UITextView(frame: CGRect(x: 8, y: 30, width: 270 - 16, height: 64))
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
    
    // 添加脉冲动画
    func addPulsHaloAnimation(_ categoryIcon: UIImage) {
        let layer = PulsingHaloLayer.init()
        
        self.categoryImage.superview?.layer.insertSublayer(layer, below: self.categoryImage.layer)
        
        layer.startInterval         = 0.0
        layer.keyTimeForHalfOpacity = 0.5
        layer.haloLayerNumber       = 1         // 脉冲个数
        layer.radius                = 40        // 脉冲范围
        layer.animationDuration     = 1.5       // 动画间隔
        layer.repeatCount           = 1         // 动画只显示一次
        layer.position              = self.categoryImage.center
        
        categoryIcon.getColors({(colors) in
            layer.backgroundColor = colors.primaryColor.CGColor
        })
        
        layer.start()
    }
}

// MARK: - UICollectionViewDelegate 协议
extension AddNewCustomViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        if indexPath.row == (self.addNewCustomVM.consumeTypeArr?.count)! - 1 {
            
            let addNewConsumeCategoryVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewConsumeCategoryViewController")

            self.navigationController?.pushViewController(addNewConsumeCategoryVC!, animated: true)
            return
        }else {
            let category = self.addNewCustomVM.consumeTypeArr![indexPath.row]
            
            self.changeConsumeCategoryInfo(category)
            
            self.addPulsHaloAnimation(self.categoryImage.image!)
            self.numberTextField.becomeFirstResponder()
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPostion: Int = Int(scrollView.contentOffset.y);
        if (currentPostion - lastPosition > 25) {
            // 上滑
            lastPosition = currentPostion;
            self.numberTextField.resignFirstResponder()
            
        }else if (lastPosition - currentPostion > 25) {
            // 下滑
            lastPosition = currentPostion;
        }
    }
    
    
}

// MARK: - UICollectionViewDataSource 协议
extension AddNewCustomViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return addNewCustomVM.consumeTypeArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CustomTypeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ConsumeTypeCollectionViewCell", for: indexPath) as! CustomTypeCollectionViewCell
        
        cell.prepareCollectionCell(addNewCustomVM.consumeTypeArr![indexPath.row])
        
        return cell
    }
}

// MARK: - MMNumberKeyboardDelegate 协议
extension AddNewCustomViewController: MMNumberKeyboardDelegate {
    
    // 按下返回键操作
    func numberKeyboardShouldReturn(_ numberKeyboard: MMNumberKeyboard!) -> Bool {
        // 首先判断 金额是否为0，为0 不能保存
        if self.numberTextField.text == "￥0.00" {
            TopAlert().createFailureTopAlert("金额不能为 0", parentView: self.view)
            return false
        }
        
        // 获取消费金额
        let numberText = numberTextField.text
        let numberStr = numberText?.substring(from: (numberText?.characters.index((numberText?.startIndex)!, offsetBy: 1))!)
        let money: Double = Double(numberStr!)!
        
        // 保存数据
        self.addNewCustomVM.saveConsumeInfo(consumeCategoryID, photo: Data(), comment: commentString!, money: money, time: consumeDate)
        
        // 返回主页面
        self.navigationController?.popViewController(animated: true)
        return true
    }
}


extension AddNewCustomViewController: PDTSimpleCalendarViewDelegate {
    func simpleCalendarViewController(_ controller: PDTSimpleCalendarViewController!, didSelectDate date: Date!) {
        consumeDate = date.tolocalTime()
    }
}

