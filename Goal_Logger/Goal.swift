//
//  Goal.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-08.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

struct Goal {
    var name: String
    var points: Int?
    var duration: String
    var isCompleted = false
    var checkpointOne: String
    var checkpointTwo: String
    var isCheckpointOneComplete: Bool = false
    var isCheckpointTwoComplete: Bool = false
    var startDate = Date()
    var endDate: Date
    var progress = 0



    
}


