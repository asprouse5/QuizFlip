//
//  String.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

extension String {
    func formatIconTitle() -> String {
        return self.replacingOccurrences(of: "-", with: "\n").capitalized
    }
}
