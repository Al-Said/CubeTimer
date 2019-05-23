//
//  UserData.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation

struct UserProfile {
    
    var name: String
    var surname: String
    var email: String
    var created: Double
    var createdSessions = 1
    var bestSession = 1
    var totalAvg: Double = 0.0
    var pb: Double = -1.0
    var bestAvg5: Double = -1.0
    var bestAvg12: Double = -1.0
    var bestAvg100: Double = -1.0
    var totalDuration: Double = 0.0
    var totalSolves: Double = 0.0
}
