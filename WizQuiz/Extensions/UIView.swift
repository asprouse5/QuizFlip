//
//  UIView.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/20/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

extension UIView {

    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }

    func asImage(layer: CAGradientLayer) -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { context in
            layer.render(in: context.cgContext)
        }
    }

    func setTextSize(label: UILabel?) {
        let textStyle: UIFontTextStyle
        if UIDevice.current.userInterfaceIdiom == .pad {
            textStyle = .largeTitle
        } else {
            textStyle = .title2
        }
        label?.adjustsFontForContentSizeCategory = true
        label?.font = UIFont.preferredFont(forTextStyle: textStyle)
    }
}
