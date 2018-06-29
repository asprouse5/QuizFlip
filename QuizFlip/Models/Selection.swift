//
//  Selection.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/13/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class Selection: Codable {
    let name: String
    var selected: Bool

    init(name: String) {
        self.name = name
        self.selected = false
    }

    func setSelected(_ value: Bool) {
        selected = value
    }
}
