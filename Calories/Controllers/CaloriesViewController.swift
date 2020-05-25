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

        updateTitleWithCalorieTotal()

        tableView.backgroundView = backgroundView
        hideBackgroundView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        loadFetchedResults()
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

    private func updateTitleWithCalorieTotal() {
        guard let intake = intakeRecord else { return }

        if let consumed = intake.value(forKeyPath: "calories.@sum.consumed") {
            title = "Calories(\(consumed))"
        }
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

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete, let managedObjectContext = managedObjectContext else { return }

        let item = fetchedResults.remove(at: indexPath.row)

        managedObjectContext.delete(item)

        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

extension CaloriesViewController {
    // MARK: - Segue methods

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
            case "showAddCalories":
                guard let managedObjectContext = managedObjectContext else { return }
                let navController = segue.destination as! UINavigationController
                guard let viewController = navController.topViewController else { return }
                guard let intake = intakeRecord else { return }
                let vc = viewController as! AddCaloriesViewController
                vc.intakeRecord = intake
                vc.managedObjectContext = managedObjectContext
            default:
                preconditionFailure("Segue identifier did not match")
        }
    }

    @IBAction func unwindToCalories(segue: UIStoryboardSegue) {
        loadFetchedResults()

        updateTitleWithCalorieTotal()
    }
}
