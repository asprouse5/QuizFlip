//
//  SettingsViewController.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol DataTransferable: class {
    func passState(state: State?)
}

class SettingsViewController: UITableViewController {

    var state: State?
    weak var delegate: DataTransferable?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))

        guard let state = state else { fatalError("State not set up") }
        if state.settingsViewModels.count == 0 {
            state.networkClient.delegate = self
            state.networkClient.readInCategoryData()
        }
    }

    @IBAction func okButtonTriggered(_ sender: Any) {
        delegate?.passState(state: state)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func cancelButtonTriggered(_ sender: Any) {
        delegate?.passState(state: state)
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func buttonTrigerred(_ sender: CategoryButton) {
        guard let state = state?.settingsViewModels[sender.section].setSelection(of: sender, state: state) else {
            return
        }
        self.state = state
    }
}

// MARK: - UITableViewDataSource
extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let state = state else { return 0 }
        return state.settingsViewModels.count
    }

    // Sets each cell's background color to clear
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                            forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell", for: indexPath)
            as? SettingsTableViewCell else { fatalError("No SettingsCell") }

        guard let state = state else { fatalError("State not set up") }
        state.settingsViewModels[indexPath.section].setTitleAndImages(view: cell, indexPath: indexPath, state: state)

        return cell
    }
}

extension SettingsViewController: NetworkDelegate {
    func finishedFetching(categories: [Category]) {
        state?.settingsViewModels = categories.map { SettingsViewModel(category: $0) }
        state?.isSelected = [Bool](repeating: false,
                                   count: categories.reduce(0) { sum, cat in
                                    sum + cat.icons.count + 1
        })
        tableView.reloadData()
    }
}
