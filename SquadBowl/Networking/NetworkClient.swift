//
//  CategoryData.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class NetworkClient: NSObject {

    func readInCategoryData(completion: @escaping ([Category]?) -> Void) {
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

    func getQuestionData(completion: @escaping ([QA]?) -> Void) {
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

            /*let decoder = JSONDecoder()
            do {
                let jsonStarter = try decoder.decode([QA].self, from: data)
                completion(jsonStarter)
            } catch {
                print("error trying to convert data to JSON")
                print(error)
                completion(nil)
            }
            }.resume()*/

        /*let jsonDecoder = JSONDecoder()
         guard let starterJSONData = try? Data(contentsOf: starterJSONURL) else { return }
         guard let jsonStarter = try? jsonDecoder.decode([QA].self, from: starterJSONData) else { return }

         completion(jsonStarter)*/
    }
}
