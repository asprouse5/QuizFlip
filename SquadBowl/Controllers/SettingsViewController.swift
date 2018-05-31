//
//  SettingsViewController.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    internal var networkClient = NetworkClient.shared
    var settingsViewModels = [SettingsViewModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        networkClient.readInCategoryData { categories in
            guard let categories = categories else { fatalError("error getting categories") }
            self.settingsViewModels = categories.map { SettingsViewModel(category: $0) }
            self.tableView.reloadData()
        }
    }

    @IBAction func buttonTrigerred(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.accessibilityLabel == "HeadCategory" {
            // select/deselect all other buttons
            guard let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
                as? SettingsTableViewCell else {
                    fatalError("Error initializing cell as a SettingsTableViewCell.")
            }

            let shouldBeSelected = sender.isSelected
            for button in cell.catButtons {
                button.isSelected = shouldBeSelected
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingsViewModels.count
    }

    // Sets each cell's background color to clear
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            as? SettingsTableViewCell else { fatalError("No SettingsCell") }

        settingsViewModels[indexPath.row].setTitleAndImages(view: cell, index: indexPath.row)

        return cell
    }
}
