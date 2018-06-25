//
//  ViewController.swift
//  WizQuiz
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var questionModel: QuestionModel!

    override func viewDidLoad() {
        super.viewDidLoad()

        if questionModel.isFirstTime() {
            IntroAlertView().show(animated: true)
        } else {
            questionModel.isNewDataAvailable { response in
                if response {
                    MessageAlertView(parent: self,
                                     title: "New Data Available",
                                     message: "Go to the Settings page to update your questions!").show(animated: true)
                }
            }
        }
        // start async loading of JSON
        questionModel.getStarterQuestions()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.mainSegue.rawValue,
            let destination = segue.destination as? MainViewController {
            destination.questionModel = questionModel
        } else if segue.identifier == Strings.settingsSegue.rawValue,
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
            destination.updateDelegate = self
            destination.setUpdateEnabled(questionModel.canUpdate)
        }
    }
}

// MARK: - QuestionFilterable Protocol

extension HomeViewController: QuestionFilterable {
    func sendFilterArray(with selections: [Selection]?) {
        questionModel.filterQuestions(by: selections)
    }
}

// MARK: - Updated Protocol

extension HomeViewController: Updated {
    func didUpdate(_ updated: Bool) {
        if updated {
            questionModel.canUpdate = false
            questionModel.getNewStarterQuestions()
        }
    }
}
