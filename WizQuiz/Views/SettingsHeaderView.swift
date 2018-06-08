//
//  SettingsHeaderView.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/7/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class SettingsHeaderView: UIView {

    @IBOutlet var headerButton: CategoryButton!
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        Bundle.main.loadNibNamed("SettingsHeaderView", owner: self, options: nil)
        self.contentView.frame.size.width = frame.width
        self.contentView.frame.size.height = frame.height
        addSubview(contentView)
    }
}
