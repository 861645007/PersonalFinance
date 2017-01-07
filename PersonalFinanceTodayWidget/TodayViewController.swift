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
    
    
    @IBOutlet weak var dayExpenseDescriptionLabel: UILabel!
    @IBOutlet weak var dayExpenseLabel: UILabel!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view from its nib.
        
        if #available(iOSApplicationExtension 10.0, *) {
            dayExpenseDescriptionLabel.textColor = UIColor.black
            dayExpenseLabel.textColor = UIColor.black
        }else {
            dayExpenseDescriptionLabel.textColor = UIColor.white
            dayExpenseLabel.textColor = UIColor.white
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.preferredContentSize = CGSize(width: 0, height: 61)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetMarginInsets(forProposedMarginInsets defaultMarginInsets: UIEdgeInsets) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, defaultMarginInsets.left, 0, 8)
    }
    
    
    func widgetPerformUpdate(_ completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.

        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        self.loadData()
        
        completionHandler(NCUpdateResult.newData)
    }
    
    func loadData() {
        dayExpenseLabel.text = ShareWithGroupOperation.sharedGroupOperation.gainDayExpense().convertToStrWithTwoFractionDigits()
    }
    
    @IBAction func addNewConsume(_ sender: AnyObject) {
        
        self.extensionContext?.open(URL(string: "AppUrlType://open")!, completionHandler: { (success: Bool) in
//            <#code#>
        })
    }
}
