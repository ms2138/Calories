//
//  Intake+CoreDataProperties.swift
//  Calories
//
//  Created by mani on 2020-05-19.
//  Copyright © 2020 mani. All rights reserved.
//
//

import Foundation
import CoreData


extension Intake {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Intake> {
        return NSFetchRequest<Intake>(entityName: "Intake")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var calories: NSSet

}

// MARK: Generated accessors for calories
extension Intake {

    @objc(addCaloriesObject:)
    @NSManaged public func addToCalories(_ value: Calorie)

    @objc(removeCaloriesObject:)
    @NSManaged public func removeFromCalories(_ value: Calorie)

    @objc(addCalories:)
    @NSManaged public func addToCalories(_ values: NSSet)

    @objc(removeCalories:)
    @NSManaged public func removeFromCalories(_ values: NSSet)

}
