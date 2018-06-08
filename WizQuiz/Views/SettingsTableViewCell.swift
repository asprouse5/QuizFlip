//
//  SettingsTableViewCell.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/29/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var catButtons: [CategoryButton]!

}

// MARK: - SettingsViewModelView
extension SettingsTableViewCell: SettingsTableViewCellModel {

    var settingsCatButtons: [CategoryButton] {
        return catButtons
    }
}
