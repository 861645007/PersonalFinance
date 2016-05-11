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
        
        self.title = self.monthConsumeVM.setVCTitleName()
        
        if self.monthConsumeVM.singleConsumes?.count != 0 {
            monthConsumeTableView.emptyDataSetSource = nil
            monthConsumeTableView.emptyDataSetDelegate = nil
        }
        
        monthConsumeTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.monthConsumeVM.initData()
        
        self.totalMoneyLabel.fn_setNumber(self.monthConsumeVM.consumesMoney, format: "￥%.2f")
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
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.monthConsumeVM.numberOfSections()
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monthConsumeVM.numberOfCellsInSection(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: DayConsumeTableViewCell = tableView.dequeueReusableCellWithIdentifier("MonthConsumeCell") as! DayConsumeTableViewCell
        
        cell.prepareCollectionCellForConsumeView(self.monthConsumeVM.conusmeInfoAtIndexPath(indexPath))
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView: UIView = UIView(frame: CGRectMake(0, 0, self.view.bounds.size.width, 44))
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 2.0
        headView.backgroundColor = UIColor(red:0.146, green:0.096, blue:0.212, alpha:1)
        
        let bgbtn:UIButton = UIButton(frame: headView.frame)
        bgbtn.tag = section
        bgbtn.addTarget(self, action: #selector(clickSection(_:)), forControlEvents: .TouchUpInside)
        headView.addSubview(bgbtn)
        
        let dayLabel: UILabel = UILabel(frame: CGRectMake(16, 10, 80, 21))
        dayLabel.text = self.monthConsumeVM.titleWithTimeForSection(section)
        dayLabel.font = UIFont.boldSystemFontOfSize(20)
        dayLabel.textColor = UIColor(red:191/255.0, green:191/255.0, blue:191/255.0, alpha:255/255.0)
        headView.addSubview(dayLabel)
        
        let moneyLabel: UILabel = UILabel(frame: CGRectMake(dayLabel.frame.size.width + 28, 10, 100, 21))
        moneyLabel.text = self.monthConsumeVM.titleWithMoneyForSection(section)
        dayLabel.font = UIFont.boldSystemFontOfSize(18)
        moneyLabel.textColor = UIColor(red:191/255.0, green:191/255.0, blue:191/255.0, alpha:255/255.0)
        headView.addSubview(moneyLabel)
        
        let imageView: UIImageView = UIImageView(frame: CGRectMake(self.view.bounds.size.width - 36, 12, 20, 20))
        imageView.image = self.monthConsumeVM.sectionIsShow[section] ? UIImage(named: "month-DownArrow") : UIImage(named: "month-RightArrow")
        headView.addSubview(imageView)
        
        return headView
    }
    
    func clickSection(btn: UIButton) {
        self.monthConsumeVM.setCellIsShowOfSection(btn.tag)
        self.monthConsumeTableView.reloadSections(NSIndexSet(index: btn.tag), withRowAnimation: .Fade)
    }
    
}


extension MonthConsumeViewController: UITableViewDelegate {
    
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


