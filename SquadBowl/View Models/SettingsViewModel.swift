//
//  SettingsViewModel.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol SettingsTableViewCellModel {
    var settingsMainCatButton: CategoryButton { get }
    var settingsCatButtons: [CategoryButton] { get }
}

class SettingsViewModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    var categories: [Category]?
    var selections: [Bool]?
    let defaults = UserDefaults.standard

    func saveUserDefaults() {
        defaults.set(selections, forKey: "isSelected")
        let encodedData = try? PropertyListEncoder().encode(categories)
        defaults.set(encodedData, forKey: "categories")
    }

    func getCategories(completion: @escaping () -> Void) {
        if let data = defaults.object(forKey: "categories") as? Data,
            let decodedData = try? PropertyListDecoder().decode([Category].self, from: data) {
            // data is saved
            self.categories = decodedData
            self.selections = defaults.array(forKey: "isSelected") as? [Bool]
            completion()
        } else {
            // no data saved, get some
            getNewData()
            completion()
        }
    }

    func getNewData() {
        networkClient.readInCategoryData { categories in
            DispatchQueue.main.async {
                self.categories = categories
                self.selections = [Bool](repeating: false, count: self.getCategoryCount(categories))
                self.saveUserDefaults()
            }
        }
    }

    func getCategoryCount(_ categories: [Category]?) -> Int {
        return categories?.reduce(0) { sum, cat in return sum + cat.icons.count + 1 } ?? 0
    }

    func numberOfSections() -> Int {
        return categories?.count ?? 0
    }

    func setupButtons(view: SettingsTableViewCellModel, indexPath: IndexPath) {
        let title = categoryTitle(for: indexPath)
        view.settingsMainCatButton.setTitle(title, for: .normal)
        view.settingsMainCatButton.section = indexPath.section
        view.settingsMainCatButton.isSelected = selectionState(of: view.settingsMainCatButton)

        for button in view.settingsCatButtons {
            let image = categoryImage(for: indexPath, subIndex: button.tag)
            button.setImage(image, for: .normal)
            button.section = indexPath.section
            button.isSelected = selectionState(of: button)
        }
    }

    func categoryTitle(for indexPath: IndexPath) -> String {
        return categories?[indexPath.section].title ?? ""
    }

    func categoryImage(for indexPath: IndexPath, subIndex: Int) -> UIImage? {
        let name = categories?[indexPath.section].icons[subIndex-1] ?? ""
        return UIImage(named: name)
    }

    func selectionState(of button: CategoryButton) -> Bool {
        let index = button.tagWith(offset: button.section, multiplier: 4)
        return selections?[index] ?? false
    }

    func setSelection(of button: CategoryButton, view: SettingsTableViewCellModel) {
        button.isSelected = !button.isSelected
        var index = button.tagWith(offset: button.section, multiplier: 4)
        selections?[index] = button.isSelected

        if button.accessibilityLabel == "HeadCategory" {
            let shouldBeSelected = button.isSelected

            for cButton in view.settingsCatButtons {
                index += 1
                cButton.isSelected = shouldBeSelected
                selections?[index] = shouldBeSelected
            }
        }
    }

}
