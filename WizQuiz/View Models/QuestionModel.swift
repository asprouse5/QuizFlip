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
    let defaults = UserDefaults.standard

    func saveUserDefaults() {
        let encodedData = try? PropertyListEncoder().encode(questions)
        defaults.set(encodedData, forKey: "questions")
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
        if let data = defaults.object(forKey: "questions") as? Data,
            let decodedData = try? PropertyListDecoder().decode([QAData].self, from: data) {
            // data is saved
            print("using saved data")
            self.questions = decodedData
            completion()
        } else {
            // no data saved, get some
            print("getting new data")
            getNewStarterQuestions()
            completion()
        }
    }

    func getNewStarterQuestions() {
        networkClient.getStarterQuestionData { questions in
            DispatchQueue.main.async {
                print("STARTER QUESTION COUNT: \(questions?.count ?? 0)")
                self.questions = questions
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
                print("ALL QUESTION COUNT: \(questions?.count ?? 0)")
                self.questions? += questions!
                print("CURRENT TOTAL: \(self.questions?.count ?? 0)")
                self.saveUserDefaults()
            }
        }
    }

    func getRandomQuestion() -> QAData {
        guard let questions = questions else { return QAData() }
        let max = questions.count
        let index = arc4random_uniform(UInt32(max))
        return questions[Int(index)]
    }
}
