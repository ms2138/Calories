//
//  CaloriesViewController.swift
//  Calories
//
//  Created by mani on 2020-05-24.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class CaloriesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var intakeRecord: Intake?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
