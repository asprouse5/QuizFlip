//
//  RoundRectButton.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/20/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class RoundRectButton: UIButton {
    let gradientLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        switch tag {
        case 0: // small buttons
            gradientLayer.colors = [UIColor.lightYellow.cgColor, UIColor.darkYellow.cgColor]
        case 1: // medium buttons
            gradientLayer.colors = [UIColor.lightOrange.cgColor, UIColor.darkOrange.cgColor]
        case 2: // large play button
            gradientLayer.colors = [UIColor.lightBlue.cgColor, UIColor.darkBlue.cgColor]
        default: // disabled buttons
            gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor]
        }

        setBackground(gradient: gradientLayer)
        setTextSize(label: self.titleLabel)
    }

}
