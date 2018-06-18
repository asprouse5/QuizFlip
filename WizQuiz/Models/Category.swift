//
//  Category.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

struct Category: Codable {
    let title: String
    let icons: [String]

    var names: [String] {
        var strings = icons
        strings.insert(title, at: 0)
        return strings
    }
}
