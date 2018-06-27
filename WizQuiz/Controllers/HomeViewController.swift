//
//  ViewController.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet var questionModel: QuestionModel!
    @IBOutlet var loading: UIActivityIndicatorView!
    var isFirstTime = false

    override func viewDidLoad() {
        super.viewDidLoad()
        checkInternetConnection()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.mainSegue.rawValue,
            let destination = segue.destination as? MainViewController {
            destination.questionModel = questionModel
            destination.setFirstTime(isFirstTime)
        } else if segue.identifier == Strings.settingsSegue.rawValue,
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
            destination.updateDelegate = self
            destination.setFirstTime(isFirstTime)
        }
    }

    func checkInternetConnection() {
        loading.startAnimating()
        questionModel.getVersion { version in
            if version == "" { // no internet
                self.showNoInternetAlert()
            } else { // internet
                self.finishSetup()
            }
        }
    }

    private func showNoInternetAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No Internet Connection",
                                          message: "Please connect to the internet and try again.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                self.checkInternetConnection()
            }))
            self.present(alert, animated: true)
        }
    }

    func finishSetup() {
        self.loading.stopAnimating()
        if questionModel.isFirstTime() {
            isFirstTime = true
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: Strings.settingsSegue.rawValue, sender: nil)
            }
        } else {
            questionModel.isNewDataAvailable { response in
                if response {
                    let alert = UpdateAlertView(parent: self)
                    alert.delegate = self
                    alert.show(animated: true)
                }
            }
        }

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

extension HomeViewController: Update {
    func didUpdate(_ updated: Bool) {
        if updated {
            questionModel.canUpdate = false
            questionModel.getNewStarterQuestions()
        }
    }
}

extension HomeViewController: UpdateAlertViewDelegate {
    func okTriggered() {
        Defaults.defaults.removeObject(forKey: Strings.categories.rawValue)
        Defaults.defaults.removeObject(forKey: Strings.selections.rawValue)
        questionModel.getNewStarterQuestions()
    }
}
