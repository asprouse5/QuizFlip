//
//  SettingsTableViewCell.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/29/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var mainCatButton: CategoryButton!
    @IBOutlet var catButtons: [CategoryButton]!

}

// MARK: - SettingsViewModelView
extension SettingsTableViewCell: SettingsViewModelView {

    var settingsMainCatButton: CategoryButton {
        return mainCatButton
    }

    var settingsCatButtons: [CategoryButton] {
        return catButtons
    }
}
