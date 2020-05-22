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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
