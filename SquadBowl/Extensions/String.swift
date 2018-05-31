//
//  String.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/30/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

extension String {
    func formatIconTitle() -> String {
        return self.replacingOccurrences(of: "-", with: "\n").capitalized
    }
}
