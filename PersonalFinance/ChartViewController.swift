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
import SwiftDate

class ChartViewController: UIViewController {

    // UIScrollView 约束
//    @IBOutlet weak var scrollVIewHeigh: NSLayoutConstraint!
    
    // MARK: - 实例变量
    
    // 普通实例变量
    let chartVM: ChartViewModel = ChartViewModel()
    var currentTimeModel: ChartTimeModel = .week
    
    // 控制视图 实例变量
    
    @IBOutlet weak var showWeekConsumesBtn: DesignableButton!
    @IBOutlet weak var showMonthConsumesBtn: DesignableButton!    
    @IBOutlet weak var showYearConsumesBtn: DesignableButton!
    
    @IBOutlet weak var todayTimeLabel: UILabel!
    
    @IBOutlet weak var timeIndicatorView: UIView!
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    @IBOutlet weak var chartBGView: SpringView!
    // 饼图部分
    @IBOutlet weak var categoryChartView: PieChartView!
    
    // 走势图部分：以一个月的四周作为走势图
    @IBOutlet weak var sevenDaysChartView: BarChartView!
    
    // 以一年的12个月作为走势图
    @IBOutlet weak var thirdWeeksChartView: LineChartView!
    
    
    let screenWidth = UIScreen.main.bounds.width
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryChartView.delegate = self
        sevenDaysChartView.delegate = self
        
        // 修改导航栏返回键的文字
        self.setNavigationBackItemBlank()
        
