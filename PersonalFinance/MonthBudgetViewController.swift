//
//  MonthBudgetViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/5/5.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import ReactiveCocoa

class MonthBudgetViewController: UIViewController {

    @IBOutlet weak var monthBudgetTextField: UITextField!
    
    let monthBudgetVM = MonthBudgetViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        monthBudgetTextField.text = "￥\(self.monthBudgetVM.gainMonthBudget())"
        
        // 金额处理
        monthBudgetTextField.rac_textSignal().filter({ (object: AnyObject!) -> Bool in
            let text = object as! String
            return text != "￥0.00"
        }).map {[unowned self]  (object: AnyObject!) -> AnyObject! in
            
            return self.monthBudgetVM.dealWithDecimalMoney(object as! String)
            }.subscribeNext {[unowned self] (object: AnyObject!) -> Void in
                self.monthBudgetTextField.text = object as? String
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        self.monthBudgetTextField.becomeFirstResponder()
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

    
    @IBAction func cancelVC(sender: AnyObject) {
        self.dismissSelf()
    }
    
    
    
    @IBAction func sureMonthBudget(sender: AnyObject) {
        // 存储操作
        
        let money: String = self.monthBudgetTextField.text!.substringFromIndex(self.monthBudgetTextField.text!.startIndex.advancedBy(1)).stringByReplacingOccurrencesOfString(",", withString: "", options: [], range: nil)

        if Double(money) == 0.0 {
            TopAlert().createFailureTopAlert("金额不能为 0 !", parentView: self.view)
        }else {
            self.monthBudgetVM.saveMonthBudget(Double(money)!)
            TopAlert().createSuccessTopAlert("本月预算为 \(money) 元", parentView: self.view) { [unowned self] in
                self.dismissSelf()
            }
        }
    }
    
    
    @IBAction func cancelMonthBudget(sender: AnyObject) {
        self.dismissSelf()
    }
    
    
    
    func dismissSelf() {
        self.monthBudgetTextField.resignFirstResponder()
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    
    
    
}
