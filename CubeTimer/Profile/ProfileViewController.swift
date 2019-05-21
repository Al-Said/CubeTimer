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
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var singleBestLabel: UILabel!
    @IBOutlet weak var bestAvgLabel: UILabel!
    @IBOutlet weak var bestAvg12Label: UILabel!
    @IBOutlet weak var totalAvgLabel: UILabel!
    @IBOutlet weak var bestSessionLabel: UILabel!
    
    var db = Firestore.firestore()
    var colRef: CollectionReference!
    var data: Profile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUI()
        fetchData()
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
    
    func fetchData() {
        let path = "Users"
        self.colRef = Firestore.firestore().collection(path)
        let docRef = colRef.document(AuthManager.shared.getUID())
        
        docRef.getDocument() { (docSnap, error) in
            guard let docSnap = docSnap, docSnap.exists else { return }
            let profile = docSnap.data()!
            let name = profile["name"] as? String ?? "no name"
            let surname = profile["surname"] as? String ?? "no name"
            let bestOfFive = profile["bestOfFive"] as? Double ?? 0.0
            let bestOfTwelve = profile["bestOfTwelve"] as? Double ?? 0.0
            let totalAvg = profile["totalAvg"] as? Double ?? 0.0
            let bestSession = profile["bestSession"] as? Int ?? 0
            let createdSession = profile["createdSession"] as? Int ?? 0
            
            self.data = Profile(name: name, surname: surname, createdSessions: createdSession, bestSession: bestSession, totalAvg: totalAvg, bestOfFive: bestOfFive, bestOfTwelve: bestOfTwelve)
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
    
}