        // 去除 tableView 多余的分割线
        self.categoryTableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.prepareChartView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch currentTimeModel {
        case .week:
            self.moveTimeIndicatorAnimation(self.showWeekConsumesBtn.center.x)
        case .month:
            self.moveTimeIndicatorAnimation(self.showMonthConsumesBtn.center.x)
        case .year:
            self.moveTimeIndicatorAnimation(self.showYearConsumesBtn.center.x)
        }
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
    @IBAction func rightSwipe(_ sender: AnyObject) {
        switch currentTimeModel {
        case .week:
            self.chartVM.setWeekToPre()
        case .month:
            self.chartVM.setMonthToPre()
        case .year:
            self.chartVM.setYearToPre()
        }
        
        self.swipeAnimation(true) { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func leftSwipe(_ sender: AnyObject) {
        switch currentTimeModel {
        case .week:
            self.chartVM.setWeekToNext()
        case .month:
            self.chartVM.setMonthToNext()
        case .year:
            self.chartVM.setYearToNext()
        }
        
        self.swipeAnimation(false) { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    // 滑动动画
    func swipeAnimation(_ isRight: Bool, completion: () -> ()) {
        // 创建一个 MainView 的截屏图片 作为假假面，再把真的图层移除界面，再做成一个动画
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
        
        UIImageView.animate(withDuration: 1.0, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [.curveEaseInOut], animations: { [unowned self] in
            
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
    @IBAction func showWeekConsumes(_ sender: AnyObject) {
        currentTimeModel = .week
        
        self.categoryChartView.highlightValue(nil, callDelegate: true)
        
        self.moveTimeIndicatorAnimation(sender.center.x)
        self.changeChartsModelAnimation { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func showMonthConsumes(_ sender: AnyObject) {
        currentTimeModel = .month
        
        self.categoryChartView.highlightValue(nil, callDelegate: true)
        
        self.moveTimeIndicatorAnimation(sender.center.x)
        self.changeChartsModelAnimation { [unowned self] in
            self.prepareChartData()
            self.prepareChartView()
        }
    }
    
    
    @IBAction func showYearConsumes(_ sender: AnyObject) {
        currentTimeModel = .year
        
        self.categoryChartView.highlightValue(nil, callDelegate: true)
        
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
    func moveTimeIndicatorAnimation(_ centerX: CGFloat) {
        UIView.animate(withDuration: 0.75, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 10.0, options: UIViewAnimationOptions(), animations: {
            self.timeIndicatorView.center.x = centerX
            }, completion: nil)
    }
    
    func changeChartsModelAnimation(_ completion: () -> ()) {
        
        // 创建一个 MainView 的截屏图片 作为假的主视图
        let animationImage = UIImageView(frame: self.chartBGView.frame)
        animationImage.image = self.chartBGView.snapshot()
        self.view.addSubview(animationImage)
        
        // 执行操作形成真实数据的MainView
        completion()
        
//        UIView.transitionFromView(animationImage,
//                                  toView: self.chartBGView,
//                                  duration: 1.0,
//                                  options: [.TransitionFlipFromLeft, .CurveEaseInOut]) { _ in
//                                    animationImage.removeFromSuperview()
//        }
        UIView.transition(from: animationImage,
                                  to: self.chartBGView,
                                  duration: 1.0,
                                  options: [.transitionCurlUp, .curveEaseInOut]) { _ in
                                    animationImage.removeFromSuperview()
        }
        
    }
    
    // MARK: - 创建环形图
    
    func prepareChartView() {
        self.todayTimeLabel.text = self.chartVM.setCurrentTime(currentTimeModel)
        
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
//            categoryChartView.noDataTextDescription = ""
        }else {
            createPieChart(self.chartVM.gainCategoryNamesWithPie(), values: self.chartVM.gainCategoryRatioWithPie())
        }
        
        // 创建完图标后刷新数据
        categoryTableView.reloadData()
    }
    
    // 创建一个环形图
    fileprivate func createPieChart(_ dataPoints: [String], values: [Double]) {
        let dataEntries: [ChartDataEntry] = self.chartVM.createDataEntries(dataPoints.count, values: values)

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "消费类别图")
        // 设置颜色
        pieChartDataSet.colors = self.chartVM.setColorWithPie()
        
        pieChartDataSet.selectionShift    = 6.0         // 设置环形图被选中部分的所突出的长度
        pieChartDataSet.sliceSpace        = 2.0         // 设置每个扇片之间的间隔
        pieChartDataSet.drawValuesEnabled = false       // 去掉图上的文字
        
       
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        
//        categoryChartView.descriptionText = ""
        categoryChartView.data            = pieChartData
        categoryChartView.holeColor       = UIColor.clear

        categoryChartView.usePercentValuesEnabled = true        // 使数乘100
        categoryChartView.rotationAngle           = 0.0
        categoryChartView.rotationEnabled         = true
        categoryChartView.drawHoleEnabled         = true

        categoryChartView.drawEntryLabelsEnabled    = false       // 去掉图上的文字
        categoryChartView.legend.enabled          = false       // 隐藏色彩说明
        
        categoryChartView.animate(xAxisDuration: 1.5, yAxisDuration: 1.5, easingOption: .easeOutBack)
    }
    
    /**
     设置图表中心的文字
     
     - parameter text: 需要被设置的文字内容
     */
    func setCategoryChartCenterText(_ text: String) {
        categoryChartView.centerAttributedText = self.chartVM.setPieChartCenterText(text)
    }
    
    // MARK: - 创建 柱状图    
    func prepareBarChart() {
        if self.chartVM.consumesForBarChart.max() == 0.0 {
            sevenDaysChartView.data = nil
            sevenDaysChartView.noDataText            = "尚未记录消费"
//            sevenDaysChartView.noDataTextDescription = ""
        }else {
            switch currentTimeModel {
            case .week:
                createBarChart(self.chartVM.weekdays, values: self.chartVM.consumesForBarChart)
            case .month:
                createBarChart(self.chartVM.gainDaysWithMonth(), values: self.chartVM.consumesForBarChart)
            case .year:
                createBarChart(self.chartVM.months, values: self.chartVM.consumesForBarChart)
            }
        }
    }
    
    // 创建七天消费柱状图
    fileprivate func createBarChart(_ dataPoints: [String], values: [Double]) {
        var dataEntries: [BarChartDataEntry] = []
        
        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: values[i], y: Double(i))
            dataEntries.append(dataEntry)
        }
        let barChartDataSet = self.chartVM.createBarChartDataSet("七天消费柱状图", dataEntries: dataEntries)
        // 设置每个柱之前的宽度比例
        barChartDataSet.valueTextColor = UIColor.white
        barChartDataSet.valueFont = UIFont.systemFont(ofSize: 11.0)
        
        let barCharData = BarChartData(dataSets: [barChartDataSet])
        barCharData.barWidth = 0.45                        // 设置每个柱之前的宽度比例
        barCharData.highlightEnabled = false               // 设置Bar选中之后不再高亮
        sevenDaysChartView.data = barCharData
        
        sevenDaysChartView.chartDescription?.text        = ""
        sevenDaysChartView.xAxis.labelPosition           = .bottom
        sevenDaysChartView.xAxis.drawGridLinesEnabled    = false        // 除去图中的竖线
        sevenDaysChartView.xAxis.labelTextColor          = UIColor.white
        sevenDaysChartView.leftAxis.drawGridLinesEnabled = false        // 除去图中的横线
        sevenDaysChartView.leftAxis.labelTextColor       = UIColor.white
//        sevenDaysChartView.leftAxis.enabled              = false        // 隐藏左侧的坐标轴
        sevenDaysChartView.rightAxis.enabled             = false        // 隐藏右侧的坐标轴
        sevenDaysChartView.leftAxis.axisMinimum         = 0.0;         // 使柱状的和x坐标轴紧贴
        
        sevenDaysChartView.fitScreen()
        sevenDaysChartView.setVisibleXRangeMaximum(15)                  // 设置一个屏幕的最多柱状图的柱数
        
        sevenDaysChartView.setScaleEnabled(false)                       // 防止变大
        sevenDaysChartView.legend.enabled                = false        // 隐藏色彩说明
    }
    
    
    // 点击柱状图 跳转到相应的详细页面
    fileprivate func showDetailViewWithBar(_ day: Date, isMonth: Bool) {
        let detailView: UIViewController
        
        if isMonth {
            detailView = self.storyboard?.instantiateViewController(withIdentifier: "MonthConsumeViewController") as! MonthConsumeViewController
            (detailView as! MonthConsumeViewController).monthConsumeVM = MonthConsumeViewModel(state: .month, today: day)
            detailView.title = "\(day.year)年\(day.month)月"
        }else {
            detailView = self.storyboard?.instantiateViewController(withIdentifier: "DayConsumeViewController") as! DayConsumeViewController
            detailView.title = "\(day.month)月\(day.day)日"
            (detailView as! DayConsumeViewController).dayConsumeVM = DayConsumeViewModel(today: day)
        }
        
        self.navigationController?.pushViewController(detailView, animated: true)
    }
}


// MARK: - TableView 数据源协议
extension ChartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.chartVM.gainNumberOfSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: FinanceOfCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: "FinanceCategoryCell") as! FinanceOfCategoryTableViewCell
        
        cell.prepareCollectionCellForChartView(self.chartVM.gainFinanceCategoryAt(indexPath.row))
        
        return cell;
    }
}

// MARK: - TableView 操作协议
extension ChartViewController: UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // 使对应的环形图中的那个扇片高亮， 如果已经高亮就将其恢复常态
        let highlighteds = self.categoryChartView.highlighted
        
        
        
        if !highlighteds.isEmpty && Int((highlighteds.first?.y)!) == indexPath.row {
            self.setCategoryChartCenterText("")
            self.categoryChartView.highlightValue(nil, callDelegate: false)
        }else {
            // 设置扇形的中心文字
            
            self.setCategoryChartCenterText("\((self.chartVM.gainFinanceCategoryAt(indexPath.row).categoryRatio * 100).convertToStrWithTwoFractionDigits())%")
            self.categoryChartView.highlightValue(x: Double(indexPath.row), dataSetIndex: 0, callDelegate: true)
        }
        
    }
}


// MARK: - （Chart）图形中选择每个元素后的 Delegate
extension ChartViewController: ChartViewDelegate {
    
