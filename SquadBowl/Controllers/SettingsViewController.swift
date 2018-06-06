//
//  SettingsViewController.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    @IBOutlet var settingsViewModel: SettingsViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))

        settingsViewModel.getCategories {
            self.tableView.reloadData()
        }
    }

    @IBAction func okButtonTriggered(_ sender: Any) {
        settingsViewModel.saveUserDefaults()
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonTriggered(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonTrigerred(_ sender: CategoryButton) {
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: sender.section))
            as? SettingsTableViewCell else { fatalError() }
        settingsViewModel.setSelection(of: sender, view: cell)
    }

}

// MARK: - UITableViewDataSource
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return settingsViewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            as? SettingsTableViewCell else { fatalError() }

        settingsViewModel.setupButtons(view: cell, indexPath: indexPath)

        return cell
    }
}
