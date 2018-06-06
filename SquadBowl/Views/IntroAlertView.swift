//
//  IntroAlertView.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class IntroAlertView: UIView, Modal {

    var backgroundView = UIView()
    var dialogView = UIView()
    @IBOutlet var contentView: UIView!

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        /*setup()

        backgroundView.frame = frame
        backgroundView.backgroundColor = UIColor.black
        backgroundView.alpha = 0.6
        addSubview(backgroundView)

        /*let dialogWidth = frame.width - 64

        let titleLabel = UILabel(frame: CGRect(x: 8,
                                               y: 8,
                                               width: dialogWidth - 16,
                                               height: 30))
        titleLabel.text = title
        titleLabel.textAlignment = .center
        dialogView.addSubview(titleLabel)

        let messageLabel = UILabel(frame: CGRect(x: 8,
                                                 y: titleLabel.frame.height + 8,
                                                 width: dialogWidth - 16,
                                                 height: 60))
        messageLabel.text = message
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        dialogView.addSubview(messageLabel)

        let imageButton = UIButton()
        imageButton.frame.size = CGSize(width: 77, height: 77)
        imageButton.frame.origin = CGPoint(x: dialogWidth / 2 - imageButton.frame.width / 2,
                                           y: messageLabel.frame.height + messageLabel.frame.origin.y + 8)
        imageButton.setImage(#imageLiteral(resourceName: "settings"), for: .normal)
        imageButton.setBackgroundImage(#imageLiteral(resourceName: "square_button_color"), for: .normal)
        imageButton.isUserInteractionEnabled = false
        dialogView.addSubview(imageButton)

        let dismissButton = UIButton()
        dismissButton.frame.size = CGSize(width: dialogWidth - 16, height: 30)
        dismissButton.frame.origin = CGPoint(x: dialogWidth / 2 - dismissButton.frame.width / 2,
                                           y: imageButton.frame.size.height + imageButton.frame.origin.y + 16)
        dismissButton.setTitle("Dismiss", for: .normal)
        dismissButton.backgroundColor = UIColor.teal
        dismissButton.addTarget(self, action: #selector(didDismissView), for: .touchUpInside)
        dismissButton.layer.cornerRadius = 10
        dialogView.addSubview(dismissButton)

        let dialogHeight = titleLabel.frame.height + 8 + messageLabel.frame.height + 8 +
            imageButton.frame.height + 8 + dismissButton.frame.height + 16
        dialogView.frame.origin = CGPoint(x: 32, y: frame.height)
        dialogView.frame.size = CGSize(width: frame.width-64, height: dialogHeight)
        dialogView.backgroundColor = UIColor.white
        dialogView.layer.cornerRadius = 6
        dialogView.clipsToBounds = true
        addSubview(dialogView)*/*/
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
        dialogView = contentView
        addSubview(contentView)
    }

    @IBAction func dismissTriggered(_ sender: Any) {
        dismiss(animated: true)
    }
}
