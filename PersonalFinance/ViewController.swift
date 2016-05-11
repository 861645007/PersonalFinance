//
//  ViewController.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import SwiftDate
import MBCircularProgressBar

let AddNewConsumeInWidgetNotification = "com.huanqiang.PersonalFinance.AddNewConsumeInWidgetNotification"
let ShowMonthConsumesVCNotification = "ShowMonthConsumesVCNotification"


class ViewController: UIViewController {
    
    var mainVM: MainViewModel! = MainViewModel()
    
    @IBOutlet weak var percentProgressBar: MBCircularProgressBarView!
    
    @IBOutlet weak var todayExpenseLabel: UILabel!
    @IBOutlet weak var monthExpenseLabel: UILabel!
    @IBOutlet weak var newExpenseLabel: UILabel!
    @IBOutlet weak var weekExpenseLabel: UILabel!
    
    
    


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 修改导航栏返回键的文字
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "    ", style: .Plain, target: nil, action: nil)
        // 修改返回键的颜色 为略粉色
        self.navigationController?.navigationBar.tintColor = UIColor(red:0.976, green:0.904, blue:0.965, alpha:1)
        
        // 设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default);
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        // 配置 点击 Today Widget 的新增按钮的页面跳转操作
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showAddNewConsumeVC), name: AddNewConsumeInWidgetNotification, object: nil)
        
        
        // 配置通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMonthConsumesVC), name: ShowMonthConsumesVCNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.todayExpenseLabel.fn_setNumber(self.mainVM.gainDayExpense(), format: "￥%.2f")
        self.monthExpenseLabel.fn_setNumber(self.mainVM.gainMonthExpense(), format: "￥%.2f")
        self.newExpenseLabel.fn_setNumber(self.mainVM.gainNewExpense(), format: "￥%.2f")
        self.weekExpenseLabel.fn_setNumber(self.mainVM.gainWeekExpense(), format: "￥%.2f")
        
        self.percentProgressBar.value = self.mainVM.configureProgressBarPercent()
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
//        // 取消其他页面的导航栏透明
//        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default);
//        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "GotoMonthConsumeVC" {
            let vc = segue.destinationViewController as! MonthConsumeViewController
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.Month)            
        }else if segue.identifier == "GotoWeekConsumeVC" {
            let vc = segue.destinationViewController as! MonthConsumeViewController
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.Week)
        }
    }
    
    // 设置按钮圆角
    func setBtnCornerRadius(btn: UIButton) {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = (btn.frame.height / 2)
    }
    
    func showAddNewConsumeVC() {
        let addNewConsumeVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewCustomViewController") as! AddNewCustomViewController
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
    
    func showMonthConsumesVC() {
        let monthConsumesVC = self.storyboard?.instantiateViewControllerWithIdentifier("MonthConsumeViewController") as! MonthConsumeViewController
        self.navigationController?.pushViewController(monthConsumesVC, animated: true)
    }
}

