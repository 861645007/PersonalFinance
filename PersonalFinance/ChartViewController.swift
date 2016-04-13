//
//  ChartViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/4/7.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Charts

class ChartViewController: UIViewController {

    // UIScrollView 约束
    @IBOutlet weak var scrollViewWidth: NSLayoutConstraint!
    @IBOutlet weak var secondViewLeading: NSLayoutConstraint!
    
    // MARK: - 实例变量
    
    // 普通实例变量
    let chartVM: ChartViewModel = ChartViewModel()
    
    
    
    // 控制视图 实例变量
    @IBOutlet weak var pageControl: UIPageControl!
    
    // 饼图部分
    @IBOutlet weak var categoryCurrentTime: UILabel!
    @IBOutlet weak var categoryArrowLeft: UIButton!
    @IBOutlet weak var categoryArrowRight: UIButton!
    @IBOutlet weak var categoryChartView: PieChartView!
    
    // 走势图部分
    @IBOutlet weak var monthCurrentTime: UILabel!
    @IBOutlet weak var monthArrowRight: UIButton!
    @IBOutlet weak var monthArrowLeft: UIButton!
    @IBOutlet weak var monthChartView: LineChartView!
    
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
        
        createPieChart(self.chartVM.gainCategoryNamesWithPie(), values: self.chartVM.gainCategoryRatioWithPie(), money: self.chartVM.gainTotalExpense())
        
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
        
    }

    @IBAction func clickCategoryArrowRight(sender: AnyObject) {
        
    }
    
    @IBAction func clickMonthArrowLeft(sender: AnyObject) {
        
    }
    
    @IBAction func clickMonthArrowRight(sender: AnyObject) {
        
    }
    
    @IBAction func clickYearArrowLeft(sender: AnyObject) {
        
    }
    
    @IBAction func clickYearArrowRight(sender: AnyObject) {
        
    }
    
    
    
    // MARK: - 创建环形图
    func createPieChart(dataPoints: [String], values: [Double], money: Double) {
        let dataEntries: [ChartDataEntry] = self.chartVM.createDataEntries(dataPoints, values: values)

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "消费类别图")
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        // 设置颜色
        pieChartDataSet.colors = self.chartVM.setColorWithPie()
        
        categoryChartView.data = pieChartData
        
        // 设置动画
        categoryChartView.animate(xAxisDuration: 1.4, easingOption: .EaseOutBack)
        
        // 设置中心文字
        categoryChartView.centerAttributedText = self.chartVM.setCenterTextWithPie("总消费\n￥\(money.convertToStrWithTwoFractionDigits())");
    }
    
    // MARK: - 创建 走势图
    
    // 创建每月消费走势图
    func createMonthTrendChart(dataPoints: [String], values: [Double]) {
        let lineChartDataSet = self.chartVM.createLineChartDataSet("月消费走势图", dataEntries: self.chartVM.createDataEntries(dataPoints, values: values), gradient: self.chartVM.createGradientRef("#00ff0000", chartColorStr: "#ffff0000"))
        
        monthChartView.data = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
    }
    
    // 创建年消费走势图
    func createYearTrendChart(dataPoints: [String], values: [Double]) {
        let lineChartDataSet = self.chartVM.createLineChartDataSet("年消费走势图", dataEntries: self.chartVM.createDataEntries(dataPoints, values: values), gradient: self.chartVM.createGradientRef("#00ff0000", chartColorStr: "#ffff0000"))
        
        yearChartView.data = LineChartData(xVals: dataPoints, dataSet: lineChartDataSet)
    }
    
    

}
