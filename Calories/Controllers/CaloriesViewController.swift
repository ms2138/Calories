//
//  CaloriesViewController.swift
//  Calories
//
//  Created by mani on 2020-05-24.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class CaloriesViewController: UIViewController, NoContentBackgroundView {
    
    @IBOutlet weak var tableView: UITableView!
    var intakeRecord: Intake?
    var managedObjectContext: NSManagedObjectContext?
    lazy var backgroundView: DTTableBackgroundView = {
        let backgroundView = DTTableBackgroundView(frame: self.view.frame)
        backgroundView.messageLabel.text = "Please add calories"
        backgroundView.buttonTitle = "Add"
        backgroundView.handler = {
            self.performSegue(withIdentifier: "showAddCalorie", sender: nil)
        }
        return backgroundView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.backgroundView = backgroundView
        hideBackgroundView()
    }
}
