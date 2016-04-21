//
//  TodayViewController.swift
//  PersonalFinanceTodayWidget
//
//  Created by 子叶 on 16/4/21.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    
    @IBOutlet weak var dayExpenseLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        preferredContentSize = CGSizeMake(0, 46)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func widgetPerformUpdateWithCompletionHandler(completionHandler: ((NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.loadData()
        
        completionHandler(NCUpdateResult.NewData)
    }
    
    func loadData() {
        dayExpenseLabel.text = ShareWithGroupOperation.sharedGroupOperation.gainDayExpense().convertToStrWithTwoFractionDigits()
    }
    
    @IBAction func addNewConsume(sender: AnyObject) {
        
        self.extensionContext?.openURL(NSURL(string: "AppUrlType://open")!, completionHandler: { (success: Bool) in
//            <#code#>
        })
    }
}
