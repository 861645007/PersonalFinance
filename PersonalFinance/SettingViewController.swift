//
//  SettingViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/15.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

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
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.settingVM.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settingVM.numberOfItemsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as! SettingTableViewCell
        
        cell.prepareCollectionCell(self.settingVM.titleAtIndexPath(indexPath))
        
        return cell
    }
}


extension SettingViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
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
                let monthBudgetVC = self.storyboard?.instantiateViewController(withIdentifier: "MonthBudgetViewController") as! MonthBudgetViewController
                
                monthBudgetVC.modalPresentationStyle = .overCurrentContext                
                self.present(monthBudgetVC, animated: true, completion: {
                    //
                })
            }else if indexPath.row == 2 {
                let dataAnalysisVC = self.storyboard?.instantiateViewController(withIdentifier: "DataAnalysisViewController") as! DataAnalysisViewController
                self.navigationController?.pushViewController(dataAnalysisVC, animated: true)
            }
        }else {
            if indexPath.row == 1 {
                let aboutSelfVC = self.storyboard?.instantiateViewController(withIdentifier: "AboutSelfViewController") as! AboutSelfViewController
                self.navigationController?.pushViewController(aboutSelfVC, animated: true)
            }
        }
        
    }
    
    
    
    
    
}
