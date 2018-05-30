//
//  SettingsViewController.swift
//  SquadBowl
//
//  Created by JTOG Mobile Development 1 on 5/27/18.
//  Copyright © 2018 Sprouse. All rights reserved.
//

import UIKit

enum LabelTags: Int {
    case headCategory = 100
    case category1 = 101
    case category2 = 102
    case category3 = 103
}

class SettingsViewController: UITableViewController {

    let cellIdentifier = "SettingsTableViewCell"
    let headCategory = "HeadCategory"

    override func viewDidLoad() {
        super.viewDidLoad()
        //let imageView = #imageLiteral(resourceName: "bg")
        self.tableView.backgroundView = UIImageView(image: #imageLiteral(resourceName: "bg"))
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    // Sets each cell's background color to clear
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = UIColor.clear
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                as? SettingsTableViewCell else {
            fatalError("Error initializing cell as a SettingsTableViewCell.")
        }

        let headerButton = cell.mainCatButton
        let cat1Button = cell.cat1Button
        /*let cat2Button = cell.cat2Button
        let cat3Button = cell.cat3Button*/

        cat1Button?.alignImageAndTitleVertically()
        headerButton?.tag = indexPath.row

        return cell
    }

    @IBAction func buttonTrigerred(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.accessibilityLabel == headCategory {
            //select/deselect all other buttons
            guard let cell = tableView.cellForRow(at: IndexPath(row: sender.tag, section: 0))
                as? SettingsTableViewCell else {
                    fatalError("Error initializing cell as a SettingsTableViewCell.")
            }

            let shouldBeSelected = sender.isSelected

            cell.cat1Button.isSelected = shouldBeSelected
            cell.cat2Button.isSelected = shouldBeSelected
            cell.cat3Button.isSelected = shouldBeSelected
        }
    }

}

extension UIButton {

    func alignImageAndTitleVertically(padding: CGFloat = 1.0) {
        let imageSize = self.imageView!.frame.size
        let titleSize = self.titleLabel!.frame.size
        let totalHeight = imageSize.height + titleSize.height + padding

        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageSize.height),
            left: 0, //(self.frame.size.width - imageSize.width) / 2,
            bottom: 0,
            right: -titleSize.width
        )

        self.titleEdgeInsets = UIEdgeInsets(
            top: 0,
            left: -imageSize.width,
            bottom: -(totalHeight - titleSize.height),
            right: 0
        )
    }

}
