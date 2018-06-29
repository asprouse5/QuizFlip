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

    override func viewDidLoad() {
        super.viewDidLoad()
        questionModel.versionDelegate = self

        loading.startAnimating()
        questionModel.getVersion()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Strings.mainSegue.rawValue,
            let destination = segue.destination as? MainViewController {
            destination.questionModel = questionModel
        } else if segue.identifier == Strings.settingsSegue.rawValue,
            let destination = segue.destination as? SettingsViewController {
            destination.filterDelegate = self
            destination.setFirstTime(questionModel.isFirstTime())
        }
    }

    func getQuestions() {
        self.loading.stopAnimating()
        questionModel.getStarterQuestions()
    }

    private func showNoInternetAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "No Internet Connection",
                                          message: "Please connect to the internet and try again.",
                                          preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Retry", style: .default, handler: { _ in
                self.questionModel.getVersion()
            }))
            self.present(alert, animated: true)
        }
    }
}

extension HomeViewController: QuestionFilterable {
    func sendFilterArray(with selections: [Selection]?) {
        questionModel.filterQuestions(by: selections)
    }
}

extension HomeViewController: UpdateAlertViewDelegate {
    func okTriggered() {
        Defaults.prepareForUpdate()
        questionModel.saveNewVersion()
        questionModel.getStarterQuestions()
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Strings.settingsSegue.rawValue, sender: nil)
        }
    }
}

extension HomeViewController: Version {
    func sendUpdate(available: Bool) {
        if available {
            let alert = UpdateAlertView(parent: self)
            alert.delegate = self
            alert.show(animated: true)
        }
        getQuestions()
    }

    func noInternet(firstTime: Bool) {
        if firstTime {
            showNoInternetAlert()
        } else {
            getQuestions()
        }
    }

    func sendFirstVersion(_ version: String) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: Strings.settingsSegue.rawValue, sender: nil)
        }
        getQuestions()
    }
}
