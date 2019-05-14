//
//  StatTableViewCell.swift
//  CubeTimer
//
//  Created by Said Alır on 10.05.2019.
//  Copyright © 2019 Said Alır. All rights reserved.
//

import UIKit

class StatTableViewCell: UITableViewCell {
    
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var createdLabel: UILabel!
    @IBOutlet weak var sessionLabel: UILabel!
    @IBOutlet weak var algorithmLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func initializeCell(with data: SolutionData) {
        let shared = TimeConverter.shared
        self.durationLabel.text = shared.durationToStr(data.duration)
        self.createdLabel.text = shared.createdToStr(data.created)
        self.sessionLabel.text = "Session: \(data.session)"
        self.algorithmLabel.text = data.algorithm
    }
    
    func initLabels(with theme: Theme) {
        self.durationLabel.initLabel(with: theme)
        self.createdLabel.initLabel(with: theme)
        self.sessionLabel.initLabel(with: theme)
        self.algorithmLabel.initLabel(with: theme)
    }
}
