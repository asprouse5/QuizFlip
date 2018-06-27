//
//  MainViewController.swift
//  QuizFlip
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
    @IBOutlet var backButton: RoundRectButton!

    var nextQuestion = QAData()
    var showAnswer = false
    var isFirstTime = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap = UITapGestureRecognizer(target: self, action: #selector(qaTriggered(_:)))
        qaView.addGestureRecognizer(tap)
        qaLabel.setTextSize(label: qaLabel)
        categoryLabel.setTextSize(label: categoryLabel)

        if isFirstTime {
            IntroQuestionAlertView(parent: self).show(animated: true)
        } else {
            questionModel.filteredQuestions?.shuffle()
        }

        questionModel.delegate = self
        getNextQuestion()
    }

    func setFirstTime(_ isFirstTime: Any?) {
        guard let isFirstTime = isFirstTime as? Bool else { return }
        self.isFirstTime = isFirstTime
    }

    func getNextQuestion() {
        showAnswer = false
        questionModel.getNextQuestion()
    }

    @IBAction func backTriggered(_ sender: Any) {
        showAnswer = false
        questionModel.getPreviousQuestion()
    }

    @IBAction func nextTriggered(_ sender: UIButton) {
        getNextQuestion()
        backButton.isEnabled = true
    }

    // flips the question/answer
    @IBAction func qaTriggered(_ sender: UIButton) {
        UIView.transition(with: qaView, duration: 0.6, options: [.transitionFlipFromRight], animations: {
            self.showAnswer = !self.showAnswer
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                if self.showAnswer {
                    self.qaIcon.image = #imageLiteral(resourceName: "A")
                    self.qaLabel.text = self.nextQuestion.answer
                } else {
                    self.qaIcon.image = #imageLiteral(resourceName: "Q")
                    self.qaLabel.text = self.nextQuestion.question
                }
            }
        })
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.settingsSegue.rawValue,
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
            destination.updateDelegate = self
        }
    }
}

extension MainViewController: RandomQuestion {
    func sendQuestion(_ question: QAData, atBeginning: Bool) {
        self.nextQuestion = question
        DispatchQueue.main.async {
            if atBeginning {
                self.backButton.isEnabled = false
            }
            self.qaIcon.image = #imageLiteral(resourceName: "Q")
            self.qaLabel.text = self.nextQuestion.question
            self.categoryLabel.text = self.questionModel.formatCategory(self.nextQuestion.category)
        }
    }
}

// MARK: - QuestionFilterable Protocol

extension MainViewController: QuestionFilterable {
    func sendFilterArray(with selections: [Selection]?) {
        questionModel.filterQuestions(by: selections)
        getNextQuestion()
    }
}

// MARK: - Updated Protocol

extension MainViewController: Update {
    func didUpdate(_ updated: Bool) {
        if updated {
            questionModel.canUpdate = false
            questionModel.getNewStarterQuestions()
        }
    }
}
