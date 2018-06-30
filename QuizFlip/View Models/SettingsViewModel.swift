//
//  SettingsViewModel.swift
//  QuizFlip
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

    func getCategories(completion: @escaping (Bool) -> Void) {
        if let categoryData = Defaults.getUserDefaults(for: Strings.categories.rawValue) {
            let decodedCategories = try? PropertyListDecoder().decode([Category].self, from: categoryData)

            if newCategories(oldCategories: decodedCategories) {
                getSelections()
                saveUserDefaults()
                completion(true)
            } else {
                guard let selectionData = Defaults.getUserDefaults(for: Strings.selections.rawValue) else { return }
                let decodedSelections = try? PropertyListDecoder().decode([Selection].self, from: selectionData)
                selections = decodedSelections
            }

            Constants.multiplier = numberOfItems(in: 0) + 1
        } else {
            // no saved data, get some
            getNewCategoryData()
            getSelections()
        }
        completion(false)
    }

    private func getNewCategoryData() {
        networkClient.getCategoryData { categories in
            guard let categories = categories else { return }
            self.categories = categories
        }
    }

    private func getSelections() {
        guard let categories = categories else { return }
        let data = categories.flatMap { [$0.title] + $0.icons }
        selections = data.map { Selection(name: $0) }
        saveUserDefaults()
    }

    private func newCategories(oldCategories: [Category]?) -> Bool {
        getNewCategoryData()
        guard let categories = categories else { return false }
        guard let oldCategories = oldCategories else { return false }
        return categories != oldCategories
    }

    // MARK: - Set up collection view data for SettingsViewController

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

    private func updateSelection(for button: CategoryButton?, selected: Bool, index: Int) {
        button?.isSelected = selected
        selections?[index].setSelected(selected)
    }

    private func noButtonsSelected(_ buttons: [CategoryButton]) -> Bool {
        return buttons.filter { $0.isSelected == false }.count == buttons.count
    }

    // MARK: - Enabling/Disbaling buttons so category is always selected

    func setButtonState(_ button: RoundRectButton) {
        if noCategoriesSelected() {
            button.tag = -1
            button.isEnabled = false
        } else {
            button.tag = 1
            button.isEnabled = true
        }
    }

    private func noCategoriesSelected() -> Bool {
        guard let selections = selections else { return false }
        return selections.filter { $0.selected == true }.count == 0
    }

}
