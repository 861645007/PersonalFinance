//
//  ViewController.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import ReactiveCocoa
import MBCircularProgressBar

let AddNewConsumeInWidgetNotification   = "com.huanqiang.PersonalFinance.AddNewConsumeInWidgetNotification"
let ShowMonthConsumesVCNotification     = "ShowMonthConsumesVCNotification"
let ShowModifyMonthBudgetVCNotification = "ShowModifyMonthBudgetVCNotification"



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
        self.setNavigationBackItemBlank()
        
        // 设置导航栏透明
        self.setNavigationBarHidden()
        
        // 配置 点击 Today Widget 的新增按钮的页面跳转操作
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showAddNewConsumeVC), name: AddNewConsumeInWidgetNotification, object: nil)
        
        // 配置通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMonthConsumesVC), name: ShowMonthConsumesVCNotification, object: nil)
        
        // 配置修改月预算通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(showMidifyMonthBudgetVC), name: ShowModifyMonthBudgetVCNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.todayExpenseLabel.fn_setNumber(self.mainVM.gainDayExpense(), format: "￥%.2f")
        self.monthExpenseLabel.fn_setNumber(self.mainVM.gainMonthExpense(), format: "￥%.2f")
        self.newExpenseLabel.fn_setNumber(self.mainVM.gainNewExpense(), format: "￥%.2f")
        self.weekExpenseLabel.fn_setNumber(self.mainVM.gainWeekExpense(), format: "￥%.2f")

        // 设置进度条
        self.setProgressBar(self.mainVM.configureProgressBarPercent())
    }
    
    // 设置进度条
    func setProgressBar(value: CGFloat) {
        self.percentProgressBar.setValue(value > 100.0 ? 100.0 : value , animateWithDuration: Double(value) * 3.0 / 100.0)

        // 根据值得大小不同设置 进度条的颜色
        self.percentProgressBar.progressColor       = self.mainVM.gainProgressColor(value)
        self.percentProgressBar.progressStrokeColor = self.mainVM.gainProgressColor(value)
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
            vc.title = "本月消费"
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.Month)            
        }else if segue.identifier == "GotoWeekConsumeVC" {
            let vc = segue.destinationViewController as! MonthConsumeViewController
            vc.title = "本周消费"
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.Week)
        }
    }
    
    
    @IBAction func showConsumeDetailVC(sender: AnyObject) {
        if self.mainVM.gainNewExpense() == 0.0 {
            return
        }
        
        let addNewConsumeVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewCustomViewController") as! AddNewCustomViewController
        addNewConsumeVC.addNewCustomVM = self.mainVM.newDetailConsumeVM()
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
    
    
    
    func showAddNewConsumeVC() {
        let addNewConsumeVC = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewCustomViewController") as! AddNewCustomViewController
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
    
    func showMonthConsumesVC() {
        let monthConsumesVC = self.storyboard?.instantiateViewControllerWithIdentifier("MonthConsumeViewController") as! MonthConsumeViewController
        self.navigationController?.pushViewController(monthConsumesVC, animated: true)
    }
    
    func showMidifyMonthBudgetVC() {
        let midifyMonthBudgetVC = self.storyboard?.instantiateViewControllerWithIdentifier("MonthBudgetViewController") as! MonthBudgetViewController
        self.navigationController?.pushViewController(midifyMonthBudgetVC, animated: true)
    }
}

