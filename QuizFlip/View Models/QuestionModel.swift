//
//  QuestionModel.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/5/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import Foundation

protocol RandomQuestion: class {
    func sendQuestion(_ question: QAData, disableBack: Bool)
}

protocol Version: class {
    func sendUpdate(available: Bool)
    func noInternet(firstTime: Bool)
    func sendFirstVersion(_ version: String)
}

class QuestionModel: NSObject {

    @IBOutlet var networkClient: NetworkClient!
    weak var randomDelegate: RandomQuestion?
    weak var versionDelegate: Version?
    var questions: [QAData]?
    var filteredQuestions: [QAData]?
    var questionNumber = -1
    var currentVersion: String?

    func saveUserDefaults() {
        Defaults.saveUserDefaults(key: Strings.questions.rawValue, value: self.questions)
        Defaults.saveUserDefaults(key: Strings.filteredQuestions.rawValue, value: self.filteredQuestions)
    }

    func isFirstTime() -> Bool {
        return Defaults.getUserDefaults(for: Strings.filteredQuestions.rawValue) == nil
    }

    // MARK: - Getting/saving version

    func getVersion() {
        currentVersion = Defaults.getVersion()
        networkClient.getVersionNumber { version in
            if version == "" { // no internet
                self.versionDelegate?.noInternet(firstTime: self.isFirstTime())
            } else if !self.isFirstTime() {
                self.versionDelegate?.sendUpdate(available: version != self.currentVersion)
            } else {
                Defaults.saveVersion(version: version)
                self.versionDelegate?.sendFirstVersion(version)
            }
            self.currentVersion = version
        }
    }

    func saveNewVersion() {
        Defaults.saveVersion(version: currentVersion)
    }

    // MARK: - Getting question data from network

    func getStarterQuestions() {
        if let questionData = Defaults.getUserDefaults(for: Strings.questions.rawValue),
            let filteredQuestionData = Defaults.getUserDefaults(for: Strings.filteredQuestions.rawValue) {

            let decodedQuestions = try? PropertyListDecoder().decode([QAData].self, from: questionData)
            questions = decodedQuestions

            let decodedFilteredQuestions = try? PropertyListDecoder().decode([QAData].self, from: filteredQuestionData)
            filteredQuestions = decodedFilteredQuestions

        } else {
            // no data saved, get some
            getNewStarterQuestions()
        }
    }

    private func getNewStarterQuestions() {
        networkClient.getStarterQuestionData { questions in
            self.questions = questions
            self.saveUserDefaults()
            self.getAllQuestions()
        }
    }

    private func getAllQuestions() {
        networkClient.getAllQuestionData { questions in
            DispatchQueue.main.async {
                guard let questions = questions else { return }
                self.questions?.append(contentsOf: questions)
                self.saveUserDefaults()
            }
        }
    }

    // MARK: - Question filtering and grabbing

    func filterQuestions(by selections: [Selection]?) {
        guard let selections = selections else { return }
        let selected = selections.filter({$0.selected == true}).compactMap({$0.name})
        filteredQuestions = questions?.filter { selected.contains($0.category) }
        filteredQuestions?.shuffle()
        questionNumber = -1
        saveUserDefaults()
    }

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
            randomDelegate?.sendQuestion(QAData(), disableBack: false)
            return
        }
        print("Question \(index) of \(filteredQuestions.count)")

        let returnQuestion: QAData
        let beginning = (index == 0)
        let end = (index == filteredQuestions.count)

        if end {
            questionNumber = -1
            self.filteredQuestions?.shuffle()
            returnQuestion = QAData(category: "", question: Constants.endQA, answer: Constants.endQA)
        } else {
            returnQuestion = filteredQuestions[index]
        }

        randomDelegate?.sendQuestion(returnQuestion, disableBack: beginning || end)
    }

    func formatCategory(_ category: String) -> String {
        return "Category: \(category.replacingOccurrences(of: "-", with: " "))"
    }
}
