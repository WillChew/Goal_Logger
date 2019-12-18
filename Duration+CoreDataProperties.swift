//
//  Duration+CoreDataProperties.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-18.
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
    @NSManaged public var goals: NSOrderedSet?

}

// MARK: Generated accessors for goals
extension Duration {

    @objc(insertObject:inGoalsAtIndex:)
    @NSManaged public func insertIntoGoals(_ value: Goal, at idx: Int)

    @objc(removeObjectFromGoalsAtIndex:)
    @NSManaged public func removeFromGoals(at idx: Int)

    @objc(insertGoals:atIndexes:)
    @NSManaged public func insertIntoGoals(_ values: [Goal], at indexes: NSIndexSet)

    @objc(removeGoalsAtIndexes:)
    @NSManaged public func removeFromGoals(at indexes: NSIndexSet)

    @objc(replaceObjectInGoalsAtIndex:withObject:)
    @NSManaged public func replaceGoals(at idx: Int, with value: Goal)

    @objc(replaceGoalsAtIndexes:withGoals:)
    @NSManaged public func replaceGoals(at indexes: NSIndexSet, with values: [Goal])

    @objc(addGoalsObject:)
    @NSManaged public func addToGoals(_ value: Goal)

    @objc(removeGoalsObject:)
    @NSManaged public func removeFromGoals(_ value: Goal)

    @objc(addGoals:)
    @NSManaged public func addToGoals(_ values: NSOrderedSet)

    @objc(removeGoals:)
    @NSManaged public func removeFromGoals(_ values: NSOrderedSet)

}
