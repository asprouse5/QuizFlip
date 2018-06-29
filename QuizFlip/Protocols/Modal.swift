//
//  DataTransferable.swift
//  QuizFlip
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
    var parentViewController: UIViewController? { get set }
}

extension Modal where Self: UIView {
    func show(animated: Bool) {
        backgroundView.alpha = 0
        contentView.center = CGPoint(x: center.x,
                                         y: frame.height + contentView.frame.height / 2)

        parentViewController?.view.addSubview(self)

        if animated {
            UIView.animate(withDuration: 0.33) { self.backgroundView.alpha = 0.66 }
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 10,
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: { self.contentView.center  = self.center },
                           completion: nil)
        } else {
            backgroundView.alpha = 0.66
            contentView.center  = center
        }
    }

    func dismiss(animated: Bool) {
        if animated {
            UIView.animate(withDuration: 0.33) { self.backgroundView.alpha = 0 }
            UIView.animate(withDuration: 0.33,
                           delay: 0,
                           usingSpringWithDamping: 1,
                           initialSpringVelocity: 10,
                           options: UIViewAnimationOptions(rawValue: 0),
                           animations: {
                            self.contentView.center = CGPoint(x: self.center.x,
                                                             y: self.frame.height + self.contentView.frame.height/2) },
                           completion: { _ in self.removeFromSuperview() })
        } else {
            self.removeFromSuperview()
        }

    }
}
