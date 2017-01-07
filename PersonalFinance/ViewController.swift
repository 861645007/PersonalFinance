//
//  ViewController.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
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
        NotificationCenter.default.addObserver(self, selector: #selector(showAddNewConsumeVC), name: NSNotification.Name(rawValue: AddNewConsumeInWidgetNotification), object: nil)
        
        // 配置通知
        NotificationCenter.default.addObserver(self, selector: #selector(showMonthConsumesVC), name: NSNotification.Name(rawValue: ShowMonthConsumesVCNotification), object: nil)
        
        // 配置修改月预算通知
        NotificationCenter.default.addObserver(self, selector: #selector(showMidifyMonthBudgetVC), name: NSNotification.Name(rawValue: ShowModifyMonthBudgetVCNotification), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        self.todayExpenseLabel.fn_setNumber(NSNumber(value: self.mainVM.gainDayExpense()), format: "￥%.2f")
        self.monthExpenseLabel.fn_setNumber(NSNumber(value: self.mainVM.gainMonthExpense()), format: "￥%.2f")
        self.newExpenseLabel.fn_setNumber(NSNumber(value: self.mainVM.gainNewExpense()), format: "￥%.2f")
        self.weekExpenseLabel.fn_setNumber(NSNumber(value: self.mainVM.gainWeekExpense()), format: "￥%.2f")

        // 设置进度条
        self.setProgressBar(self.mainVM.configureProgressBarPercent())
    }
    
    // 设置进度条
    func setProgressBar(_ value: CGFloat) {
        
        UIView.animate(withDuration: Double(value) * 2.0 / 100.0) {
            self.percentProgressBar.value = value > 100.0 ? 100.0 : value
            
            // 根据值得大小不同设置 进度条的颜色
            self.percentProgressBar.progressColor       = self.mainVM.gainProgressColor(value)
            self.percentProgressBar.progressStrokeColor = self.mainVM.gainProgressColor(value)
        }
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
//        // 取消其他页面的导航栏透明
//        self.navigationController?.navigationBar.setBackgroundImage(nil, forBarMetrics: .Default);
//        self.navigationController?.navigationBar.shadowImage = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "GotoMonthConsumeVC" {
            let vc = segue.destination as! MonthConsumeViewController
            vc.title = "本月消费"
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.month)            
        }else if segue.identifier == "GotoWeekConsumeVC" {
            let vc = segue.destination as! MonthConsumeViewController
            vc.title = "本周消费"
            vc.monthConsumeVM = self.mainVM.monthOrWeekConsumesVM(MonthOrWeekVCState.week)
        }
    }
    
    
    @IBAction func showConsumeDetailVC(_ sender: AnyObject) {
        if self.mainVM.gainNewExpense() == 0.0 {
            return
        }
        
        let addNewConsumeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomViewController") as! AddNewCustomViewController
        addNewConsumeVC.addNewCustomVM = self.mainVM.newDetailConsumeVM()
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
    
    
    func showAddNewConsumeVC() {
        let addNewConsumeVC = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomViewController") as! AddNewCustomViewController
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
    
    func showMonthConsumesVC() {
        let monthConsumesVC = self.storyboard?.instantiateViewController(withIdentifier: "MonthConsumeViewController") as! MonthConsumeViewController
        self.navigationController?.pushViewController(monthConsumesVC, animated: true)
    }
    
    func showMidifyMonthBudgetVC() {
        let midifyMonthBudgetVC = self.storyboard?.instantiateViewController(withIdentifier: "MonthBudgetViewController") as! MonthBudgetViewController
        self.navigationController?.pushViewController(midifyMonthBudgetVC, animated: true)
    }
}

