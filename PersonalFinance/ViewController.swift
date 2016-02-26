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
    
    var mainVM: MainViewModel!
    
    // 水波纹 本月消费 示意图
    var waterWaveView: TYWaveProgressView!
    @IBOutlet weak var waterBGView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mainVM = MainViewModel()
        
        // 配置水波纹数据
        self.configureWaveProgress(mainVM.gainMonthExpense(), percent: mainVM.configureWavePercent())
        waterBGView.addSubview(waterWaveView)       
    }
    
    override func viewDidAppear(animated: Bool) {
        // 每次进入主页面的时候，重新加载水波图
        self.waterWaveView.startWave()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    // 配置波浪小球
    func configureWaveProgress(number: Double, percent: CGFloat) {
        waterWaveView = TYWaveProgressView(frame: CGRectMake(0, 0, 180, 180))
        waterWaveView.waveViewMargin = UIEdgeInsetsMake(10, 10, 10, 10)
        waterWaveView.backgroundImageView?.image = UIImage(named: "bg_tk_003")
        
        // 设置 现实的数值
        waterWaveView.numberLabel?.text = "\(number)"
        waterWaveView.numberLabel?.textColor = UIColor.whiteColor()

        // 设置 %
        waterWaveView.unitLabel?.text = "%"
        waterWaveView.unitLabel?.textColor = UIColor.whiteColor()
        
        // 设置 显示的条目
        waterWaveView.explainLabel?.text = "已消费"
        waterWaveView.explainLabel?.textColor = UIColor.whiteColor()
        
        // 设置 百分比
        waterWaveView.percent = percent
        
        // 开始波浪波动
        waterWaveView.startWave()
    }
}

