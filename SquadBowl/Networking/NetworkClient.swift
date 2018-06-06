//
//  CategoryData.swift
//  SquadBowl
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {

    func getVersionNumber(completion: @escaping (String) -> Void) {
        guard let starterJSONURL = URL(string: Constants.versionURL) else { return }

        guard let version = try? String(contentsOf: starterJSONURL) else {
            print("Error: Couldn't get version number")
            completion("")
            return
        }

        completion(version)

    }

    func getCategoryData(completion: @escaping ([Category]?) -> Void) {
        guard let plistURL = Bundle.main.url(forResource: "Category", withExtension: "plist") else {
            completion(nil) // category.plist not found!
            return
        }

        let propertyListDecoder = PropertyListDecoder()
        guard let propertyListData = try? Data(contentsOf: plistURL) else { return }
        guard let categories = try? propertyListDecoder.decode([Category].self, from: propertyListData)
            else { return }

        completion(categories)
    }

    func getStarterQuestionData(completion: @escaping ([QA]?) -> Void) {
        guard let starterJSONURL = URL(string: Constants.starterURL) else { return }

        URLSession.shared.dataTask(with: starterJSONURL) { data, response, error in
            guard error == nil else { return }

            guard let data = data else {
                print("Error: No data to decode")
                completion(nil)
                return
            }

            guard let response = try? JSONDecoder().decode([QA].self, from: data) else {
                print("Error: Couldn't decode data into QA")
                completion(nil)
                return
            }

            completion(response)
            }.resume()
    }

    func getAllQuestionData(completion: @escaping ([QA]?) -> Void) {
        guard let allJSONURL = URL(string: Constants.allURL) else { return }

        URLSession.shared.dataTask(with: allJSONURL) { data, response, error in
            guard error == nil else { return }

            guard let data = data else {
                print("Error: No data to decode")
                completion(nil)
                return
            }

            guard let response = try? JSONDecoder().decode([QA].self, from: data) else {
                print("Error: Couldn't decode data into QA")
                completion(nil)
                return
            }

            completion(response)
            }.resume()
    }
}
