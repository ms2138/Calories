//
//  AddCaloriesViewController.swift
//  Calories
//
//  Created by mani on 2020-05-24.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit
import CoreData

class AddCaloriesViewController: UITableViewController {
    @IBOutlet weak var caloriesCell: TextInputCell!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    var intakeRecord: Intake?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AddCaloriesViewController {
    // MARK: - View setup methods

    private func setupTextInputCell() {
        caloriesCell.textField.delegate = self
        caloriesCell.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        caloriesCell.textField.autocapitalizationType = .none
        caloriesCell.textField.placeholder = "Enter Calories"
        caloriesCell.textField.returnKeyType = .done
        caloriesCell.textField.enablesReturnKeyAutomatically = true
    }

    @objc func textDidChange(sender: UITextField) {
        saveBarButtonItem.isEnabled = !caloriesCell.textField.text!.isEmpty
    }
}

extension AddCaloriesViewController: UITextFieldDelegate {

}
