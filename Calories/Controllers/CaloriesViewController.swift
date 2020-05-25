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
    private let reuseIdentifier = "CalorieCell"
    
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

extension CaloriesViewController {
    // MARK: Table view cell configuration methods

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let item = fetchedResults[indexPath.row]
        cell.textLabel?.text = "Consumed: \(item.consumed)"
        cell.detailTextLabel?.text = item.createdAtString()
    }
}

extension CaloriesViewController: UITableViewDataSource {
    // MARK: Table View data source methods

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if fetchedResults.count == 0 {
            showBackgroundView()
            return 0
        }

        hideBackgroundView()
        return fetchedResults.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)

        configureCell(cell, at: indexPath)

        return cell
    }
}
