//
//  StatsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 1.04.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class StatsViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var tableToChartSC: UISegmentedControl!
    @IBOutlet weak var staticsView: UIView!
    @IBOutlet weak var chartsView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableToChartSC.selectedSegmentIndex = 0
        staticsView.alpha = 1
        chartsView.alpha = 0
    }
    
    func setScrollView() {
        self.scrollView.contentSize = CGSize(width: scrollView.bounds.width*2, height: scrollView.bounds.height)
    }

    @IBAction func changeView(_ sender: UISegmentedControl) {
        
    }
    
}
