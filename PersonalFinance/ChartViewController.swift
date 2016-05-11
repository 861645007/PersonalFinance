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
import Spring

class ChartViewController: UIViewController {

    // UIScrollView 约束
//    @IBOutlet weak var scrollVIewHeigh: NSLayoutConstraint!
    
    // MARK: - 实例变量
    
    // 普通实例变量
    let chartVM: ChartViewModel = ChartViewModel()
    var currentTimeModel: ChartTimeModel = .Week
    
    
    @IBOutlet weak var timeIndicatorView: UIView!
    
    // 控制视图 实例变量
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var chartBGView: SpringView!
    // 饼图部分
    @IBOutlet weak var categoryChartView: PieChartView!
    
    // 走势图部分：以一个月的四周作为走势图
    @IBOutlet weak var sevenDaysChartView: BarChartView!
    
    // 以一年的12个月作为走势图
    @IBOutlet weak var thirdWeeksChartView: LineChartView!
    
    
    let screenWidth = CGRectGetWidth(UIScreen.mainScreen().bounds)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryChartView.delegate = self
        sevenDaysChartView.delegate = self
        
        // 去除 tableView 多余的分割线
        self.categoryTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.prepareChartView()
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
    
    // 手势 操作
    
    // 向右滑动， 查看以前的内容
    @IBAction func rightSwipe(sender: AnyObject) {
        switch currentTimeModel {
        case .Week:
            self.chartVM.setWeekToPre()
        case .Month:
            self.chartVM.setMonthToPre()
        case .Year:
            self.chartVM.setYearToPre()
        }
        
        self.swipeAnimation(true) { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func leftSwipe(sender: AnyObject) {
        switch currentTimeModel {
        case .Week:
            self.chartVM.setWeekToNext()
        case .Month:
            self.chartVM.setMonthToNext()
        case .Year:
            self.chartVM.setYearToNext()
        }
        
        self.swipeAnimation(false) { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    // 滑动动画
    func swipeAnimation(isRight: Bool, completion: () -> ()) {
        let animationImage = UIImageView(frame: self.chartBGView.frame)
        animationImage.image = self.chartBGView.snapshot()
        self.view.addSubview(animationImage)
        
        if isRight {
            self.chartBGView.center.x -= self.screenWidth
        }else {
            self.chartBGView.center.x += self.screenWidth
        }
        
        
        // 等主视图被移除屏幕了之后再 进行数据加载
        completion()
        
        UIImageView.animateWithDuration(1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [.CurveEaseInOut], animations: { [unowned self] in
            
            if isRight {
                self.chartBGView.center.x += self.screenWidth
                animationImage.center.x += self.screenWidth
            }else {
                self.chartBGView.center.x -= self.screenWidth
                animationImage.center.x -= self.screenWidth
            }
            
        }){_ in
            animationImage.removeFromSuperview()
        }
    }
    
    
    // MARK: - 按钮功能
    @IBAction func showWeekConsumes(sender: AnyObject) {
        currentTimeModel = .Week
        
        self.moveTimeIndicatorAnimation(sender.center.x)
        self.changeChartsModelAnimation { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func showMonthConsumes(sender: AnyObject) {
        currentTimeModel = .Month
        
        self.moveTimeIndicatorAnimation(sender.center.x)
        self.changeChartsModelAnimation { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func showYearConsumes(sender: AnyObject) {
        currentTimeModel = .Year
        
        self.moveTimeIndicatorAnimation(sender.center.x)
        self.changeChartsModelAnimation { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    func prepareChartData() {
        self.chartVM.setConsumesForChart(currentTimeModel)
    }
    
    
    
    // Animation
    func moveTimeIndicatorAnimation(centerX: CGFloat) {
        UIView.animateWithDuration(0.75, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10.0, options: [.CurveEaseInOut], animations: {
            self.timeIndicatorView.center.x = centerX
            }, completion: nil)
    }
    
    func changeChartsModelAnimation(completion: () -> ()) {
        self.chartBGView.animation = "flipX"
        self.chartBGView.curve = "spring"
        self.chartBGView.duration = 1.0
        
        self.chartBGView.animateNext {
            completion()
        }
    }
    
    // MARK: - 创建环形图
    
    func prepareChartView() {
        // 创建环形图
        self.preparePieChart()
        // 创建七天消费柱状图
        self.prepareBarChart()
    }
    
    // 配置 创建环形图操作
    func preparePieChart() {
        // 创建环形图
        if self.chartVM.gainTotalExpense() == 0 {
            categoryChartView.data = nil
            categoryChartView.noDataText            = "尚未记录消费"
            categoryChartView.noDataTextDescription = ""
        }else {
            createPieChart(self.chartVM.gainCategoryNamesWithPie(), values: self.chartVM.gainCategoryRatioWithPie())
        }
        
        // 创建完图标后刷新数据
        categoryTableView.reloadData()
    }
    
    // 创建一个环形图
    private func createPieChart(dataPoints: [String], values: [Double]) {
        let dataEntries: [ChartDataEntry] = self.chartVM.createDataEntries(dataPoints.count, values: values)

        let pieChartDataSet = PieChartDataSet(yVals: dataEntries, label: "消费类别图")
        // 设置颜色
        pieChartDataSet.colors = self.chartVM.setColorWithPie()
        
        pieChartDataSet.selectionShift    = 6.0         // 设置环形图被选中部分的所突出的长度
        pieChartDataSet.sliceSpace        = 2.0         // 设置每个扇片之间的间隔
        pieChartDataSet.drawValuesEnabled = false       // 去掉图上的文字
        
        let pieChartData = PieChartData(xVals: dataPoints, dataSet: pieChartDataSet)
        
        categoryChartView.descriptionText = ""
        categoryChartView.data            = pieChartData
        categoryChartView.holeColor       = UIColor.clearColor()

        categoryChartView.usePercentValuesEnabled = true        // 使数乘100
        categoryChartView.rotationAngle           = 0.0
        categoryChartView.rotationEnabled         = true
        categoryChartView.drawHoleEnabled         = true

        categoryChartView.drawSliceTextEnabled    = false       // 去掉图上的文字
        categoryChartView.legend.enabled          = false       // 隐藏色彩说明
        
        categoryChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .EaseOutBack)
    }
    
    /**
     设置图表中心的文字
     
     - parameter text: 需要被设置的文字内容
     */
    func setCategoryChartCenterText(text: String) {
        categoryChartView.centerAttributedText = self.chartVM.setPieChartCenterText(text)
    }
    
    // MARK: - 创建 柱状图    
    func prepareBarChart() {
        if self.chartVM.consumesForBarChart.maxElement() == 0.0 {
            sevenDaysChartView.data = nil
            sevenDaysChartView.noDataText            = "尚未记录消费"
            sevenDaysChartView.noDataTextDescription = ""
        }else {
            switch currentTimeModel {
            case .Week:
                createBarChart(self.chartVM.weekdays, values: self.chartVM.consumesForBarChart)
            case .Month:
                createBarChart(self.chartVM.gainDaysWithMonth(), values: self.chartVM.consumesForBarChart)
            case .Year:
                createBarChart(self.chartVM.months, values: self.chartVM.consumesForBarChart)
            }
        }
    }
    
    // 创建七天消费柱状图
    private func createBarChart(dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(value: values[i], xIndex: i)
            dataEntries.append(dataEntry)
        }
        let barChartDataSet = self.chartVM.createBarChartDataSet("七天消费柱状图", dataEntries: dataEntries)
        // 设置每个柱之前的宽度比例
        barChartDataSet.barSpace = 0.35
        barChartDataSet.valueTextColor = UIColor.whiteColor()
        barChartDataSet.valueFont = UIFont.systemFontOfSize(11.0)
        
        sevenDaysChartView.data = BarChartData(xVals: dataPoints, dataSets: [barChartDataSet])

        sevenDaysChartView.descriptionText               = ""
        sevenDaysChartView.xAxis.labelPosition           = .Bottom
        sevenDaysChartView.xAxis.drawGridLinesEnabled    = false        // 除去图中的竖线
        sevenDaysChartView.xAxis.labelTextColor          = UIColor.whiteColor()
        sevenDaysChartView.leftAxis.drawGridLinesEnabled = false        // 除去图中的横线
        sevenDaysChartView.leftAxis.labelTextColor       = UIColor.whiteColor()
//        sevenDaysChartView.leftAxis.enabled              = false        // 隐藏左侧的坐标轴
        sevenDaysChartView.rightAxis.enabled             = false        // 隐藏右侧的坐标轴
        sevenDaysChartView.leftAxis.axisMinValue         = 0.0;         // 使柱状的和x坐标轴紧贴
        
        sevenDaysChartView.setVisibleXRangeMaximum(12)                  // 设置一个屏幕的最多柱状图的柱数
        
        sevenDaysChartView.setScaleEnabled(false)                       // 防止变大
        sevenDaysChartView.legend.enabled                = false        // 隐藏色彩说明
    }
    
}


// MARK: - TableView 数据源协议
extension ChartViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartVM.gainNumberOfSection()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: FinanceOfCategoryTableViewCell = tableView.dequeueReusableCellWithIdentifier("FinanceCategoryCell") as! FinanceOfCategoryTableViewCell
        
        cell.prepareCollectionCellForChartView(self.chartVM.gainFinanceCategoryAt(indexPath.row))
        
        return cell;
    }
}

// MARK: - TableView 操作协议
extension ChartViewController: UITableViewDelegate {
   
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // 使对应的环形图中的那个扇片高亮， 如果已经高亮就将其恢复常态
        let highlighteds = self.categoryChartView.highlighted
        
        if !highlighteds.isEmpty && highlighteds.first?.xIndex == indexPath.row {
            self.setCategoryChartCenterText("")
            self.categoryChartView.highlightValue(highlight: nil, callDelegate: false)
        }else {
            self.categoryChartView.highlightValue(xIndex: indexPath.row, dataSetIndex: 0, callDelegate: true)            
        }
        
    }
}


// MARK: - （Chart）图形中选择每个元素后的 Delegate
extension ChartViewController: ChartViewDelegate {
    
    // 当 有元素被选中了
    func chartValueSelected(chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: ChartHighlight) {
        if chartView == categoryChartView {
            
            // 设置扇形的中心文字
            self.setCategoryChartCenterText("\((entry.value * 100).convertToStrWithTwoFractionDigits())%")
            
            // 设置 tableView 中 对应的那一行被选中，如果已经被选中就不需要执行选中操作
            let indexpath = NSIndexPath(forRow: entry.xIndex, inSection: 0)
            let cell = self.categoryTableView.cellForRowAtIndexPath(indexpath)            
            
            if ((cell?.selected) != nil) {
                self.categoryTableView.selectRowAtIndexPath(NSIndexPath(forRow: entry.xIndex, inSection: 0), animated: false, scrollPosition: .Middle)
            }
            
        }else if chartView == sevenDaysChartView {
//            print("sevenDaysChartView: \(entry) + \(dataSetIndex) + \(highlight)")
        }
    }
    
    
    func chartValueNothingSelected(chartView: ChartViewBase) {
        if chartView == categoryChartView {
            self.setCategoryChartCenterText("")
            
            // 取消所有 cell  的选中状态
            guard let indexPath = self.categoryTableView.indexPathForSelectedRow else {
                return
            }
            
            self.categoryTableView.deselectRowAtIndexPath(indexPath, animated: true)
        }
    }
}




// MARK: - DZNEmptyDataSetSource 数据源协议
extension ChartViewController: DZNEmptyDataSetSource {
    // 设置图片
    func imageForEmptyDataSet(scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "NoMoney")
    }
    
    func imageAnimationForEmptyDataSet(scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue  = 0.0
        animation.toValue    = 1.0
        animation.duration   = 1.0
        
        return animation
    }
}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension ChartViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(scrollView: UIScrollView!) -> Bool {
        return true
    }
}





