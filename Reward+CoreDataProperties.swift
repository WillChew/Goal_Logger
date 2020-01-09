//
//  Reward+CoreDataProperties.swift
//  Goal_Logger
//
//  Created by Will Chew on 2020-01-06.
//  Copyright © 2020 Will Chew. All rights reserved.
//
//

import Foundation
import CoreData


extension Reward {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Reward> {
        return NSFetchRequest<Reward>(entityName: "Reward")
    }

    @NSManaged public var cost: Int32
    @NSManaged public var isRedeemed: Bool
    @NSManaged public var name: String?
    @NSManaged public var stock: Int32
    @NSManaged public var uuid: UUID?
    @NSManaged public var image: Data?

}
