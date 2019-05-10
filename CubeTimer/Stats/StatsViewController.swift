//
//  StatsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 1.04.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import CoreData

class StatsViewController: UIViewController {
    
    @IBOutlet var table: UITableView!
    
    var datas = [SolutionData]()
    var lastOpened = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        datas.removeAll()
        fetchData()
        table.reloadData()
    }
    
    func fetchData() {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Record")
        request.returnsObjectsAsFaults = false
        
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                let algorithm = data.value(forKey: "algorithm") as! String
                let created = data.value(forKey: "created") as! Double
                let duration = data.value(forKey: "duration") as! Double
                let session = data.value(forKey: "session") as! Int
                
                let solution = SolutionData(algorithm: algorithm, duration: duration, created: created, session: session, showAlgorithm: false)
                datas.append(solution)
            }
        } catch {
            print("failed")
        }
    }
    
}

extension StatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if datas[indexPath.row].showAlgorithm {
            return 100
        } else {
            return 55
        }
    }
}

extension StatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatTableViewCell") as? StatTableViewCell else {
            return UITableViewCell()
        }
        cell.initializeCell(with: datas[indexPath.row])
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lastOpened != indexPath.row {datas[indexPath.row].showAlgorithm = false }
        
        lastOpened = indexPath.row
        let show = datas[indexPath.row].showAlgorithm
        datas[indexPath.row].showAlgorithm = show ? false : true
        table.reloadData()
    }
    
    
}
