//
//  SettingsViewModel.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class SettingsViewModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    var categories: [Category]?
    var selections: [Selection]?
    var categoryButtons = [CategoryButton]()
    let defaults = UserDefaults.standard

    func saveUserDefaults() {
        let encodedCategories = try? PropertyListEncoder().encode(categories)
        defaults.set(encodedCategories, forKey: "categories")
        let encodedSelections = try? PropertyListEncoder().encode(selections)
        defaults.set(encodedSelections, forKey: "selections")
    }

    private func getUserDefaults(for key: String) -> Data? {
        guard let data = defaults.object(forKey: key) as? Data else { return nil }
        return data
    }

    // MARK: - Getting category data from network

    func getCategories(completion: @escaping () -> Void) {
        if let categoryData = getUserDefaults(for: "categories") {
            // we have saved data
            guard let selectionData = getUserDefaults(for: "selections") else { fatalError() }

            // decode categories
            let decodedCategories = try? PropertyListDecoder().decode([Category].self, from: categoryData)
            self.categories = decodedCategories

            // decode selections
            let decodedSelections = try? PropertyListDecoder().decode([Selection].self, from: selectionData)
            self.selections = decodedSelections

        } else {
            // no saved data, get some
            getNewCategoryData()
        }

        completion()
    }

    func getNewCategoryData() {
        networkClient.getCategoryData { categories in
            DispatchQueue.main.async {
                guard let categories = categories else { return }
                self.categories = categories
                let data = categories.flatMap { [$0.title] + $0.icons }
                self.selections = data.map { Selection(name: $0) }
                self.saveUserDefaults()
            }
        }
    }

    // MARK: - Set up tableView data for SettingsViewController

    func numberOfSections() -> Int {
        return categories?.count ?? 0
    }

    func numberOfItems(in section: Int) -> Int {
        return categories?[section].icons.count ?? 0
    }

    func setupButton(_ button: CategoryButton, tag: Int, section: Int) -> String {
        button.tag = tag+1
        categoryButtons.append(button)
        let imageName = categoryImageName(for: section, subIndex: button.tag)
        setProperties(for: button, section: section, name: imageName)
        return imageName
    }

    func setupSectionHeaderView(view: SettingsHeaderView, section: Int) {
        let title = categoryTitle(for: section)
        view.headerButton.setTitle(title, for: .normal)
        setProperties(for: view.headerButton, section: section, name: title)
    }

    // MARK: - Private functions for setting SettingsViewController's views

    private func categoryTitle(for section: Int) -> String {
        return categories?[section].title ?? "N/A"
    }

    private func categoryImageName(for section: Int, subIndex: Int) -> String {
        return categories?[section].icons[subIndex-1] ?? "N/A"
    }

    private func setProperties(for button: CategoryButton, section: Int, name: String) {
        button.section = section
        button.category = name
        button.isSelected = selectionState(of: button)
    }

    private func selectionState(of button: CategoryButton) -> Bool {
        let index = button.tagWith(offset: button.section, multiplier: 4)
        return selections?[index].selected ?? false
    }

    // MARK: - Setting selection of CategoryButton when triggered

    func setSelection(of button: CategoryButton) {
        button.isSelected = !button.isSelected
        var index = button.tagWith(offset: button.section, multiplier: 4)
        selections?[index].setSelected(button.isSelected)

        if button.accessibilityLabel == "HeadCategory" {
            let shouldBeSelected = button.isSelected

            // need to select/deselect buttons if all/none are selected
            let sameSectionButtons = categoryButtons.filter { $0.section == button.section }

            for cButton in sameSectionButtons {
                index += 1
                cButton.isSelected = shouldBeSelected
                selections?[index].setSelected(shouldBeSelected)
            }
        }
    }

    func noCategoriesSelected() -> Bool {
        guard let selections = selections else { return false }
        return selections.filter({ $0.selected == true }).count == 0
    }

}
