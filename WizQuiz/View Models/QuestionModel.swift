//
//  QuestionModel.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

protocol RandomQuestion: class {
    func sendQuestion(_ question: QAData, atBeginning: Bool)
}

class QuestionModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    weak var delegate: RandomQuestion?
    var questions: [QAData]?
    var filteredQuestions: [QAData]?
    var canUpdate = false
    var questionNumber = -1

    func saveUserDefaults() {
        Defaults.saveUserDefaults(key: Strings.questions.rawValue, value: self.questions)
        Defaults.saveUserDefaults(key: Strings.filteredQuestions.rawValue, value: self.filteredQuestions)
    }

    func isFirstTime() -> Bool {
        return Defaults.getUserDefaults(for: Strings.questions.rawValue) == nil
    }

    func isNewDataAvailable(completion: @escaping (Bool) -> Void) {
        let currentVersion = Defaults.getVersion()
        networkClient.getVersionNumber { version in
            Defaults.saveVersion(version: version)
            self.canUpdate = version != currentVersion
            completion(self.canUpdate)
        }
    }

    func getVersion(completion: @escaping (String) -> Void) {
        networkClient.getVersionNumber { version in
            Defaults.saveVersion(version: version)
            completion(version)
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
                self.questions = questions
                self.filteredQuestions = self.questions
                self.saveUserDefaults()
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
        filteredQuestions?.shuffle()
        questionNumber = -1
        saveUserDefaults()
    }

    /*func refilterQuestions() {
        guard let selectionData = Defaults.getUserDefaults(for: Strings.selections.rawValue) else { fatalError() }
        let selections = try? PropertyListDecoder().decode([Selection].self, from: selectionData)
        filterQuestions(by: selections)
    }*/

    func getNextQuestion() {
        questionNumber += 1
        getQuestion(at: questionNumber)
    }

    func getPreviousQuestion() {
        questionNumber -= 1
        getQuestion(at: questionNumber)
    }

    private func getQuestion(at index: Int) {
        guard var filteredQuestions = filteredQuestions else {
            delegate?.sendQuestion(QAData(), atBeginning: false)
            return
        }
        print("Question \(index) of \(filteredQuestions.count)")

        let returnQuestion: QAData
        let beginning = (index == 0)

        if index == filteredQuestions.count {
            questionNumber = -1
            self.filteredQuestions?.shuffle()
            returnQuestion = QAData(category: "", question: Constants.endQA, answer: Constants.endQA)
        } else {
            returnQuestion = filteredQuestions[index]
        }

        delegate?.sendQuestion(returnQuestion, atBeginning: beginning)
    }

    func formatCategory(_ category: String) -> String {
        return "Category: \(category.replacingOccurrences(of: "-", with: " "))"
    }
}
