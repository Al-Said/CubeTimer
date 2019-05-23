//
//  LineChartValueFormatter.swift
//  CubeTimer
//
//  Created by Said Alır on 20.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import Charts

class LineChartValueFormatter: NSObject, IAxisValueFormatter {
    
    var valueArray: [String]
    
    init(valueArray: [String]) {
        self.valueArray = valueArray
        super.init()
    }
    
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        
        if self.valueArray.count == 0 {
            return ""
        }
        if value < 0.0 {
            return valueArray[0]
        }
        
        if value > Double(valueArray.count) - 1.0 {
            return valueArray[valueArray.count - 1]
        }
        
        return valueArray[Int(value)]
    }
    
}
