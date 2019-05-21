//
//  UserData.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation

struct User {
    var name: String
    var surname: String
    var email: String
    var password: String
}

struct Profile {
    var name: String
    var surname: String
    var createdSessions: Int
    var bestSession: Int
    var totalAvg: Double
    var bestOfFive: Double
    var bestOfTwelve: Double
}
