//
//  SettingsTableViewCell.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 5/29/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var mainCatButton: CategoryButton!
    @IBOutlet var catButtons: [CategoryButton]!

}

// MARK: - SettingsViewModelView
extension SettingsTableViewCell: SettingsTableViewCellModel {

    var settingsMainCatButton: CategoryButton {
        return mainCatButton
    }

    var settingsCatButtons: [CategoryButton] {
        return catButtons
    }
}
