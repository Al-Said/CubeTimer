//
//  AverageCalculator.swift
//  CubeTimer
//
//  Created by Said Alır on 21.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation

class AverageCalculator {
    
    static let shared = AverageCalculator()
    
    func getAvgOf(durations: [Double]) -> Double {
        
        if durations.count < 5 {
            return 0.0
        }
        
        var min = 0.0
        var max = 0.0
        
        for i in 0 ..< durations.count {
            
            if min == 0.0 || min > durations[i] {
                min = durations[i]
            }
            
            if max == 0.0 || max < durations[i] {
                max = durations[i]
            }
        }
        
        var list = durations
        list = removeElement(arr: list, element: min)
        list = removeElement(arr: list, element: max)
        var avg = 0.0
        for l in list  {
            avg += l
        }
        
        return avg / Double(list.count)
    }
    
    func removeElement(arr: [Double], element: Double) -> [Double] {

        if !arr.contains(element) {
            return arr
        } else {
            var index = 0
            for i in 0..<arr.count {
                if arr[i] == element {
                    index = i
                }
            }
            var list = arr
            list.remove(at: index)
            return list
        }
    }
}
