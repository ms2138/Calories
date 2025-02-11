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
    @IBOutlet weak var nameCell: TextInputCell!
    @IBOutlet weak var caloriesCell: TextInputCell!
    @IBOutlet weak var saveBarButtonItem: UIBarButtonItem!
    var intakeRecord: Intake?
    var managedObjectContext: NSManagedObjectContext?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Add Calories"
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupTextInputCell()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        nameCell.textField.becomeFirstResponder()
    }
}

extension AddCaloriesViewController {
    // MARK: - IBAction methods

    @IBAction func cancel(_ sender: UIBarButtonItem?) {
        dismiss(animated: true)
    }

    @IBAction func save(_ sender: UIBarButtonItem?) {
        guard let input = Double(caloriesCell.textField.text!) else {
            showAlert(title: "Error", message: "Please enter a valid number of calories")
            return
        }
        guard let name = nameCell.textField.text else {
            showAlert(title: "Error", message: "Please enter a name")
            return
        }

        guard let managedObjectContext = managedObjectContext else { return }
        guard let intake = intakeRecord else { return }

        let calorie = Calorie(context: managedObjectContext)
        calorie.name = name
        calorie.consumed = input
        calorie.createdAt = Date()

        intake.addToCalories(calorie)

        performSegue(withIdentifier: "unwindToCalories", sender: self)
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

        nameCell.textField.delegate = self
        nameCell.textField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        nameCell.textField.autocapitalizationType = .none
        nameCell.textField.placeholder = "Enter name"
        nameCell.textField.returnKeyType = .next
        nameCell.textField.enablesReturnKeyAutomatically = true
    }

    @objc func textDidChange(sender: UITextField) {
        saveBarButtonItem.isEnabled = !caloriesCell.textField.text!.isEmpty &&
                                      !nameCell.textField.text!.isEmpty
    }
}

extension AddCaloriesViewController: UITextFieldDelegate {
    // MARK: - Text field delegate methods

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.returnKeyType == .done {
            textField.resignFirstResponder()
            save(nil)
            return true
        } else if textField.returnKeyType == .next {
            textField.resignFirstResponder()
            caloriesCell.textField.becomeFirstResponder()
        }
        return false
    }
}
