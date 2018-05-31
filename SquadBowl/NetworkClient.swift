//
//  CategoryData.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class NetworkClient {
    public static let shared = NetworkClient()

    func readInCategoryData(completion: @escaping ([Category]?) -> Void) {
        guard let plistURL = Bundle.main.url(forResource: "Category", withExtension: "plist") else {
            return // category.plist not found!
        }

        let propertyListDecoder = PropertyListDecoder()
        guard let propertyListData = try? Data(contentsOf: plistURL) else { return }
        guard let categories = try? propertyListDecoder.decode([Category].self, from: propertyListData)
            else { return }

        completion(categories)
    }
}
