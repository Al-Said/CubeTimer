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
    @IBOutlet weak var changeViewSegmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initSegmentedControl()
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
       
        if sender.selectedSegmentIndex == 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 1.0, y: 0.0), animated: true)
        } else {
             self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.0, y: 0.0), animated: true)
        }
    }
    
    func initSegmentedControl() {
        if self.theme == .dark {
            self.changeViewSegmentedControl.tintColor = .white
        } else {
            self.changeViewSegmentedControl.tintColor = .black
        }
    }
    
}
