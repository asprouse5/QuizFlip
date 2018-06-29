//
//  CategoryData.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {

    // used to check if first time or new data is available
    func getVersionNumber(completion: @escaping (String) -> Void) {
        guard let starterJSONURL = URL(string: Constants.versionURL) else { return }

        guard let version = try? String(contentsOf: starterJSONURL) else {
            print("Error: Couldn't get version number")
            completion("")
            return
        }

        completion(version)
    }

    // gets information for settings page
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

    // MARK: - Load question data from JSON

    func getStarterQuestionData(completion: @escaping ([QAData]?) -> Void) {
        guard let starterJSONURL = URL(string: Constants.starterURL) else { return }
        getJSONData(url: starterJSONURL, completion: completion)
    }

    func getAllQuestionData(completion: @escaping ([QAData]?) -> Void) {
        for categoryURL in Constants.allURLs {
            guard let url = URL(string: categoryURL) else { return }
            getJSONData(url: url, completion: completion)
        }
    }

    private func getJSONData(url: URL, completion: @escaping ([QAData]?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }

            guard let data = data else {
                print("Error: No data to decode")
                completion(nil)
                return
            }

            guard let response = try? JSONDecoder().decode([QAData].self, from: data) else {
                print("Error: Couldn't decode \(url) data into QAData")
                completion(nil)
                return
            }

            completion(response)
            }.resume()
    }
}
