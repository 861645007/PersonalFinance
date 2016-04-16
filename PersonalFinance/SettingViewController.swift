//
//  SettingViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import ReactiveCocoa
import VENTouchLock

class SettingViewController: UIViewController {

    var settingVM: SettingViewModel = SettingViewModel()
    var passcodeOperation: PasscodeOperation = PasscodeOperation.sharedPasscodeOperation
    
    var monthBudget: String = "￥0.00"
    
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        settingTableView.tableFooterView = UIView()
        self.settingTableView.allowsSelection = true
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

    
    // MARK: - 配置一个弹出框
    func createPopView() {
        // 创建一个自定义的view
        let cusView = UIView(frame: CGRectMake(0, 0, 270, 100))
        cusView.backgroundColor = UIColor.whiteColor()
        
        let nameLabel = UILabel(frame: CGRectMake(0, 8, 270, 20))
        nameLabel.text = "请输入您的本月预算"
        nameLabel.textAlignment = .Center
        nameLabel.font = UIFont.systemFontOfSize(20)
        cusView.addSubview(nameLabel)
        
        let textField: UITextField = UITextField(frame: CGRectMake(8, 30, 270 - 16, 22))
        textField.text = monthBudget
        textField.tintColor = UIColor.clearColor()
        textField.keyboardType = .DecimalPad
        textField.textAlignment = .Center
        textField.becomeFirstResponder()
        // 金额处理
        textField.rac_textSignal().filter({ (object: AnyObject!) -> Bool in
            let text = object as! String
            return text != "￥0.00"
        }).map { (object: AnyObject!) -> AnyObject! in
            self.monthBudget = self.settingVM.dealWithDecimalMoney(object as! String)
            return self.monthBudget
            }.subscribeNext { (object: AnyObject!) -> Void in
                textField.text = object as? String
        }
        
        cusView.addSubview(textField)
        
        // 弹出自定义视图
        self.showCustomViewAlert(cusView, cancelTitle: "取消", oKTitle: "确定", cancelHandler: nil) {
            [weak self] (action) in
            // 存储操作
            let money = self!.monthBudget.substringFromIndex(self!.monthBudget.startIndex.advancedBy(1))
            BaseInfo.sharedBaseInfo.saveMonthBudget(NSNumber(double: Double(money)!))
        }
    }
}


extension SettingViewController: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.settingVM.numberOfSection()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingVM.numberOfItemsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCellWithIdentifier("SettingCell") as! SettingTableViewCell
        
        cell.prepareCollectionCell(self.settingVM.titleAtIndexPath(indexPath))
        
        return cell
    }
}


extension SettingViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                // 判断密码锁是否存在，存在就删除，不存在就设置
                if self.passcodeOperation.hasPasscodeExist() {
                    self.passcodeOperation.deletePasscode(self, handler: { [weak self] in
                        self!.settingVM.setSettingData()
                        self!.settingTableView.reloadData()
                    })
                }else {
                    self.passcodeOperation.setPasscode(self, handler: { [weak self] in
                        self!.settingVM.setSettingData()
                        self!.settingTableView.reloadData()
                    })
                }
                
            }else if indexPath.row == 1 {
                self.createPopView()
            }
        }
        
    }
    
    
    
    
    
}
