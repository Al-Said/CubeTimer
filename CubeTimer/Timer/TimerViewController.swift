//
//  TimerViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 9.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import CoreData

class TimerViewController: UIViewController {

    @IBOutlet weak var scrambleLabel: UILabel!
    @IBOutlet weak var timerLabel: UILabel!
    
    var timer = Timer()
    var startTime = TimeInterval()
    var isTimeRunning = false
    
    var strMinutes = ""
    var strSeconds = ""
    var strFraction = ""
    var prevAlg = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addLongPressGesture(view: self.view)
        self.addTapGestureRecognizer(view: self.view)
        self.scrambleLabel.text = AlgorithmGenerator.generateAlg()
    }
  
    @objc func updateTime() {
        let currentTime = NSDate.timeIntervalSinceReferenceDate
        var elapsedTime: TimeInterval = currentTime - startTime
        
        let minutes = Int(elapsedTime/60.0)
        elapsedTime -= TimeInterval(minutes) * 60
        
        let seconds = Int(elapsedTime)
        
        elapsedTime -= TimeInterval(seconds)
        
        let fraction = Int(elapsedTime * 1000)
        
        strMinutes = String(format: "%02d", minutes)
        strSeconds = String(format: "%02d", seconds)
        strFraction = String(format: "%03", fraction)
        
        if strMinutes == "00" {
            self.timerLabel.text = "\(strSeconds).\(strFraction)"
        } else {
            self.timerLabel.text = "\(strMinutes):\(strSeconds).\(strFraction)"
        }
        
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
            self.timerLabel.text = "00.00"
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
        let data = SolutionData(algorithm: scramble, duration: duration, created: created, session: session)
        self.saveData(data: data)
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
}
