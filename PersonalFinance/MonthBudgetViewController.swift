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
        monthBudgetTextField.reactive.continuousTextValues.filter({ (object: String?) -> Bool in
            return object! != "￥0.00"
        }).map {[unowned self] (object: String?) -> String in
                return self.monthBudgetVM.dealWithDecimalMoney(object! as String)
            }.observeValues {[unowned self] (object: String?) -> Void in
                self.monthBudgetTextField.text = object!
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
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

    
    @IBAction func cancelVC(_ sender: AnyObject) {
        self.dismissSelf()
    }
    
    @IBAction func sureMonthBudget(_ sender: AnyObject) {
        // 存储操作
        
        let money: String = self.monthBudgetTextField.text!.substring(from: self.monthBudgetTextField.text!.characters.index(self.monthBudgetTextField.text!.startIndex, offsetBy: 1)).replacingOccurrences(of: ",", with: "", options: [], range: nil)

        if Double(money) == 0.0 {
            TopAlert().createFailureTopAlert("金额不能为 0 !", parentView: self.view)
        }else {
            self.monthBudgetVM.saveMonthBudget(Double(money)!)
            TopAlert().createSuccessTopAlert("本月预算为 \(money) 元", parentView: self.view) { [unowned self] in
                self.dismissSelf()
            }
        }
    }
    
    
    @IBAction func cancelMonthBudget(_ sender: AnyObject) {
        self.dismissSelf()
    }
    
    
    
    func dismissSelf() {
        self.monthBudgetTextField.resignFirstResponder()
        self.dismiss(animated: false, completion: nil)
    }
    
    
    
    
}
