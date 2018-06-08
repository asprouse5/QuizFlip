//
//  SettingsViewController.swift
//  WizQuiz
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
        settingsViewModel.setSelection(of: sender, tableView: tableView)
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.tableViewSectionHeaderHeight)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = settingsViewModel.setupSectionHeaderView(tableView: tableView, section: section)
        view.headerButton.addTarget(self, action: #selector(buttonTrigerred(_:)), for: .touchUpInside)
        return view
    }

    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            as? SettingsTableViewCell else { fatalError() }

        settingsViewModel.setupButtons(view: cell, section: indexPath.section)

        return cell
    }
}
