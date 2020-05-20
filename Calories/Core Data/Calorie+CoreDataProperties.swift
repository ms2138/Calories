//
//  Calorie+CoreDataProperties.swift
//  Calories
//
//  Created by mani on 2020-05-19.
//  Copyright © 2020 mani. All rights reserved.
//
//

import Foundation
import CoreData


extension Calorie {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Calorie> {
        return NSFetchRequest<Calorie>(entityName: "Calorie")
    }

    @NSManaged public var consumed: Double
    @NSManaged public var createdAt: Date
    @NSManaged public var intake: Intake

}
