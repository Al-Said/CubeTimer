//
//  SettingsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class SettingsViewController: CubeTimerBaseViewController {

    @IBOutlet weak var themeSwitch: UISwitch!
    @IBOutlet weak var themeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initUI()
        setInitialValues()
    }
    
    func initUI() {
        self.themeLabel.initLabel(with: self.theme)
    }
    
    func setInitialValues() {
        if self.theme == .light {
            themeSwitch.isOn = true
            self.themeLabel.text = "Light Theme"
        }
    }
    
    @IBAction func changeThemeAction(_ sender: UISwitch) {
        if sender.isOn {
            UserDefaults.standard.set(false, forKey: "theme")
            self.themeLabel.text = "Light Theme"
        } else {
            UserDefaults.standard.set(true, forKey: "theme")
            self.themeLabel.text = "Dark Theme"
        }
        self.viewDidAppear(true)
    }
    
    
}
