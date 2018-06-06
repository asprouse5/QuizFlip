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

    override func viewDidAppear(_ animated: Bool) {
        // start async loading of JSON
        questionModel.getStarterQuestions {
            print("got starter questions")
        }

        //if questionModel.isFirstTime() {
            questionModel.getFirstAlert().show(animated: true)
            //alert.show(animated: true)
            //self.present(alert, animated: true)
        //}
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mainSegue",
            let destination = segue.destination as? MainViewController {
            destination.questionModel = questionModel
        }
    }
}
