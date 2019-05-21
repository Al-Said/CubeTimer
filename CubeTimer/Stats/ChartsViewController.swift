//
//  ChartsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import Charts

class ChartsViewController: BaseStatsViewController {

    @IBOutlet weak var lineChartView: LineChartView!
    var xAxisValues = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.fetchDataFromDB {
            self.data.reverse()
            self.initDataSet()
            self.initLineChartUI()
        }
    }
    
    func initDataSet() {
        let values = initValues()
        let set = initLineChartDataSet(values: values)
        let data = LineChartData(dataSet: set)
        self.lineChartView.data = data
    }
    
    func initLineChartDataSet(values: [ChartDataEntry]) -> LineChartDataSet {
        let set = LineChartDataSet(values: values, label: "Duration")
        set.colors = [NSUIColor.blue]
        set.mode = .cubicBezier
        set.circleRadius = CGFloat(3.0)
        set.circleColors = [NSUIColor.red]
        set.drawFilledEnabled = true
        set.drawCircleHoleEnabled = false
        set.drawVerticalHighlightIndicatorEnabled = false
        set.fillColor = NSUIColor(red: 25/255, green: 48/255, blue: 112/255, alpha: 1.0)
        set.fillAlpha = 0.9
        return set
    }
    
    func initLineChartUI() {
        self.lineChartView.backgroundColor = .white
        self.lineChartView.xAxis.labelPosition = .bottom
        self.lineChartView.rightAxis.enabled = false
        self.lineChartView.xAxis.drawGridLinesEnabled = false
        self.lineChartView.scaleYEnabled = false
        self.lineChartView.drawGridBackgroundEnabled = false
        self.lineChartView.xAxis.valueFormatter = LineChartValueFormatter(valueArray: xAxisValues)
        self.lineChartView.xAxis.avoidFirstLastClippingEnabled = true
        self.lineChartView.xAxis.labelRotationAngle = CGFloat(45.0)
        self.lineChartView.xAxis.labelFont = UIFont(name: "Arial", size: 5.0)!
    }
    
    func initValues() -> [ChartDataEntry] {
        var values = [ChartDataEntry]()
        for i in 0 ..< data.count {
            let val = data[i].duration
            let cre = data[i].created
            let value = ChartDataEntry(x: Double(i), y: val)
            self.xAxisValues.append(String(TimeConverter.shared.createdToStr(cre).dropFirst(5)))
            values.append(value)
        }
        return values
    }

}

