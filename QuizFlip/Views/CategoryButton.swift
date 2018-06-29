//
//  CategoryButton.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 5/31/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class CategoryButton: UIButton {

    var section = 0
    var category = ""
    var isHead = false
    let gradientLayer = CAGradientLayer()

    override func draw(_ rect: CGRect) {
        if isSelected {
            gradientLayer.colors = [UIColor.lightBlue.cgColor, UIColor.darkBlue.cgColor]
        } else {
            gradientLayer.colors = [UIColor.lightGray.cgColor, UIColor.darkGray.cgColor]
        }

        setBackground(gradient: gradientLayer)
        setTextSize(label: self.titleLabel)
    }
}
