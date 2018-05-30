//
//  SettingsTableViewCell.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/29/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet var mainCatButton: UIButton!
    @IBOutlet var cat1Button: UIButton!
    @IBOutlet var cat2Button: UIButton!
    @IBOutlet var cat3Button: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