    // 当 有元素被选中了
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, dataSetIndex: Int, highlight: Highlight) {
        if chartView == categoryChartView {            
            // 设置扇形的中心文字
            self.setCategoryChartCenterText("\((entry.x * 100).convertToStrWithTwoFractionDigits())%")
            
            // 设置 tableView 中 对应的那一行被选中，如果已经被选中就不需要执行选中操作
            let indexpath = IndexPath(row: Int(entry.y), section: 0)
            let cell = self.categoryTableView.cellForRow(at: indexpath)
            
            if cell == nil {
                self.categoryTableView.scrollToRow(at: indexpath, at: .middle, animated: true)
            }else {
                if !cell!.isSelected {
                    self.categoryTableView.selectRow(at: IndexPath(row: Int(entry.y), section: 0), animated: false, scrollPosition: .middle)
                }
            }
        }else if chartView == sevenDaysChartView {
            
            if entry.x == 0.0 {
                return
            }
            
            switch currentTimeModel {
            case .week:
                self.showDetailViewWithBar(self.chartVM.currentWeek + (Int(entry.y)).days, isMonth: false)
            case .month:
                self.showDetailViewWithBar(self.chartVM.currentMonth + (Int(entry.y)).days, isMonth: false)
            case .year:
                self.showDetailViewWithBar(self.chartVM.currentYear + (Int(entry.y)).months, isMonth: true)
            }
        }
    }
    
    
    func chartValueNothingSelected(_ chartView: ChartViewBase) {
        if chartView == categoryChartView {
            self.setCategoryChartCenterText("")
            
            // 取消所有 cell  的选中状态
            guard let indexPath = self.categoryTableView.indexPathForSelectedRow else {
                return
            }
            
            self.categoryTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}


extension ChartViewController: UIScrollViewDelegate {
    
    // 在点击扇形的高亮的后，如果是非可见cell，我们要先把cell滑动出来后再处理 cell 的选择（在滑动动画结束之后操作）
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = self.categoryChartView.highlighted.first!.y
        
        let indexpath = IndexPath(row: Int(index), section: 0)
        
        let cell = self.categoryTableView.cellForRow(at: indexpath)
        
        if !cell!.isSelected {
            self.categoryTableView.selectRow(at: IndexPath(row: Int(index), section: 0), animated: false, scrollPosition: .middle)
        }
    }
}




// MARK: - DZNEmptyDataSetSource 数据源协议
extension ChartViewController: DZNEmptyDataSetSource {
    // 设置图片
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "NoMoney")
    }
    
    func imageAnimation(forEmptyDataSet scrollView: UIScrollView!) -> CAAnimation! {
        let animation = CABasicAnimation(keyPath: "opacity")
        
        animation.fromValue  = 0.0
        animation.toValue    = 1.0
        animation.duration   = 1.0
        
        return animation
    }
}

// MARK: - DZNEmptyDataSetDelegate 操作协议
extension ChartViewController: DZNEmptyDataSetDelegate {
    func emptyDataSetShouldAnimateImageView(_ scrollView: UIScrollView!) -> Bool {
        return true
    }
}





