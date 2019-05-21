//
//  TimeConverter.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation

class TimeConverter {
    
    static var shared = TimeConverter()
    
    func durationToStr(_ duration: Double) -> String {
        
        var time = duration
        var timeStr = ""
        
        let minutes = Int(time/60.0)
        time -= TimeInterval(minutes) * 60
        
        let seconds = Int(time)
        
        time -= TimeInterval(seconds)
        
        let fraction = Int(time * 1000)
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%03", fraction)
        
        if strMinutes == "00" {
            timeStr = "\(strSeconds).\(strFraction)"
        } else {
            timeStr = "\(strMinutes):\(strSeconds).\(strFraction)"
        }
        return timeStr
    }
    
    func createdToStr(_ created: Double) -> String {
        
        let formatter = DateFormatter()
        let date = Date(timeIntervalSinceReferenceDate: created)
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.string(from: date)
    }
    
    func strToDuration(_ string: String) -> Double {
        
        if string.contains(":") {
            let duration = string.split(separator: ":", maxSplits: 1, omittingEmptySubsequences: true)
            let min = Double(duration[0])! * 60
            let miliSeconds = Double(duration[1])!
            return min + miliSeconds
        } else {
            return Double(string)!
        }
    }
}
