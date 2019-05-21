//
//  OnboardViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import FirebaseAuth

class OnboardViewController: BaseOnboardViewController {

    @IBOutlet weak var loginButton: CubeTimerButton!
    @IBOutlet weak var registerButton: CubeTimerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loginButton.initUI(with: .dark)
        self.registerButton.initUI(with: .dark)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if Auth.auth().currentUser != nil {
            self.directMainPage()
        }
    }
    
}


