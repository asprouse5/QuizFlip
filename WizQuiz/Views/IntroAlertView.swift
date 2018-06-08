//
//  IntroAlertView.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class IntroAlertView: UIView, Modal {

    var backgroundView = UIView()
    @IBOutlet var contentView: UIView!

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
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

        Bundle.main.loadNibNamed("IntroAlertView", owner: self, options: nil)
        addSubview(contentView)
    }

    @IBAction func dismissTriggered(_ sender: Any) {
        dismiss(animated: true)
    }
}
