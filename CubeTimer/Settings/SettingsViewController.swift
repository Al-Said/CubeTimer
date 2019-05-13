//
//  SettingsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class SettingsViewController: CubeTimerBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveToDatabaseAction(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(true, forKey: "toSaveDb")
        } else {
            UserDefaults.standard.set(false, forKey: "toSaveDb")
        }
        
    }
    
}
