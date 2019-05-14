//
//  CubeTimerLabelExtension.swift
//  CubeTimer
//
//  Created by Said Alır on 13.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

extension UILabel {
    
    func initLabel(with theme: Theme) {
        switch theme {
        case .dark:
            self.textColor = .white
            break
        case .light:
            self.textColor = .black
            break
        }
    }
}
