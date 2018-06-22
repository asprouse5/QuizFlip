//
//  QuestionModel.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

class QuestionModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    var questions: [QAData]?
    var filteredQuestions: [QAData]?
    let defaults = UserDefaults.standard

    func saveUserDefaults() {
        let encodedQuestions = try? PropertyListEncoder().encode(questions)
        defaults.set(encodedQuestions, forKey: "questions")
        let encodedFilteredQuestions = try? PropertyListEncoder().encode(filteredQuestions)
        defaults.set(encodedFilteredQuestions, forKey: "filteredQuestions")
    }

    func getUserDefaults(for key: String) -> Data? {
        guard let data = defaults.object(forKey: key) as? Data else { return nil }
        return data
    }

    func isFirstTime() -> Bool {
        return defaults.string(forKey: "version") == nil
    }

    func getVersion() {
        networkClient.getVersionNumber { version in
            self.defaults.set(version, forKey: "version")
        }
    }

    func getStarterQuestions(completion: @escaping () -> Void) {
        if let questionData = getUserDefaults(for: "questions") {
            // we have saved data
            guard let filteredQuestionData = getUserDefaults(for: "filteredQuestions") else { fatalError() }

            // decode questions
            let decodedQuestions = try? PropertyListDecoder().decode([QAData].self, from: questionData)
            questions = decodedQuestions

            // decode filteredQuestions
            let decodedFilteredQuestions = try? PropertyListDecoder().decode([QAData].self, from: filteredQuestionData)
            filteredQuestions = decodedFilteredQuestions

        } else {
            // no data saved, get some
            print("getting new data")
            getNewStarterQuestions()
        }
        completion()
    }

    func getNewStarterQuestions() {
        networkClient.getStarterQuestionData { questions in
            DispatchQueue.main.async {
                print("STARTER QUESTION COUNT: \(questions?.count ?? 0)")
                self.questions = questions
                self.filteredQuestions = self.questions
                print("CURRENT TOTAL: \(self.questions?.count ?? 0)")
                self.saveUserDefaults()
            }
            self.getVersion()
            self.getAllQuestions()
        }
    }

    func getAllQuestions() {
        networkClient.getAllQuestionData { questions in
            DispatchQueue.main.async {
                guard let questions = questions else { return }
                print("QUESTION COUNT: \(questions.count)")
                self.questions?.append(contentsOf: questions)
                self.filteredQuestions = self.questions
                print("CURRENT TOTAL: \(self.questions?.count ?? 0)")
                self.saveUserDefaults()
            }
        }
    }

    func filterQuestions(by selections: [Selection]?) {
        guard let selections = selections else { return }
        let selected = selections.filter({$0.selected == true}).compactMap({$0.name})
        filteredQuestions = questions?.filter { selected.contains($0.category) }
        filteredQuestions?.forEach { print($0.category) }
        saveUserDefaults()
    }

    func getRandomQuestion() -> QAData {
        guard let filteredQuestions = filteredQuestions else { return QAData() }
        let max = filteredQuestions.count
        let index = arc4random_uniform(UInt32(max))
        return filteredQuestions[Int(index)]
    }
}
