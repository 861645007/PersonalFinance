//
//  ViewController.swift
//  PersonalFinance
//
//  Created by ziye on 16/1/27.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Timepiece

class ViewController: UIViewController {
    
    var mainVM: MainViewModel! = MainViewModel()
    
    // 水波纹 本月消费 示意图
    @IBOutlet weak var waterWaveView: TYWaveProgressView!
    
    @IBOutlet weak var todayExpenseLabel: UILabel!
    @IBOutlet weak var monthExpenseLabel: UILabel!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // 设置导航栏透明
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: .Default);
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        self.todayExpenseLabel.text = "今日消费：￥\(mainVM.gainDayExpense().convertToStrWithTwoFractionDigits())"
        self.monthExpenseLabel.text = "本月消费：￥\(mainVM.gainMonthExpense().convertToStrWithTwoFractionDigits())"
        
        // 配置水波纹数据
        self.configureWaveProgress(mainVM.gainMonthExpense(), percent: self.mainVM.configureWavePercent())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        // 每次进入主页面的时候，重新加载水波图
        self.waterWaveView.startWave()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // 修改导航栏返回键的文字
        let backItem: UIBarButtonItem = UIBarButtonItem(title: "返回", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backItem
    }
    
    
    
    // 配置波浪小球
    func configureWaveProgress(number: Double, percent: CGFloat) {
        waterWaveView.waveViewMargin = UIEdgeInsetsMake(10, 10, 10, 10)
        waterWaveView.backgroundImageView?.image = UIImage(named: "bg_tk")
        
        // 设置 现实的数值
        waterWaveView.numberLabel?.text = "\(Int(percent * 100))"
        waterWaveView.numberLabel?.font = UIFont.systemFontOfSize(55)
        waterWaveView.numberLabel.textColor = UIColor.whiteColor()

        // 设置 %
        waterWaveView.unitLabel.text = "%"
        waterWaveView.unitLabel.font = UIFont(name: "systemFont", size: 18.0)
        waterWaveView.unitLabel.textColor = UIColor.whiteColor()
        
        // 设置 显示的条目
        waterWaveView.explainLabel?.text = "已消费:￥\(number)"
        waterWaveView.explainLabel.font = UIFont.boldSystemFontOfSize(20.0)
        waterWaveView.explainLabel?.textColor = UIColor.whiteColor()
        
        // 设置 百分比
        waterWaveView.percent = percent
        
        // 开始波浪波动
        waterWaveView.startWave()
    }
}

