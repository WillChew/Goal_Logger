//
//  Goal+CoreDataProperties.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-18.
//  Copyright © 2019 Will Chew. All rights reserved.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var cpOne: String?
    @NSManaged public var cpTwo: String?
    @NSManaged public var duration: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var isCpOneComplete: Bool
    @NSManaged public var isCpTwoComplete: Bool
    @NSManaged public var name: String?
    @NSManaged public var points: Int32
    @NSManaged public var progress: Double
    @NSManaged public var startDate: Date?
    @NSManaged public var uuid: UUID?
    @NSManaged public var time: Duration?

}
