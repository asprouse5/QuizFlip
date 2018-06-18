//
//  Selection.swift
//  WizQuiz
//
//  Created by JTOG Mobile Development 1 on 6/13/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

struct Selection: Codable {
    let name: String
    var selected: Bool

    mutating func setSelected(_ value: Bool) {
        selected = value
    }
}
