//
//  SettingsViewController.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol QuestionFilterable: class {
    func sendFilterArray(with selections: [Selection]?)
}

protocol Updated: class {
    func didUpdate(_ updated: Bool)
}

class SettingsViewController: UIViewController {

    @IBOutlet var settingsViewModel: SettingsViewModel!
    @IBOutlet var settingsCollectionView: UICollectionView!
    @IBOutlet var updateButton: RoundRectButton!
    weak var filterDelegate: QuestionFilterable?
    weak var updateDelegate: Updated?
    var itemSize: CGFloat = 0
    var canUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsViewModel.getCategories {
            self.settingsCollectionView.reloadData()
        }

        updateButton.tag = canUpdate ? 1 : -1
        updateButton.isEnabled = canUpdate
    }

    func setUpdateEnabled(_ isEnabled: Bool) {
        canUpdate = isEnabled
    }

    @IBAction func okButtonTriggered(_ sender: Any) {
        settingsViewModel.saveUserDefaults()
        if settingsViewModel.noCategoriesSelected() {
            MessageAlertView(parent: self, title: Constants.warning, message: Constants.categoryMessage).show(animated: true)
        } else {
            filterDelegate?.sendFilterArray(with: settingsViewModel.selections)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonTriggered(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func updateButtonTriggered(_ sender: Any) {
        settingsViewModel.getNewCategoryData()
        self.settingsCollectionView.reloadData()

        updateButton.isEnabled = false
        updateButton.tag = -1
        updateDelegate?.didUpdate(true)
    }

    @IBAction func buttonTrigerred(_ sender: CategoryButton) {
        settingsViewModel.setSelection(of: sender)
    }

}

// MARK: - UICollectionView
extension SettingsViewController: UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return settingsViewModel.numberOfSections()
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return settingsViewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        itemSize = collectionView.maxWidth()

        return CGSize(width: itemSize, height: itemSize)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: Strings.settingsHeader.rawValue,
            for: indexPath) as? SettingsHeaderView else { fatalError() }

        settingsViewModel.setupSectionHeaderView(view: header, section: indexPath.section)
        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: itemSize / 1.5)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return collectionView.centerItems()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Strings.settingsViewCell.rawValue, for: indexPath)
            as? SettingsCollectionViewCell else { fatalError() }

        guard let button = cell.imageButton else { fatalError() }
        let imageName = settingsViewModel.setupButton(button, tag: indexPath.item, section: indexPath.section)
        button.setImage(UIImage(named: imageName), for: .normal)

        return cell
    }
}
