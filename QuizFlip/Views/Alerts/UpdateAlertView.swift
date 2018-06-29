//
//  SettingsHeaderView.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/7/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol UpdateAlertViewDelegate: class {
    func okTriggered()
}

class UpdateAlertView: UIView, Modal {

    @IBOutlet var contentView: UIView!
    var backgroundView = UIView()
    var parentViewController: UIViewController?
    weak var delegate: UpdateAlertViewDelegate?

    convenience init(parent: UIViewController) {
        self.init(frame: UIScreen.main.bounds)
        parentViewController = parent
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

        Bundle.main.loadNibNamed("UpdateAlertView", owner: self, options: nil)
        addSubview(contentView)
    }

    @IBAction func okTriggered(_ sender: Any) {
        delegate?.okTriggered()
        dismiss(animated: true)
    }

    @IBAction func cancelTriggered(_ sender: Any) {
        dismiss(animated: true)
    }

}
