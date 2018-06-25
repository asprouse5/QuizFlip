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
    var categoryButtons: [CategoryButton] = []

    func saveUserDefaults() {
        Defaults.saveUserDefaults(key: Strings.categories.rawValue, value: self.categories)
        Defaults.saveUserDefaults(key: Strings.selections.rawValue, value: self.selections)
    }

    // MARK: - Getting category data from network

    func getCategories(completion: @escaping () -> Void) {
        if let categoryData = Defaults.getUserDefaults(for: Strings.categories.rawValue) {
            // we have saved data
            guard let selectionData = Defaults.getUserDefaults(for: Strings.selections.rawValue) else { fatalError() }

            // decode categories
            let decodedCategories = try? PropertyListDecoder().decode([Category].self, from: categoryData)
            categories = decodedCategories

            // decode selections
            let decodedSelections = try? PropertyListDecoder().decode([Selection].self, from: selectionData)
            selections = decodedSelections

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
        let imageName = categoryImageName(for: section, subIndex: button.tag)
        setProperties(for: button, section: section, name: imageName)
        return imageName
    }

    func setupSectionHeaderView(view: SettingsHeaderView, section: Int) {
        let title = categoryTitle(for: section)
        view.headerButton.setTitle(title, for: .normal)
        view.headerButton.isHead = true
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
        if !categoryButtons.contains(button) {
            categoryButtons.append(button)
        }
    }

    private func selectionState(of button: CategoryButton) -> Bool {
        let index = button.tagWith(offset: button.section)
        return selections?[index].selected ?? false
    }

    // MARK: - Setting selection of CategoryButton when triggered

    func setSelection(of button: CategoryButton) {
        var index = button.tagWith(offset: button.section)
        updateSelection(for: button, selected: !button.isSelected, index: index)

        let sameSectionButtons = categoryButtons.filter { $0.section == button.section }
        let headButton = sameSectionButtons.first { $0.isHead == true }
        let cButtons = sameSectionButtons.filter { $0.isHead == false }

        if button.isHead {
            for cButton in cButtons {
                index += 1
                updateSelection(for: cButton, selected: button.isSelected, index: index)
            }
        } else {
            guard let headButton = headButton else { fatalError() }
            let headIndex = headButton.tagWith(offset: headButton.section)

            var selected = true
            if noButtonsSelected(cButtons) {
                selected = false
            }

            updateSelection(for: headButton, selected: selected, index: headIndex)
        }
    }

    func updateSelection(for button: CategoryButton?, selected: Bool, index: Int) {
        button?.isSelected = selected
        selections?[index].setSelected(selected)
    }

    func noButtonsSelected(_ buttons: [CategoryButton]) -> Bool {
        return buttons.filter { $0.isSelected == false }.count == buttons.count
    }

    func noCategoriesSelected() -> Bool {
        guard let selections = selections else { return false }
        return selections.filter({ $0.selected == true }).count == 0
    }

}
