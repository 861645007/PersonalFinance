//
//  AboutSelfViewController.swift
//  PersonalFinance
//
//  Created by 子叶 on 16/5/25.
//  Copyright © 2016年 王焕强. All rights reserved.
//

import UIKit

class AboutSelfViewController: UIViewController {
    
    @IBOutlet weak var appIconImageView: UIImageView!
    
    @IBOutlet weak var versionLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "关于App"
        
        appIconImageView.layer.masksToBounds = true
        appIconImageView.layer.cornerRadius  = 28.0
        
        versionLabel.text = "v " + "\(Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String)"
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
