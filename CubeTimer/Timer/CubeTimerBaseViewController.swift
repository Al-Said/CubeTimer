//
//  CubeTimerBaseViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class CubeTimerBaseViewController: UIViewController {

    var toSaveDB = false
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toSaveDb = UserDefaults.standard.bool(forKey: "toSaveDb")
    }
}
