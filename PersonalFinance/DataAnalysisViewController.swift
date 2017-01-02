//
//  DataAnalysisViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/5/30.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit
import Spring
import MBCircularProgressBar



class DataAnalysisViewController: UIViewController {
    
    let dataAnalysusVM = DataAnalysisViewModel()
    
    
    // MARK: - 控件
    
    // 约束控制
    @IBOutlet weak var bgViewHight: NSLayoutConstraint!
    @IBOutlet weak var quarterCategoryViewHight: NSLayoutConstraint!
    
    @IBOutlet weak var mainScrollView: UIScrollView!
    
    // 季度概览部分
    @IBOutlet weak var firstMonthLabel: UILabel!
    @IBOutlet weak var secondMonthLabel: UILabel!
    @IBOutlet weak var thirdMonthLabel: UILabel!
    
    @IBOutlet weak var firstMonthExpenseLabel: UILabel!
    @IBOutlet weak var secondMonthExpenseLabel: UILabel!
    @IBOutlet weak var thirdMonthExpenseLabel: UILabel!
    
    // 本季度消费 Top3
    
    @IBOutlet weak var firstMonthCategoryView: UIView!
    @IBOutlet weak var firstMonthCategoryImageView: UIImageView!
    @IBOutlet weak var firstMonthCategoryProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var firstMonthCategoryNameLabel: UILabel!
    @IBOutlet weak var firstMonthCategoryDescribeLabel: UILabel!
    @IBOutlet weak var firstMonthSplitView: DesignableView!
    
    @IBOutlet weak var secondMonthCategoryView: UIView!
    @IBOutlet weak var secondMonthCategoryImageView: UIImageView!
    @IBOutlet weak var secondMonthCategoryProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var secondMonthCategoryNameLabel: UILabel!
    @IBOutlet weak var secondMonthCategoryDescribeLabel: UILabel!
    @IBOutlet weak var secondMonthSplitView: DesignableView!
    
    @IBOutlet weak var thirdMonthCategoryView: UIView!
    @IBOutlet weak var thirdMonthCategoryImageView: UIImageView!
    @IBOutlet weak var thirdMonthCategoryProgressBar: MBCircularProgressBarView!
    @IBOutlet weak var thirdMonthCategoryNameLabel: UILabel!
    @IBOutlet weak var thirdMonthCategoryDescribeLabel: UILabel!
    
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        if self.dataAnalysusVM.quarterCategorysTop3.count == 1 {
            bgViewHight.constant -= firstMonthCategoryView.frame.height * 2
            quarterCategoryViewHight.constant = firstMonthCategoryView.frame.height
        }else if self.dataAnalysusVM.quarterCategorysTop3.count == 2 {
            bgViewHight.constant -= firstMonthCategoryView.frame.height
            quarterCategoryViewHight.constant = firstMonthCategoryView.frame.height * 2
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.mainScrollView.showsVerticalScrollIndicator = false
        self.mainScrollView.alwaysBounceVertical = true
        
        
        self.setQuarterOverviewView()
        self.setQuarterExpenseTop3()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setQuarterOverviewView() {
        firstMonthLabel.text = self.dataAnalysusVM.quarterOverviewInfo[0].0
        firstMonthExpenseLabel.text = self.dataAnalysusVM.quarterOverviewInfo[0].1
        
        secondMonthLabel.text = self.dataAnalysusVM.quarterOverviewInfo[1].0
        secondMonthExpenseLabel.text = self.dataAnalysusVM.quarterOverviewInfo[1].1
        
        thirdMonthLabel.text = self.dataAnalysusVM.quarterOverviewInfo[2].0
        thirdMonthExpenseLabel.text = self.dataAnalysusVM.quarterOverviewInfo[2].1
    }
    
    func setQuarterExpenseTop3() {
        firstMonthCategoryImageView.image   = self.dataAnalysusVM.quarterCategorysTop3[0].categoryIcon
        firstMonthCategoryNameLabel.text     = self.dataAnalysusVM.quarterCategorysTop3[0].categoryName
        firstMonthCategoryDescribeLabel.text = self.dataAnalysusVM.quarterCategorysTop3[0].categoryDescribe
        self.dataAnalysusVM.quarterCategorysTop3[0].categoryIcon.getColors({[unowned self] (colors) in
            self.firstMonthCategoryProgressBar.progressColor = colors.primaryColor
            self.firstMonthCategoryProgressBar.progressStrokeColor = colors.primaryColor
            self.firstMonthCategoryProgressBar.setValue(CGFloat(self.dataAnalysusVM.quarterCategorysTop3[0].categoryProgressValue), animateWithDuration: 1.5)
            })
        
        
        if self.dataAnalysusVM.quarterCategorysTop3.count > 1 {
            secondMonthCategoryImageView.image = self.dataAnalysusVM.quarterCategorysTop3[1].categoryIcon
            secondMonthCategoryNameLabel.text = self.dataAnalysusVM.quarterCategorysTop3[1].categoryName
            secondMonthCategoryDescribeLabel.text = self.dataAnalysusVM.quarterCategorysTop3[1].categoryDescribe
            self.dataAnalysusVM.quarterCategorysTop3[1].categoryIcon.getColors({[unowned self] (colors) in
                self.secondMonthCategoryProgressBar.progressColor = colors.primaryColor
                self.secondMonthCategoryProgressBar.progressStrokeColor = colors.primaryColor
                self.secondMonthCategoryProgressBar.setValue(CGFloat(self.dataAnalysusVM.quarterCategorysTop3[1].categoryProgressValue), animateWithDuration: 1.5)
                })
            
            if self.dataAnalysusVM.quarterCategorysTop3.count >= 3 {
                thirdMonthCategoryImageView.image = self.dataAnalysusVM.quarterCategorysTop3[2].categoryIcon
                thirdMonthCategoryNameLabel.text = self.dataAnalysusVM.quarterCategorysTop3[2].categoryName
                thirdMonthCategoryDescribeLabel.text = self.dataAnalysusVM.quarterCategorysTop3[2].categoryDescribe
                
                self.dataAnalysusVM.quarterCategorysTop3[2].categoryIcon.getColors({[unowned self] (colors) in
                    self.thirdMonthCategoryProgressBar.progressColor = colors.primaryColor
                    self.thirdMonthCategoryProgressBar.progressStrokeColor = colors.primaryColor
                    self.thirdMonthCategoryProgressBar.setValue(CGFloat(self.dataAnalysusVM.quarterCategorysTop3[2].categoryProgressValue), animateWithDuration: 1.5)
                    })
                
            }else {
                thirdMonthCategoryView.isHidden = true
                secondMonthSplitView.hidden = true
            }
        }else {
            thirdMonthCategoryView.isHidden = true
            secondMonthSplitView.hidden = true
            secondMonthCategoryView.isHidden = true
            firstMonthSplitView.hidden = true
        }
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
