//
//  ProfileViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: CubeTimerBaseViewController {
    
    @IBOutlet weak var newSessionButton: CubeTimerButton!
    @IBOutlet weak var selectSessionButton: CubeTimerButton!
    @IBOutlet weak var logOutButton: CubeTimerButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUI()
    }
    
    func setUI() {
        self.newSessionButton.initUI()
        self.selectSessionButton.initUI()
        self.logOutButton.initUI()
        
        self.newSessionButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
        self.selectSessionButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
        self.logOutButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
    }

    @IBAction func logoutAction(_ sender: Any) {
       
        do {
           try Auth.auth().signOut()
            let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "onboardRoot")
            self.present(nc, animated: true, completion: nil)
        } catch {
            print("An error has occured!...")
        }
    }
    
}
