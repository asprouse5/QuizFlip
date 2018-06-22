//
//  SettingsHeaderView.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/7/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class MessageAlertView: UIView, Modal {

    @IBOutlet var contentView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var messageLabel: UILabel!
    var backgroundView = UIView()
    var parentViewController: UIViewController?

    convenience init(parent: UIViewController, title: String, message: String) {
        self.init(frame: UIScreen.main.bounds)
        parentViewController = parent
        titleLabel.text = title
        messageLabel.text = message
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    private func setup() {
        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)

        Bundle.main.loadNibNamed("MessageAlertView", owner: self, options: nil)
        addSubview(contentView)
    }

    @IBAction func okTriggered(_ sender: Any) {
        dismiss(animated: true)
    }
}
