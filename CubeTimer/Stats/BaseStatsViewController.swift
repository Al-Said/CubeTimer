//
//  BaseStatsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class BaseStatsViewController: CubeTimerBaseViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var changeViewSegmentedControl: UISegmentedControl!
    var db = Firestore.firestore()
    var colRef: CollectionReference!
    var data = [SolutionData]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let path = "Users/\(AuthManager.shared.getUID())/sessions/session\(session)/solutions"
        self.colRef = Firestore.firestore().collection(path)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let _ = changeViewSegmentedControl {
            initSegmentedControl()
            initView()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    @IBAction func changeView(_ sender: UISegmentedControl) {
       initView()
    }
    
    func initSegmentedControl() {
        if self.theme == .dark {
            self.changeViewSegmentedControl.tintColor = .white
        } else {
            self.changeViewSegmentedControl.tintColor = .black
        }

    }
    
    func fetchDataFromDB(_ completion: @escaping () -> ()) {
        
        let query = colRef.order(by: "created", descending: true)
        query.addSnapshotListener() {
            (query, err) in
            if err != nil {
                print("An error has occured! data couldn't fetch from db")
            } else {
                self.data.removeAll()
                for sol in query!.documents {
                    let data = sol.data()
                    let algorithm = data["algorithm"] as? String ?? ""
                    let created = data["created"] as? Double ?? 0.0
                    let duration = data["duration"] as? Double ?? 0.0
                    let session = data["session"] as? Int ?? 0
                    
                    let solution = SolutionData(algorithm: algorithm, duration: duration, created: created, session: session, showAlgorithm: false)
                    self.data.append(solution)
                }
                completion()
                print("successfully fetch from DB")
        
            }
        }
    }
    
    func fetchData(_ completion: @escaping () -> () ) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                let algorithm = result.value(forKey: "algorithm") as! String
                let created = result.value(forKey: "created") as! Double
                let duration = result.value(forKey: "duration") as! Double
                let session = result.value(forKey: "session") as! Int
                
                let solution = SolutionData(algorithm: algorithm, duration: duration, created: created, session: session, showAlgorithm: false)
                data.append(solution)
            }
            print("successfully fetch data from core")
            completion()
        } catch {
            print("failed to fetch data from core")
        }
    }
    
    func initView() {
        if changeViewSegmentedControl.selectedSegmentIndex == 1 {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 1.0, y: 0.0), animated: true)
        } else {
            self.scrollView.setContentOffset(CGPoint(x: self.view.frame.width * 0.0, y: 0.0), animated: true)
        }
    }
}
