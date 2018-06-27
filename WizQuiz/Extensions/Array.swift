//
//  MutableCollection.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

extension Array {
    mutating func shuffle() {
        for _ in indices {
            sort { (_, _) in arc4random() < arc4random() }
        }
    }
}
