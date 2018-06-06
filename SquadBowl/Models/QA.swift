//
//  QA.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 6/1/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

struct QA: Codable {
    let category: String
    let question: String
    let answer: String

    init(category: String = "", question: String = "No Question Data", answer: String = "No Answer Data") {
        self.category = category
        self.question = question
        self.answer = answer
    }
}
