//
//  SettingsCollectionTableViewCell.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/21/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var settingsCollectionView: UICollectionView!

    func setCollectionViewTag(tag: Int) {
        settingsCollectionView.tag = tag
    }
}
