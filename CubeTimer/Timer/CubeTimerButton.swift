//
//  CubeTimerButton.swift
//  CubeTimer
//
//  Created by Said Alır on 15.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class CubeTimerButton: UIButton {

    func initUI() {
        self.titleLabel!.font = UIFont(name: "Copperplate", size: 22.0)
        self.setTitleColor(.black, for: .normal)
        self.backgroundColor = .white
        self.layer.cornerRadius = 8.0
        self.clipsToBounds = true
        self.layer.masksToBounds = true
        
    }

}
