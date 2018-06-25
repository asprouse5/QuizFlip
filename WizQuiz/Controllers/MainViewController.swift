//
//  MainViewController.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet var questionModel: QuestionModel!
    @IBOutlet var qaIcon: UIImageView!
    @IBOutlet var qaLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var qaView: UIView!

    var randQuestion = QAData()
    var showAnswer = false

    override func viewDidLoad() {
        super.viewDidLoad()
        getNextRandomQuestion()
        let tap = UITapGestureRecognizer(target: self, action: #selector(qaTriggered(_:)))
        qaView.addGestureRecognizer(tap)
        qaLabel.setTextSize(label: qaLabel)
        categoryLabel.setTextSize(label: categoryLabel)
    }

    func getNextRandomQuestion() {
        showAnswer = false
        randQuestion = questionModel.getRandomQuestion()
        DispatchQueue.main.async {
            self.qaIcon.image = #imageLiteral(resourceName: "Q")
            self.qaLabel.text = self.randQuestion.question
            self.categoryLabel.text = self.questionModel.formatCategory(self.randQuestion.category)
        }
    }

    @IBAction func nextTriggered(_ sender: UIButton) {
        getNextRandomQuestion()
    }

    // flips the question/answer
    @IBAction func qaTriggered(_ sender: UIButton) {
        UIView.transition(with: qaView, duration: 0.6, options: [.transitionFlipFromRight], animations: {
            self.showAnswer = !self.showAnswer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.showAnswer {
                    self.qaIcon.image = #imageLiteral(resourceName: "A")
                    self.qaLabel.text = self.randQuestion.answer
                } else {
                    self.qaIcon.image = #imageLiteral(resourceName: "Q")
                    self.qaLabel.text = self.randQuestion.question
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.settingsSegue.rawValue,
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
            destination.updateDelegate = self
            destination.setUpdateEnabled(questionModel.canUpdate)
        }
    }
}

// MARK: - QuestionFilterable Protocol

extension MainViewController: QuestionFilterable {
    func sendFilterArray(with selections: [Selection]?) {
        questionModel.filterQuestions(by: selections)
        getNextRandomQuestion()
    }
}

// MARK: - Updated Protocol

extension MainViewController: Updated {
    func didUpdate(_ updated: Bool) {
        if updated {
            questionModel.canUpdate = false
            questionModel.getNewStarterQuestions()
        }
    }
}
