//
//  SettingsTableViewCell.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/29/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var mainCatButton: UIButton!
    @IBOutlet var catButtons: [UIButton]!

}

// MARK: - SettingsViewModelView
extension SettingsTableViewCell: SettingsViewModelView {

    public var settingsMainCatButton: UIButton {
        return mainCatButton
    }

    public var settingsCatButtons: [UIButton] {
        return catButtons
    }
}
