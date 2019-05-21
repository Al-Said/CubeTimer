//
//  CubeTimerButton.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class CubeTimerButton: UIButton {

    func initUI(with theme: Theme) {
        self.titleLabel!.font = UIFont(name: "Copperplate", size: 22.0)
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
        if theme == .dark {
            self.setTitleColor(.black, for: .normal)
            self.backgroundColor = .white
        } else if theme == .light {
            self.setTitleColor(.white, for: .normal)
            self.backgroundColor = .black
        }
    }

}
