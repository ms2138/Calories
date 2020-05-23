//
//  FormattedDate.swift
//  Calories
//
//  Created by mani on 2020-05-23.
//  Copyright © 2020 mani. All rights reserved.
//

import Foundation

protocol FormattedDate {
    var createdAt: Date { get set }

    func createdAtString() -> String
}

extension FormattedDate {
    func createdAtString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, YYYY"
        return dateFormatter.string(from: createdAt)
    }
}
