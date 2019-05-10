//
//  BaseStatsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class BaseStatsViewController: CubeTimerBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
       
        if sender.selectedSegmentIndex == 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 1.0, y: 0.0), animated: true)
        } else {
             self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.0, y: 0.0), animated: true)
        }
    }
    
}
