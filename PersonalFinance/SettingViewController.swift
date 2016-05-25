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
    
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        settingTableView.tableFooterView = UIView()
        
        self.setNavigationBackItemBlank()
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
                let monthBudgetVC = self.storyboard?.instantiateViewControllerWithIdentifier("MonthBudgetViewController") as! MonthBudgetViewController
                
                monthBudgetVC.modalPresentationStyle = .OverCurrentContext                
                self.presentViewController(monthBudgetVC, animated: true, completion: {
                    //
                })
            }
        }else {
            if indexPath.row == 1 {
                let aboutSelfVC = self.storyboard?.instantiateViewControllerWithIdentifier("AboutSelfViewController") as! AboutSelfViewController
                self.navigationController?.pushViewController(aboutSelfVC, animated: true)
            }
        }
        
    }
    
    
    
    
    
}
