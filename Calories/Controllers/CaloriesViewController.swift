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
    fileprivate var fetchedResults = Array<Calorie>()
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

extension CaloriesViewController {
    // MARK: Setup methods

    private func loadFetchedResults() {
        guard let intake = intakeRecord else { return }

        let sortDateDescriptor = NSSortDescriptor(key: "createdAt", ascending: false)
        let sortDescriptors = Array(arrayLiteral: sortDateDescriptor)
        fetchedResults = intake.calories?.sortedArray(using: sortDescriptors) as! [Calorie]

        tableView.reloadData()
    }
}
