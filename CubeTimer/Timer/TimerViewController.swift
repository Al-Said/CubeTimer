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

    var colRef: CollectionReference!
    
    @IBOutlet weak var scrambleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var startTime = TimeInterval()
    var isTimeRunning = false
    var strMinutes = ""
    var strSeconds = ""
    var strFraction = ""
    var prevAlg = ""
    let session = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLongPressGesture(view: self.view)
        self.addTapGestureRecognizer(view: self.view)
        self.scrambleLabel.text = AlgorithmGenerator.generateAlg()
        let path = "solution/session\(self.session)/solution"
        self.colRef = Firestore.firestore().collection(path)
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidLoad()
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
            self.timerLabel.textColor = .white
        } else {
            self.timerLabel.text = "00.000"
            self.timerLabel.textColor = .red
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                self.timerLabel.textColor = .white
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
            self.timerLabel.textColor = .white
            
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
        let created = NSDate.timeIntervalSinceReferenceDate
        
        let duration: TimeInterval = created - startTime
        let scramble = self.prevAlg
        let session = 0
        let data = SolutionData(algorithm: scramble, duration: duration, created: created, session: session, showAlgorithm: false)
        
        if self.toSaveDB {
            self.saveDataToDB(data: data)

        } else {
            self.saveData(data: data)
        }
        
        isTimeRunning = false
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
            print("successful")
        } catch {
            print("failed saving")
        }
    }
    
    func  saveDataToDB(data: SolutionData)  {
        let dataToSave : [String: Any] = ["algorithm" : data.algorithm, "created" : data.created, "session" : data.session, "duration": data.duration]
//        colRef..setData(dataToSave) { (error) in
//            print("failed to save")
//        }
//        print("successfully saved data")
//    }
        colRef.addDocument(data: dataToSave) { (error) in
            print("failed to save")
        }
        print("successfully saved data")
    }
}
