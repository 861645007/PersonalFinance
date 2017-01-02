//
//  MonthConsumeViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/14.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
//import DZNEmptyDataSet

class MonthConsumeViewController: UIViewController {
    
    var monthConsumeVM: MonthConsumeViewModel = MonthConsumeViewModel()
    
    @IBOutlet weak var totalMoneyLabel: UILabel!    
    @IBOutlet weak var monthConsumeTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if self.monthConsumeVM.singleConsumes?.count != 0 {
            monthConsumeTableView.emptyDataSetSource = nil
            monthConsumeTableView.emptyDataSetDelegate = nil
        }
        
        monthConsumeTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.monthConsumeVM.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.monthConsumeVM.numberOfCellsInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DayConsumeTableViewCell = tableView.dequeueReusableCell(withIdentifier: "MonthConsumeCell") as! DayConsumeTableViewCell
        
        cell.prepareCollectionCellForConsumeView(self.monthConsumeVM.conusmeInfoAtIndexPath(indexPath))
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 44))
        headView.layer.masksToBounds = true
        headView.layer.cornerRadius = 2.0
        headView.backgroundColor = UIColor(red:0.723, green:0.723, blue:0.723, alpha:0.101)
        
        let bgbtn:UIButton = UIButton(frame: headView.frame)
        bgbtn.tag = section
        bgbtn.addTarget(self, action: #selector(clickSection(_:)), for: .touchUpInside)
        headView.addSubview(bgbtn)
        
        let dayLabel: UILabel = UILabel(frame: CGRect(x: 16, y: 10, width: 80, height: 21))
        dayLabel.text = self.monthConsumeVM.titleWithTimeForSection(section)
        dayLabel.font = UIFont.boldSystemFont(ofSize: 20)
        dayLabel.textColor = UIColor(red:191/255.0, green:191/255.0, blue:191/255.0, alpha:255/255.0)
        headView.addSubview(dayLabel)
        
        let moneyLabel: UILabel = UILabel(frame: CGRect(x: dayLabel.frame.size.width + 28, y: 10, width: 100, height: 21))
        moneyLabel.text = self.monthConsumeVM.titleWithMoneyForSection(section)
        dayLabel.font = UIFont.boldSystemFont(ofSize: 18)
        moneyLabel.textColor = UIColor(red:191/255.0, green:191/255.0, blue:191/255.0, alpha:255/255.0)
        headView.addSubview(moneyLabel)
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: self.view.bounds.size.width - 36, y: 12, width: 20, height: 20))
        imageView.image = self.monthConsumeVM.sectionIsShow[section] ? UIImage(named: "month-DownArrow") : UIImage(named: "month-RightArrow")
        headView.addSubview(imageView)
        
        return headView
    }
    
    func clickSection(_ btn: UIButton) {
        self.monthConsumeVM.setCellIsShowOfSection(btn.tag)
        self.monthConsumeTableView.reloadSections(IndexSet(integer: btn.tag), with: .fade)
    }
    
}


extension MonthConsumeViewController: UITableViewDelegate {
    
}


// MARK: - DZNEmptyDataSetSource 数据源协议
extension MonthConsumeViewController: DZNEmptyDataSetSource {
    // 设置图片
    func imageForEmptyDataSet(_ scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "NoMoney")
    }
    
    // 设置文字
    func titleForEmptyDataSet(_ scrollView: UIScrollView!) -> NSAttributedString! {
        let attribute = [NSFontAttributeName: UIFont.systemFont(ofSize: 13.0),
                         NSForegroundColorAttributeName: UIColor(red:0.894, green:0.827, blue:0.882, alpha:1)]
        return NSAttributedString(string: "您还没有记过账，快来记一笔吧", attributes: attribute)
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
//        return NSAttributedString(string: "本月首记", attributes: attribute)
//    }
    
    func buttonImageForEmptyDataSet(_ scrollView: UIScrollView!, forState state: UIControlState) -> UIImage! {
        return UIImage(named: "rightArrowToNextVC")
    }
    
    
}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension MonthConsumeViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
    
    func emptyDataSetDidTapButton(_ scrollView: UIScrollView!) {
        let addNewConsumeVC: AddNewCustomViewController = self.storyboard?.instantiateViewController(withIdentifier: "AddNewCustomViewController") as! AddNewCustomViewController
        self.navigationController?.pushViewController(addNewConsumeVC, animated: true)
        
    }
}


