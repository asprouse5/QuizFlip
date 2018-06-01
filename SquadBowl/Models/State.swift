//
//  State.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/31/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

struct State {
    let networkClient: NetworkClient
    var settingsViewModels: [SettingsViewModel]
    var isSelected: [Bool]
}
