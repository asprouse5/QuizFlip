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
    @IBOutlet var questionLabel: UILabel!
    @IBOutlet var answerLabel: UILabel!

    override func viewDidAppear(_ animated: Bool) {
        getNextRandomQuestion()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func getNextRandomQuestion() {
        let randQuestion = questionModel.getRandomQuestion()
        DispatchQueue.main.async {
            self.questionLabel.text = randQuestion.question
            self.answerLabel.text = randQuestion.answer
        }
    }

    @IBAction func nextTriggered(_ sender: UIButton) {
        getNextRandomQuestion()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue",
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
        }
    }
}

extension MainViewController: QuestionFilterable {
    func sendFilterArray(_ selections: [Selection]?) {
        questionModel.filterQuestions(selections)
    }
}
