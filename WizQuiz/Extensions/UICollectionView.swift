//
//  UICollectionView.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/21/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

extension UICollectionView {

    func maxWidth() -> CGFloat {
        let divisor: CGFloat
        let spacing: CGFloat

        if UIDevice.current.userInterfaceIdiom == .pad {
            divisor = 4
            spacing = 48
        } else {
            divisor = 3
            spacing = 16
        }

        return (bounds.width / divisor) - spacing
    }

    func centerItems() -> UIEdgeInsets {
        let cellCount: CGFloat = 3
        let cellSpacing: CGFloat

        if UIDevice.current.userInterfaceIdiom == .pad {
            cellSpacing = 48
        } else {
            cellSpacing = 16
        }

        let totalCellWidth = maxWidth() * cellCount
        let totalSpacingWidth = cellSpacing * (cellCount - 1)

        let leftInset = (bounds.width - CGFloat(totalCellWidth + totalSpacingWidth)) / 2
        let rightInset = leftInset

        return UIEdgeInsets(top: 0, left: leftInset, bottom: 0, right: rightInset)
    }

}
