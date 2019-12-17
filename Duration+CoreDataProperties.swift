//
//  Duration+CoreDataProperties.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-17.
//  Copyright © 2019 Will Chew. All rights reserved.
//
//

import Foundation
import CoreData


extension Duration {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Duration> {
        return NSFetchRequest<Duration>(entityName: "Duration")
    }

    @NSManaged public var name: String?
    @NSManaged public var goals: NSSet?

}

// MARK: Generated accessors for goals
extension Duration {

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: Goal)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: Goal)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSSet)

}
