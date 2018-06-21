//
//  DataTransferable.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/1/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

protocol Modal {
    func show(animated: Bool)
    func dismiss(animated: Bool)
    var backgroundView: UIView { get }
    var contentView: UIView! { get set }
}

extension Modal where Self: UIView {
    func show(animated: Bool) {
        self.backgroundView.alpha = 0
        self.contentView.center = CGPoint(x: self.center.x,
                                         y: self.frame.height + self.contentView.frame.height / 2)
        UIApplication.shared.delegate?.window??.rootViewController?.view.addSubview(self)

        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0.66
            })
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: { self.contentView.center  = self.center },
                           completion: nil)
        } else {
            self.backgroundView.alpha = 0.66
            self.contentView.center  = self.center
        }
    }

    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33, animations: {
                self.backgroundView.alpha = 0
            }, completion: nil)
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: {
                            self.contentView.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height + self.contentView.frame.height/2) },
                           completion: { (_) in self.removeFromSuperview() })
        } else {
            self.removeFromSuperview()
        }

    }
}
