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
    
    @IBOutlet weak var settingTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        settingTableView.tableFooterView = UIView()
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
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
        
    
    
}
