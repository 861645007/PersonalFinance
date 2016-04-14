//
//  MonthConsumeViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/14.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class MonthConsumeViewController: UIViewController {
    
    var monthConsumeVM: MonthConsumeViewModel = MonthConsumeViewModel()
    
    @IBOutlet weak var totalMoneyLabel: UILabel!    
    @IBOutlet weak var monthConsumeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "本月消费"
        
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




extension MonthConsumeViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FinanceOfCategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("MonthConsumeCell") as! FinanceOfCategoryTableViewCell
        
//        cell.prepareCollectionCellForDayConsumeView(self.dayConsumeVM.consumeInfoAtIndex(indexPath.row))
        
        return cell
    }
}


extension MonthConsumeViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}



// MARK: - DZNEmptyDataSetSource 数据源协议
extension MonthConsumeViewController: DZNEmptyDataSetSource {
    // 设置图片
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "saveMoney")
    }
    
    // 设置文字
    func titleForEmptyDataSet(scrollView: UIScrollView!) -> NSAttributedString! {
        let attribute = [NSFontAttributeName: UIFont.systemFontOfSize(18.0),
                         NSForegroundColorAttributeName: UIColor.grayColor()]
        return NSAttributedString(string: "本月尚未记账", attributes: attribute)
    }
    
    func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
        let animation: CABasicAnimation = CABasicAnimation(keyPath: "transform")
        
        animation.fromValue = NSValue.init(CATransform3D: CATransform3DIdentity)
        animation.toValue = NSValue.init(CATransform3D: CATransform3DMakeRotation(CGFloat(M_PI_2), 0.0, 0.0, 1.0))
        
        animation.duration = 0.5
        animation.cumulative = true
        
        return animation
    }
    
    
    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
        let attribute = [NSForegroundColorAttributeName: UIColor(red:0, green:0.53, blue:0.7, alpha:1),
                         NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
        return NSAttributedString(string: "本月首记", attributes: attribute)
    }
    
    
}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension MonthConsumeViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(scrollView: UIScrollView!) {
        let addNewConsumeVC: AddNewCustomViewController = self.storyboard?.instantiateViewControllerWithIdentifier("AddNewCustomViewController") as! AddNewCustomViewController
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
        
    }
}





