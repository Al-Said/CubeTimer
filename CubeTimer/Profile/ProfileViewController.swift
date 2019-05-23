//
//  ProfileViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileViewController: CubeTimerBaseViewController {
    
    @IBOutlet weak var newSessionButton: CubeTimerButton!
    @IBOutlet weak var selectSessionButton: CubeTimerButton!
    @IBOutlet weak var logOutButton: CubeTimerButton!
    
    var db = Firestore.firestore()
    var colRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = "Users"
        self.colRef = Firestore.firestore().collection(path)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUI()
    }
    
    func setUI() {
        self.newSessionButton.initUI(with: self.theme)
        self.selectSessionButton.initUI(with: self.theme)
        self.logOutButton.initUI(with: self.theme)
        
        self.newSessionButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
        self.selectSessionButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
        self.logOutButton.titleLabel?.font = UIFont(name: "Copperplate", size: 17.0)
        
        for subview in self.view.subviews {
            if let label = subview as? UILabel {
                label.initLabel(with: self.theme)
            }
        }
    }
    



    @IBAction func logoutAction(_ sender: Any) {
       
        do {
           try Auth.auth().signOut()
            AuthManager.shared.logout()
            let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
            let nc = storyboard.instantiateViewController(withIdentifier: "onboardRoot")
            self.present(nc, animated: true, completion: nil)
        } catch {
            print("An error has occured!...")
        }
    }
    
    @IBAction func createNewSession(_ sender: CubeTimerButton) {
        self.showInfoPopup(message: "New session is created!")
        self.session += 1
    }
    
}
