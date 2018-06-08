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
        // start async loading of JSON
        questionModel.getStarterQuestions {
            print("got starter questions")
        }

        if questionModel.isFirstTime() {
            IntroAlertView().show(animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainSegue",
            let destination = segue.destination as? MainViewController {
            destination.questionModel = questionModel
        }
    }
}
