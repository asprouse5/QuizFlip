//
//  SettingsViewModel.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit // needed for UIImage and UIView

protocol SettingsTableViewCellModel {
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

    // MARK: - Getting category data from network

    func getCategories(completion: @escaping () -> Void) {
        if let data = defaults.object(forKey: "categories") as? Data,
            let decodedData = try? PropertyListDecoder().decode([Category].self, from: data) {
            // data is saved
            self.categories = decodedData
            self.selections = defaults.array(forKey: "isSelected") as? [Bool]
            completion()
        } else {
            // no data saved, get some
            getNewCategoryData()
            completion()
        }
    }

    func getNewCategoryData() {
        networkClient.getCategoryData { categories in
            DispatchQueue.main.async {
                self.categories = categories
                self.selections = [Bool](repeating: true, count: self.getCategoryCount(categories))
                self.saveUserDefaults()
            }
        }
    }

    // MARK: - Set up tableView data for SettingsViewController

    func numberOfSections() -> Int {
        return categories?.count ?? 0
    }

    func setupButtons(view: SettingsTableViewCellModel, section: Int) {
        for button in view.settingsCatButtons {
            let imageName = categoryImageName(for: section, subIndex: button.tag)
            button.setImage(UIImage(named: imageName), for: .normal)
            setProperties(for: button, section: section, name: imageName)
        }
    }

    func setupSectionHeaderView(tableView: UITableView, section: Int) -> SettingsHeaderView {
        let view = SettingsHeaderView(frame: tableView.frame)

        let title = categoryTitle(for: section)
        view.headerButton.setTitle(title, for: .normal)
        setProperties(for: view.headerButton, section: section, name: title)

        return view
    }

    // MARK: - Private functions for setting SettingsViewController's views

    private func getCategoryCount(_ categories: [Category]?) -> Int {
        return categories?.reduce(0) { sum, cat in return sum + cat.icons.count + 1 } ?? 0
    }

    private func categoryTitle(for section: Int) -> String {
        return categories?[section].title ?? ""
    }

    private func categoryImageName(for section: Int, subIndex: Int) -> String {
        return categories?[section].icons[subIndex-1] ?? ""
    }

    private func setProperties(for button: CategoryButton, section: Int, name: String) {
        button.section = section
        button.category = name
        button.isSelected = selectionState(of: button)
    }

    private func selectionState(of button: CategoryButton) -> Bool {
        let index = button.tagWith(offset: button.section, multiplier: 4)
        return selections?[index] ?? false
    }

    // MARK: - Setting selection of CategoryButton when triggered

    @objc func setSelection(of button: CategoryButton, tableView: UITableView) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: button.section))
            as? SettingsTableViewCell else { fatalError() }

        button.isSelected = !button.isSelected
        var index = button.tagWith(offset: button.section, multiplier: 4)
        selections?[index] = button.isSelected

        if button.accessibilityLabel == "HeadCategory" {
            let shouldBeSelected = button.isSelected

            for cButton in cell.settingsCatButtons {
                index += 1
                cButton.isSelected = shouldBeSelected
                selections?[index] = shouldBeSelected
            }
        }
    }

}
