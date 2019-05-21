//
//  AuthManager.swift
//  CubeTimer
//
//  Created by Rapsodo-Mobil-2 on 17.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthManager {
    
    static let shared = AuthManager()
    
    var uid: String?
    
    func getUID() -> String {
        if let id = self.uid {
            return id
        } else {
            self.uid = Auth.auth().currentUser!.uid
            return uid!
        }
    }
    
    func logout() {
        self.uid = nil
    }
}

