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
    var theme = Theme.dark
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toSaveDB = UserDefaults.standard.bool(forKey: "toSaveDb")
        let isDark = UserDefaults.standard.bool(forKey: "theme")
        self.theme = isDark ? .dark : .light
        self.view!.backgroundColor = initBackgroundColor()
    }
    
    func initBackgroundColor() -> UIColor {
        switch self.theme {
        case .dark:
            return .black
        case .light:
            return .white
        }
    }
}
