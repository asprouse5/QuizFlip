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
    @IBOutlet var loading: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
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

    func checkInternetConnection() {
        loading.startAnimating()
        questionModel.getVersion { version in
            if version == "" { // no internet
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "No Internet Connection",
                                                  message: "Please connect to the internet and try again.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                        self.checkInternetConnection()
                    }))
                    self.present(alert, animated: true)
                }
            } else { // internet
                self.finishSetup()
            }
        }
    }

    func finishSetup() {
        self.loading.stopAnimating()
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
