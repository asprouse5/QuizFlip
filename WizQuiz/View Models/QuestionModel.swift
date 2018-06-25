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
    var canUpdate = false

    func saveUserDefaults() {
        Defaults.saveUserDefaults(key: Strings.questions.rawValue, value: self.questions)
        Defaults.saveUserDefaults(key: Strings.filteredQuestions.rawValue, value: self.filteredQuestions)
    }

    func isFirstTime() -> Bool {
        return Defaults.getVersion() == nil
    }

    func isNewDataAvailable(completion: @escaping (Bool) -> Void) {
        let currentVersion = Defaults.getVersion()
        networkClient.getVersionNumber { version in
            Defaults.saveVersion(version: version)
            self.canUpdate = version != currentVersion
            completion(self.canUpdate)
        }
    }

    func getVersion() {
        networkClient.getVersionNumber { version in
            Defaults.saveVersion(version: version)
        }
    }

    func getCanUpdate() -> Bool {
        return canUpdate
    }

    func getStarterQuestions() {
        if let questionData = Defaults.getUserDefaults(for: Strings.questions.rawValue) {
            // we have saved data
            guard let filteredQuestionData = Defaults.getUserDefaults(for: Strings.filteredQuestions.rawValue)
                else { fatalError() }

            // decode questions
            let decodedQuestions = try? PropertyListDecoder().decode([QAData].self, from: questionData)
            questions = decodedQuestions

            // decode filteredQuestions
            let decodedFilteredQuestions = try? PropertyListDecoder().decode([QAData].self, from: filteredQuestionData)
            filteredQuestions = decodedFilteredQuestions

        } else {
            // no data saved, get some
            getNewStarterQuestions()
        }
    }

    func getNewStarterQuestions() {
        networkClient.getStarterQuestionData { questions in
            DispatchQueue.main.async {
                self.questions = questions
                self.filteredQuestions = self.questions
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
                self.questions?.append(contentsOf: questions)
                self.filteredQuestions = self.questions
                self.saveUserDefaults()
            }
        }
    }

    func filterQuestions(by selections: [Selection]?) {
        guard let selections = selections else { return }
        let selected = selections.filter({$0.selected == true}).compactMap({$0.name})
        filteredQuestions = questions?.filter { selected.contains($0.category) }
        saveUserDefaults()
    }

    func refilterQuestions() {
        guard let selectionData = Defaults.getUserDefaults(for: Strings.selections.rawValue) else { fatalError() }
        let selections = try? PropertyListDecoder().decode([Selection].self, from: selectionData)
        filterQuestions(by: selections)
    }

    func getRandomQuestion() -> QAData {
        guard var filteredQuestions = filteredQuestions else { return QAData() }

        let max = filteredQuestions.count
        let index = arc4random_uniform(UInt32(max))
        let randomQuestion = filteredQuestions[Int(index)]

        self.filteredQuestions?.remove(at: Int(index))
        if self.filteredQuestions?.count == 0 {
            refilterQuestions()
        }

        return randomQuestion
    }

    func formatCategory(_ category: String) -> String {
        return "Category: \(category.replacingOccurrences(of: "-", with: " ").capitalized)"
    }
}
