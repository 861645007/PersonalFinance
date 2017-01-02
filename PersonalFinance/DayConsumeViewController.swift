//
//  DayConsumeViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/13.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import DZNEmptyDataSet

class DayConsumeViewController: UIViewController {

    @IBOutlet weak var totalMoneyLabel: UILabel!    
    @IBOutlet weak var dayConsumeTableView: UITableView!
    
    var dayConsumeVM: DayConsumeViewModel = DayConsumeViewModel()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        dayConsumeTableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.totalMoneyLabel.fn_setNumber(self.dayConsumeVM.dayConsumeMoney, format: "￥%.2f")
        
        self.dayConsumeVM.initData()
        self.dayConsumeTableView.reloadData()        
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


extension DayConsumeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dayConsumeVM.numberOfItemsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DayConsumeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "DayConsumeCell") as! DayConsumeTableViewCell
        
        cell.prepareCollectionCellForConsumeView(self.dayConsumeVM.consumeInfoAtIndex(indexPath.row))
        
        return cell
    }
}


extension DayConsumeViewController: UITableViewDelegate {
    
}



// MARK: - DZNEmptyDataSetSource 数据源协议
extension DayConsumeViewController: DZNEmptyDataSetSource {
    // 设置图片
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "NoMoney")
    }
    
    // 设置文字
    func titleForEmptyDataSet(_ scrollView: UIScrollView!) -> NSAttributedString! {
        let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 13.0),
                         NSForegroundColorAttributeName: UIColor(red:0.894, green:0.827, blue:0.882, alpha:1)]
        return NSAttributedString(string: "今天尚未记账，快来记一笔吧", attributes: attribute)
    }
    
    func imageAnimationForEmptyDataSet(_ scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue  = 0.0
        animation.toValue    = 1.0
        animation.duration   = 1.0
        
        return animation
    }
    
    
//    func buttonTitleForEmptyDataSet(scrollView: UIScrollView!, forState state: UIControlState) -> NSAttributedString! {
//        let attribute = [NSForegroundColorAttributeName: UIColor(red:0, green:0.53, blue:0.7, alpha:1),
//                         NSFontAttributeName: UIFont.systemFontOfSize(20.0)]
//        return NSAttributedString(string: "今日首记", attributes: attribute)
//    }
    
    func buttonImageForEmptyDataSet(_ scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "rightArrowToNextVC")
    }

}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension DayConsumeViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        let addNewConsumeVC: AddNewCustomViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomViewController") as! AddNewCustomViewController
        
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
    }
}


