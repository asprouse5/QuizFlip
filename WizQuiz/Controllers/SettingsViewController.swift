//
//  SettingsViewController.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol QuestionFilterable: class {
    func sendFilterArray(_ selections: [Selection]?)
}

class SettingsViewController: UITableViewController {

    @IBOutlet var settingsViewModel: SettingsViewModel!
    weak var filterDelegate: QuestionFilterable?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))

        settingsViewModel.getCategories {
            self.tableView.reloadData()
        }
    }

    @IBAction func okButtonTriggered(_ sender: Any) {
        settingsViewModel.saveUserDefaults()
        if settingsViewModel.noCategoriesSelected() {
            let alert = UIAlertController(title: "Warning", message: "You must select at least one category!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            filterDelegate?.sendFilterArray(settingsViewModel.selections)
            self.dismiss(animated: true, completion: nil)
        }
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

    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(Constants.tableViewSectionHeaderHeight)
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = SettingsHeaderView(frame: tableView.frame)
        settingsViewModel.setupSectionHeaderView(view: view, section: section)
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

        for button in cell.settingsCatButtons {
            let imageName = settingsViewModel.setupButton(button, section: indexPath.section)
            button.setImage(UIImage(named: imageName), for: .normal)
        }

        return cell
    }
}
