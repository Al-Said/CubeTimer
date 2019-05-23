//
//  TimerViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 9.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class TimerViewController: CubeTimerBaseViewController {

    let defaults = UserDefaults.standard
    var colRef: CollectionReference!
    
    @IBOutlet weak var scrambleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var avgOf5Label: UILabel!
    @IBOutlet weak var avgOf12Label: UILabel!
    
    var timer = Timer()
    var startTime = TimeInterval()
    
    var best = 0.0
    var bestAvg5 = 0.0
    var bestAvg12 = 0.0
    
    var isTimeRunning = false
    var strMinutes = ""
    var strSeconds = ""
    var strFraction = ""
    var prevAlg = ""
    var durations = [Double]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLongPressGesture(view: self.view)
        self.addTapGestureRecognizer(view: self.view)
        self.avgOf5Label.isHidden = true
        self.avgOf12Label.isHidden = true
        self.best = defaults.double(forKey: "best")
        self.bestAvg5 = defaults.double(forKey: "bestAvg5")
        self.bestAvg12 = defaults.double(forKey: "bestAvg12")
        self.scrambleLabel.text = AlgorithmGenerator.generateAlg()
        let path = "Solution/\(AuthManager.shared.getUID())/Sessions/session\(session)/solution"
        self.colRef = Firestore.firestore().collection(path)

    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initUI()
    }
    
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        let elapsedTime: TimeInterval = currentTime - startTime
        self.timerLabel.text = TimeConverter.shared.durationToStr(elapsedTime)
    }
    
    func addLongPressGesture(view: UIView) {
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector (self.handleLongPress(sender:)))
        lpgr.minimumPressDuration = 0.4
        view.addGestureRecognizer(lpgr)
    }
    
    func  addTapGestureRecognizer(view: UIView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if isTimeRunning {
            stopTimer()
            self.timerLabel.initLabel(with: self.theme)
        } else {
            self.timerLabel.text = "00.000"
            self.timerLabel.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.timerLabel.initLabel(with: self.theme)
            }
        }
    }
 
    @objc func handleLongPress(sender: UILongPressGestureRecognizer) {
       
        if isTimeRunning {
            timer.invalidate()
            isTimeRunning = false
            return
        }
        
        switch sender.state {
        case .began:
            self.timerLabel.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                if self.timerLabel.textColor == .red {
                    self.timerLabel.textColor = .green
                }
            }
            break
        case .changed:
            break
        case .ended:
            if self.timerLabel.textColor == .green {
                startTimer()
                isTimeRunning = true
            }
            self.timerLabel.initLabel(with: self.theme)
            
            break
        default:
            print("default")
            break
        }
    }
    
    func startTimer() {
        self.prevAlg = self.scrambleLabel.text!
        self.scrambleLabel.text = AlgorithmGenerator.generateAlg()
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
        startTime = Date.timeIntervalSinceReferenceDate
    }
    
    func stopTimer() {
        
        timer.invalidate()
        let scramble = self.prevAlg
        let session = 0
        let duration = TimeConverter.shared.strToDuration(self.timerLabel.text!)
        let created =  NSDate.timeIntervalSinceReferenceDate
        let data = SolutionData(algorithm: scramble, duration: duration, created: created, session: session, showAlgorithm: false)
        
        UpdateProfile.shared.addSolution(solution: data, session: 1)
        isTimeRunning = false
    }
    
    func initUI() {
        self.scrambleLabel.initLabel(with: self.theme)
        self.timerLabel.initLabel(with: self.theme)
        self.avgOf5Label.initLabel(with: self.theme)
        self.avgOf12Label.initLabel(with: self.theme)
    }
    
    func getLastDurations() {
        if self.reachability!.connection != .none {
            fetchDataFromDB(limit: 12) {
                self.printAverages()
            }
        } else {
            fetchData(limit: 12) {
                self.printAverages()
            }
        }
    }
    
    func printAverages() {
        
        if self.durations.count < 5 {
            return
        } else {
            
            let last5 = Array(self.durations.dropLast(self.durations.count - 5))
            let avg = AverageCalculator.shared.getAvgOf(durations: last5)
            let str = TimeConverter.shared.durationToStr(avg)
            self.avgOf5Label.text = "Average of 5 : \(str)"
            self.avgOf5Label.isHidden = false
            
            if avg < self.bestAvg5 {
                defaults.set(avg, forKey: "bestAvg5")
            }
            
            if durations.count >= 12 {
                let avg = AverageCalculator.shared.getAvgOf(durations: self.durations)
                let str = TimeConverter.shared.durationToStr(avg)
                self.avgOf12Label.text = "Average of 12 : \(str)"
                self.avgOf12Label.isHidden = false
                
                if avg < self.bestAvg12 {
                    defaults.set(avg, forKey: "bestAvg12")
                }
            }
        }
    }
}

extension TimerViewController {
    
    func saveData(data: SolutionData) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Record", in: context)
        
        let record = NSManagedObject(entity: entity!, insertInto: context)
        record.setValue(data.algorithm, forKey: "algorithm")
        record.setValue(data.created, forKey: "created")
        record.setValue(data.session, forKey: "session")
        record.setValue(data.duration, forKey: "duration")
        
        do {
            try context.save()
            print("successfully save data to core")
        } catch {
            print("failed saving data to core")
        }
    }
    
    func  saveDataToDB(data: SolutionData)  {
        let dataToSave : [String: Any] = ["algorithm" : data.algorithm, "created" : data.created, "session" : data.session, "duration": data.duration]
        colRef.addDocument(data: dataToSave) { (error) in
            if error != nil {
                print("failed to save data to db")
            } else {
                print("successfully saved data to db")
            }
        }
    }
    
    func fetchDataFromDB(limit: Int, _ completion: @escaping () -> ()) {
        
        let query = colRef.order(by: "created", descending: true)
        query.limit(to: limit)
        query.addSnapshotListener() {
            (query, err) in
            if err != nil {
                print("An error has occured! data couldn't fetch from db")
            } else {
                self.durations.removeAll()
                for sol in query!.documents {
                    let data = sol.data()
                    let duration = data["duration"] as? Double ?? 0.0
                    self.durations.append(duration)
                }
                completion()
                print("successfully fetch from DB")
                
            }
        }
    }
    
    func fetchData(limit: Int, _ completion: @escaping () -> () ) {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.returnsObjectsAsFaults = false
        request.fetchLimit = limit
        do {
            let results = try context.fetch(request)
            for result in results as! [NSManagedObject] {
                let duration = result.value(forKey: "duration") as! Double
                durations.append(duration)
            }
            print("successfully fetch data from core")
            completion()
        } catch {
            print("failed to fetch data from core")
        }
    }
    
}
