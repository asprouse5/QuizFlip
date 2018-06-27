//
//  DismissSegue.swift
//  QuizFlip
//
//  Created by Adriana Sprouse on 6/23/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
