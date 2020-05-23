//
//  DateCell.swift
//  Calories
//
//  Created by mani on 2020-05-23.
//  Copyright © 2020 mani. All rights reserved.
//

import UIKit

class DateCell: UITableViewCell {
    private(set) lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()

        datePicker.datePickerMode = .date
        datePicker.date = Date()
        datePicker.maximumDate = Date()
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)

        contentView.addSubview(datePicker)

        return datePicker
    }()
    var dateChangedHandler: ((Date) -> Void)?

    @objc private func dateChanged(_ datePicker: UIDatePicker) {
        dateChangedHandler?(datePicker.date)
    }
}
