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
    
    
    @IBOutlet weak var nameSurnameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var pbLabel: UILabel!
    @IBOutlet weak var totalAvgLabel: UILabel!
    @IBOutlet weak var best5Label: UILabel!
    @IBOutlet weak var best12Label: UILabel!
    @IBOutlet weak var best100Lavel: UILabel!
    @IBOutlet weak var bestSession: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    
    
    var db = Firestore.firestore()
    var colRef: CollectionReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        let path = "Users"
        self.colRef = Firestore.firestore().collection(path)
        fetchData()
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
    
    func fetchData() {
        let docRef = colRef.document(AuthManager.shared.getUID())
        docRef.getDocument() { (doc, error) in
            
            if error != nil {
                print("An error has occured, profile data couldn't fetch")
            } else {
                let data = doc?.data()
                let name = data?["name"] as? String ?? ""
                let surname = data?["surname"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let pb = data?["pb"] as? Double ?? -1.0
                let totalAvg = data?["totalAvg"] as? Double ?? 0.0
                let best5 = data?["bestAvg5"] as? Double ?? -1.0
                let best12 = data?["bestAvg12"] as? Double ?? -1.0
                let best100 = data?["bestAvg100"] as? Double ?? -1.0
                let bestSession = data?["bestSession"] as? Int ?? 1
                let createdSession = data?["createdSessions"] as? Int ?? 1
                
                let labelData = LabelData(name: name, surname: surname, email: email , pb: pb, totalAvg: totalAvg, best5: best5, best12: best12, best100: best100, bestSession: bestSession, createdSession: createdSession)
                
                self.initLabels(with: labelData)
            }
            
        }
    }

    func initLabels(with data: LabelData) {
        self.nameSurnameLabel.text = "\(data.name) \(data.surname)"
        self.emailLabel.text = "\(data.email)"
        self.pbLabel.text = data.pb != -1 ?  "\(TimeConverter.shared.durationToStr(data.pb))" : "Not recorded data"
        self.totalAvgLabel.text = data.totalAvg != 0 ? "\(TimeConverter.shared.durationToStr(data.totalAvg))" : "No data"
        self.best5Label.text = data.best5 != -1 ? "\(TimeConverter.shared.durationToStr(data.best5))" : "There is not enough recorded solution"
        self.best12Label.text = data.best12 != -1 ? "\(TimeConverter.shared.durationToStr(data.best12))" : "There is not enough recorded solution"
        self.best100Lavel.text = data.best100 != -1 ? "\(TimeConverter.shared.durationToStr(data.best100))" : "There is not enough recorded solution"
        self.bestSession.text = "\(data.bestSession)"
        self.createdLabel.text = "\(data.createdSession)"
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
    
    
    struct LabelData {
        var name: String
        var surname: String
        var email: String
        var pb: Double
        var totalAvg: Double
        var best5: Double
        var best12: Double
        var best100: Double
        var bestSession: Int
        var createdSession: Int
    }
}
