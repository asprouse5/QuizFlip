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
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "darkbg"))

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
        settingsViewModel.setSelection(of: sender)
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
        guard let cell = cell as? SettingsTableViewCell else { return }

        cell.backgroundColor = UIColor.clear
        cell.setCollectionViewTag(tag: indexPath.section)
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCollectionCell", for: indexPath)
            as? SettingsTableViewCell else { fatalError() }

            return cell
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView.rowHeight == -1 {
            return tableView.estimatedRowHeight
        } else {
            return tableView.rowHeight + 24
        }
    }
}

// MARK: - UICollectionView
extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsViewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.maxWidth()
        tableView.rowHeight = size

        tableView.beginUpdates()
        tableView.endUpdates()

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsViewCell", for: indexPath)
            as? SettingsCollectionViewCell else { fatalError() }

        guard let button = cell.imageButton else { fatalError() }
        let imageName = settingsViewModel.setupButton(button, tag: indexPath.item, section: collectionView.tag)
        button.setImage(UIImage(named: imageName), for: .normal)

        return cell
    }
}
