//
//  Defaults.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/25/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

struct Defaults {
    static let defaults = UserDefaults.standard

    static func saveUserDefaults<T: Encodable>(key: String, value: [T]?) {
        let encodedSelections = try? PropertyListEncoder().encode(value)
        defaults.set(encodedSelections, forKey: key)
    }

    static func getUserDefaults(for key: String) -> Data? {
        guard let data = defaults.object(forKey: key) as? Data else { return nil }
        return data
    }

    static func getVersion() -> String? {
        return defaults.string(forKey: Strings.version.rawValue) ?? nil
    }

    static func saveVersion(version: String) {
        self.defaults.set(version, forKey: Strings.version.rawValue)
    }
}
