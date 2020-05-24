//
//  IntakeViewController.swift
//  Calories
//
//  Created by mani on 2020-05-18.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class IntakeViewController: UIViewController, NoContentBackgroundView {
    private let reuseIdentifier = "IntakeCell"
    
    @IBOutlet weak var tableView: UITableView!
    let dataManager = CoreDataManager(modelName: "Calories")
    lazy var managedObjectContext: NSManagedObjectContext = {
        return self.dataManager.managedObjectContext
    }()
    lazy var fetchedResultsController: NSFetchedResultsController<Intake> = {
        let fetchRequest = NSFetchRequest<Intake>(entityName: "Intake")
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                                  managedObjectContext: self.managedObjectContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        fetchedResultsController.delegate = self
        return fetchedResultsController
    }()
    lazy var backgroundView: DTTableBackgroundView = {
        let backgroundView = DTTableBackgroundView(frame: self.view.frame)
        backgroundView.messageLabel.text = "Please add a record"
        backgroundView.buttonTitle = "Add"
        backgroundView.handler = {
            self.addIntakeRecord(nil)
        }
        return backgroundView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Intake"

        navigationItem.leftBarButtonItem = editButtonItem

        tableView.backgroundView = backgroundView
        hideBackgroundView()

        fetch()

        setupNotifications()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let visibleCells = tableView.indexPathsForVisibleRows {
            tableView.reloadRows(at: visibleCells, with: .none)
        }
    }
}

extension IntakeViewController {
    // MARK: Notification methods

    private func setupNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.willTerminateNotification,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(save),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
}

extension IntakeViewController {
    // MARK: Core Data management methods

    @objc func save() {
        dataManager.saveContext()
    }

    private func fetch() {
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            print("Failed to fetch items: \(error)")
        }
    }

    @IBAction func addIntakeRecord(_ sender: UIBarButtonItem?) {
        let intake = Intake(context: managedObjectContext)

        intake.createdAt = Date()
    }
}

extension IntakeViewController {
    // MARK: Editing methods
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)

        tableView.setEditing(editing, animated: animated)
    }
}

extension IntakeViewController: UITableViewDataSource {
    // MARK: Table View data source methods

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }
        return sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sections = fetchedResultsController.sections else { return 0 }

        let sectionInfo = sections[section]
        if sectionInfo.numberOfObjects == 0 {
            showBackgroundView()
            return 0
        }

        hideBackgroundView()
        return sectionInfo.numberOfObjects
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
        guard editingStyle == .delete else { return }

        let item = fetchedResultsController.object(at: indexPath)

        managedObjectContext.delete(item)
    }
}

extension IntakeViewController: UITableViewDelegate {
    // MARK: Table View delegate methods

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isEditing {
            performSegue(withIdentifier: "showEditDatePicker", sender: self)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension IntakeViewController {
    // MARK: Table view cell setup method

    func configureCell(_ cell: UITableViewCell, at indexPath: IndexPath) {
        let item = fetchedResultsController.object(at: indexPath)
        if let consumed = item.value(forKeyPath: "calories.@sum.consumed") {
            cell.textLabel?.text = "Total calories: \(consumed)"
        }
        cell.detailTextLabel?.text = item.createdAtString()
    }
}

extension IntakeViewController: NSFetchedResultsControllerDelegate {
    // MARK: NSFetchedResultsController delegate methods

    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch (type) {
            case .insert:
                if let indexPath = newIndexPath {
                    tableView.insertRows(at: [indexPath], with: .fade)
            }
            case .delete:
                if let indexPath = indexPath {
                    tableView.deleteRows(at: [indexPath], with: .fade)
            }
            default:
                break
        }
    }
}
