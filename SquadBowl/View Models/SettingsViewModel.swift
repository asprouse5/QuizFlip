//
//  SettingsViewModel.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol SettingsViewModelView {
    var settingsMainCatButton: CategoryButton { get }
    var settingsCatButtons: [CategoryButton] { get }
}

class SettingsViewModel {
    var category: Category
    var catButtons: [CategoryButton]
    //var selections: [Bool]

    init(category: Category) {
        self.category = category
        catButtons = [CategoryButton]()
    }

    func setTitleAndImages(view: SettingsViewModelView, indexPath: IndexPath, state: State) {
        // set main category label to the over-arching category
        let mainButton = view.settingsMainCatButton
        catButtons = view.settingsCatButtons

        mainButton.setTitle(category.title, for: .normal)
        let index = mainButton.tagWith(offset: indexPath.section)
        mainButton.isSelected = state.isSelected[index]
        mainButton.section = indexPath.section

        // set all sub categories' icons
        for idx in 0..<catButtons.count {
            catButtons[idx].setImage(UIImage(named: category.icons[idx]), for: .normal)
            catButtons[idx].section = indexPath.section
            let index = catButtons[idx].tagWith(offset: indexPath.section)
            catButtons[idx].isSelected = state.isSelected[index]
        }
    }

    func setSelection(of button: CategoryButton, state: State?) -> State? {
        guard var state = state else { return nil }

        button.isSelected = !button.isSelected
        var index = button.tagWith(offset: button.section)
        state.isSelected[index] = button.isSelected

        if button.accessibilityLabel == "HeadCategory" {
            let shouldBeSelected = button.isSelected

            for cButton in catButtons {
                index += 1
                cButton.isSelected = shouldBeSelected
                state.isSelected[index] = shouldBeSelected
            }
        }

        return state
    }

}
