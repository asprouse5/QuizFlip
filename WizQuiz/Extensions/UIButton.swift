//
//  UIButton.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

extension UIButton {
    func alignImageAndTitleVertically(padding: CGFloat = 1.0) {
        let imageSize = imageView!.frame.size
        let titleSize = titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: (frame.size.width - imageSize.width) / 2,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

    func tagWith(offset: Int) -> Int {
        return tag + (offset * Constants.multiplier)
    }

    func setBackground(gradient: CAGradientLayer) {
        gradient.frame = bounds
        gradient.cornerRadius = cornerRadius

        layer.insertSublayer(gradient, at: 0)
        let backImage = asImage(layer: gradient)
        setBackgroundImage(backImage, for: .normal)
    }

}
