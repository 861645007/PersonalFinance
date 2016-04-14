//
//  ChartViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/7.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Charts
import DZNEmptyDataSet

class ChartViewController: UIViewController {

    // UIScrollView 约束
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var secondViewLeading: NSLayoutConstraint!
    
    // MARK: - 实例变量
    
    // 普通实例变量
    let chartVM: ChartViewModel = ChartViewModel()
    
    
    
    // 控制视图 实例变量
    @IBOutlet weak var categoryTableView: UITableView!    
    @IBOutlet weak var pageControl: UIPageControl!
    
    // 饼图部分
    @IBOutlet weak var categoryCurrentTime: UILabel!
    @IBOutlet weak var categoryArrowLeft: UIButton!
    @IBOutlet weak var categoryArrowRight: UIButton!
    @IBOutlet weak var categoryChartView: PieChartView!
    
    // 走势图部分：以一个月的四周作为走势图
    @IBOutlet weak var monthCurrentTime: UILabel!
    @IBOutlet weak var monthArrowRight: UIButton!
    @IBOutlet weak var monthArrowLeft: UIButton!
    @IBOutlet weak var monthChartView: LineChartView!
    
    // 以一年的12个月作为走势图
    @IBOutlet weak var yearCurrentTime: UILabel!
    @IBOutlet weak var yearArrowLeft: UIButton!
    @IBOutlet weak var yearArrowRight: UIButton!
    @IBOutlet weak var yearChartView: LineChartView!
    
    
    // 设置 UIScrollView 约束
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        self.scrollViewWidth.constant = CGRectGetWidth(UIScreen.mainScreen().bounds) * 2
        self.secondViewLeading.constant = CGRectGetWidth(UIScreen.mainScreen().bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "报表"
        
        // 创建环形图
        self.preparePieChartWithCategory(self.chartVM.currentMonthWithCategory!)
        
        // 创建每月消费走势图
        prepareYearTrendChart(self.chartVM.currentYearWithTrend!)
        
        // 去除 tableView 多余的分割线
        self.categoryTableView.tableFooterView = UIView()
        
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
    
    // MARK: - 按钮功能
    

    @IBAction func clickCategoryArrowLeft(sender: AnyObject) {
        let newDate = self.chartVM.gainDateForPreMonthWithCategory()
        self.chartVM.setConsumeCategoryArrWithDate(newDate)
        self.preparePieChartWithCategory(newDate)
    }

    @IBAction func clickCategoryArrowRight(sender: AnyObject) {
        let newDate = self.chartVM.gainDateForNextMonthWithCategory()
        self.chartVM.setConsumeCategoryArrWithDate(newDate)
        self.preparePieChartWithCategory(newDate)
    }
    
    @IBAction func clickMonthArrowLeft(sender: AnyObject) {
        
    }
    
    @IBAction func clickMonthArrowRight(sender: AnyObject) {
        
    }
    
    @IBAction func clickYearArrowLeft(sender: AnyObject) {
        let newDate = self.chartVM.gainDateForPreYearTrend()
        self.chartVM.setConsumeMonthTrendArrWithDate(newDate)
        prepareYearTrendChart(newDate)
    }
    
    @IBAction func clickYearArrowRight(sender: AnyObject) {
        let newDate = self.chartVM.gainDateForNextYearTrend()
        self.chartVM.setConsumeMonthTrendArrWithDate(newDate)
        prepareYearTrendChart(newDate)        
    }
    
    
    
    // MARK: - 创建环形图
    // 配置 创建环形图操作
    func preparePieChartWithCategory(date: NSDate) {
        // 创建环形图
        if self.chartVM.gainTotalExpense() == 0 {
            createPieChart([], values: [], money: self.chartVM.gainTotalExpense())
            categoryChartView.alpha = 0.0
        }else {
            categoryChartView.alpha = 1.0
            createPieChart(self.chartVM.gainCategoryNamesWithPie(), values: self.chartVM.gainCategoryRatioWithPie(), money: self.chartVM.gainTotalExpense())
        }
        
        // 更新时间
        self.categoryCurrentTime.text = "\(date.year)年\(date.month)月"
        // 创建完图标后刷新数据
        categoryTableView.reloadData()
    }
    
    // 创建一个环形图
    func createPieChart(dataPoints: [String], values: [Double], money: Double) {
        let dataEntries: [ChartDataEntry] = self.chartVM.createDataEntries(dataPoints, values: values)

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "消费类别图")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        // 设置颜色
        pieChartDataSet.colors = self.chartVM.setColorWithPie()
        
        categoryChartView.data = pieChartData
        
        categoryChartView.descriptionText = ""
        
        // 设置动画
        categoryChartView.animate(xAxisDuration: 1.4, easingOption: .EaseOutBack)
        
        // 设置中心文字
        categoryChartView.centerAttributedText = self.chartVM.setCenterTextWithPie("总消费\n￥\(money.convertToStrWithTwoFractionDigits())");
    }
    
    // MARK: - 创建 走势图
    
    // 创建一个月的每周消费走势图
    func createMonthTrendChart(dataPoints: [String], values: [Double]) {
        let lineChartDataSet = self.chartVM.createLineChartDataSet("月消费走势图", dataEntries: self.chartVM.createDataEntries(dataPoints, values: values), gradient: self.chartVM.createGradientRef("#00ff0000", chartColorStr: "#ffff0000"))
        
        monthChartView.data = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
    }
    
    // 创建一年的每月消费走势图
    
    func prepareYearTrendChart(date: NSDate) {
        
        // 如果当年每月的消费记录中最大值为0， 说明当年未记录消费，则隐藏数据
        if self.chartVM.consumeMonthTrendArr.maxElement() == 0.0 {
            yearChartView.data = nil
        }else {
            createYearTrendChart(self.chartVM.months, values: self.chartVM.consumeMonthTrendArr)
        }
        
        self.yearCurrentTime.text = "\(date.year)年"
    }
    
    func createYearTrendChart(dataPoints: [String], values: [Double]) {
        let lineChartDataSet = self.chartVM.createLineChartDataSet("年消费走势图", dataEntries: self.chartVM.createDataEntries(dataPoints, values: values), gradient: self.chartVM.createGradientRef("#00ff0000", chartColorStr: "#ffff0000"))
        
        yearChartView.noDataText = "本年度尚未记录消费情况"
        
        yearChartView.data = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
    }
}

// MARK: - UIScrollView 操作协议
extension ChartViewController: UIScrollViewDelegate {
   
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        //通过scrollView内容的偏移计算当前显示的是第几页
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        //设置pageController的当前页
        pageControl.currentPage = page
    }
}

// MARK: - TableView 数据源协议
extension ChartViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartVM.gainNumberOfSection()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FinanceOfCategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("FinanceCategory") as! FinanceOfCategoryTableViewCell
        
        cell.prepareCollectionCellForChartView(self.chartVM.gainFinanceCategoryAtIndex(indexPath))
        
        return cell;
    }
}


// MARK: - TableView 操作协议
extension ChartViewController: UITableViewDelegate {
    func tableView(tableView: UITableView, didselectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}



// MARK: - DZNEmptyDataSetSource 数据源协议
extension ChartViewController: DZNEmptyDataSetSource {
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
        
        animation.duration = 0.25
        animation.cumulative = true
        animation.repeatCount = MAXFLOAT
        
        return animation
    }
    
}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension ChartViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(scrollView: UIScrollView!) -> Bool {
        return true
    }
}





