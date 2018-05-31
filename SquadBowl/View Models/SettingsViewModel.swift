//
//  SettingsViewModel.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

public protocol SettingsViewModelView {
    var settingsMainCatButton: UIButton { get }
    var settingsCatButtons: [UIButton] { get }
}

class SettingsViewModel {
    var category: Category
    var networkClient = NetworkClient()

    init(category: Category) {
        self.category = category
    }
}

extension SettingsViewModel {
    public func setTitleAndImages(view: SettingsViewModelView, index: Int) {
        // set main category label to the over-arching category
        view.settingsMainCatButton.setTitle(category.title, for: .normal)
        view.settingsMainCatButton.tag = index

        // set all sub categories title and icon
        for index in 0..<view.settingsCatButtons.count {
            let icon = category.icons
            //let title = icon[index].formatIconTitle()
            //view.settingsCatButtons[index].setTitle(title, for: .normal)
            view.settingsCatButtons[index].setImage(UIImage(named: icon[index]), for: .normal)
            //view.settingsCatButtons[index].alignImageAndTitleVertically()
        }
    }
}
