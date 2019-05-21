//
//  CubeTimerBaseViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class CubeTimerBaseViewController: UIViewController {

    var toSaveDB = true
    var theme = Theme.dark
    var session = 0
    var created = 0
    //Reachability Variables..
    var reachability: Reachability?
    let hostNames = [nil, "google.com", "invalidhost"]
    var hostIndex = 0
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startHost(at: 0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        toSaveDB = UserDefaults.standard.bool(forKey: "toSaveDb")
        session = UserDefaults.standard.integer(forKey: "session")
        created = UserDefaults.standard.integer(forKey: "created")
        let isDark = UserDefaults.standard.bool(forKey: "theme")
        self.theme = isDark ? .dark : .light
        self.view!.backgroundColor = initBackgroundColor()
    
    }
    
    func initBackgroundColor() -> UIColor {
        switch self.theme {
        case .dark:
            return .black
        case .light:
            return .white
        }
    }
}

//Reachability Extension...
extension CubeTimerBaseViewController {
    
    func startHost(at index: Int) {
        stopNotifier()
        setupReachability(hostNames[index], useClosures: true)
        startNotifier()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.startHost(at: (index + 1) % 3)
        }
    }
    
    func setupReachability(_ hostName: String?, useClosures: Bool) {
        let reachability: Reachability?
        if let hostName = hostName {
            reachability = Reachability(hostname: hostName)
        } else {
            reachability = Reachability()
        }
        self.reachability = reachability
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged(_:)),
            name: .reachabilityChanged,
            object: reachability
        )
        
    }
    
    func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            return
        }
    }
    
    func stopNotifier() {
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    
    @objc func reachabilityChanged(_ note: Notification) {
        let reachability = note.object as! Reachability
        
        if reachability.connection != .none {
            print("connected to internet")
        } else {
            print("no connection")
        }
    }
}
