//
//  IntakeViewController.swift
//  Calories
//
//  Created by mani on 2020-05-18.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class IntakeViewController: UIViewController {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
