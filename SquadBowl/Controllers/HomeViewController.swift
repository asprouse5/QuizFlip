//
//  ViewController.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    var state: State?
    weak var delegate: DataTransferable?

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        //guard let state = state else { fatalError("State not set up") }
        // start async loading of JSON

        // check if there is updated data (online txt file)
        // if there is, display a popup to the user
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "settingsSegue",
            let destination = segue.destination as? SettingsViewController {
                destination.state = state
                destination.delegate = delegate
        }
    }
}

extension HomeViewController: DataTransferable {
    func passState(state: State?) {
        self.state = state
    }
}
