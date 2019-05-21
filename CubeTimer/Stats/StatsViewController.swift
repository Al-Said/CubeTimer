//
//  StatsViewController.swift
//  CubeTimer
//
//  Created by Said Alır on 1.04.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit
import CoreData
import Firebase

class StatsViewController: BaseStatsViewController {
    
    @IBOutlet var table: UITableView!
    var lastOpened = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        table.delegate = self
        table.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.theme == .light { self.table.separatorColor = .black } else { self.table.separatorColor = .white }
        self.data.removeAll()
        if self.reachability!.connection == .none {
                fetchData() {
                self.table.reloadData()
            }
        } else {
            fetchDataFromDB() {
            self.table.reloadData()
            }
        }

    }
    

}

extension StatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if data[indexPath.row].showAlgorithm {
            return 100
        } else {
            return 55
        }
    }
}

extension StatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StatTableViewCell") as? StatTableViewCell else {
            return UITableViewCell()
        }
        cell.initializeCell(with: data[indexPath.row])
        cell.initLabels(with: self.theme)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if lastOpened != indexPath.row {data[indexPath.row].showAlgorithm = false }
        
        lastOpened = indexPath.row
        let show = data[indexPath.row].showAlgorithm
        data[indexPath.row].showAlgorithm = show ? false : true
        table.reloadData()
    }
    
    
}
