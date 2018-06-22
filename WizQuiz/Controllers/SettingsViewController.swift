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

class SettingsViewController: UIViewController {

    @IBOutlet var settingsViewModel: SettingsViewModel!
    @IBOutlet var settingsCollectionView: UICollectionView!
    weak var filterDelegate: QuestionFilterable?

    override func viewDidLoad() {
        super.viewDidLoad()

        settingsViewModel.getCategories {
            self.settingsCollectionView.reloadData()
        }
    }

    @IBAction func okButtonTriggered(_ sender: Any) {
        settingsViewModel.saveUserDefaults()
        if settingsViewModel.noCategoriesSelected() {
            MessageAlertView(parent: self, title: Strings.warning, message: Strings.message).show(animated: true)
        } else {
            filterDelegate?.sendFilterArray(with: settingsViewModel.selections)
            dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func cancelButtonTriggered(_ sender: Any) {
        dismiss(animated: true, completion: nil)
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
        let size = collectionView.maxWidth()

        return CGSize(width: size, height: size)
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionElementKindSectionHeader,
            withReuseIdentifier: "SettingsHeader",
            for: indexPath) as? SettingsHeaderView else { fatalError() }
        settingsViewModel.setupSectionHeaderView(view: header, section: indexPath.section)

        return header
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SettingsViewCell", for: indexPath)
            as? SettingsCollectionViewCell else { fatalError() }

        guard let button = cell.imageButton else { fatalError() }
        let imageName = settingsViewModel.setupButton(button, tag: indexPath.item, section: indexPath.section)
        button.setImage(UIImage(named: imageName), for: .normal)

        return cell
    }
}
