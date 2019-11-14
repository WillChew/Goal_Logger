//
//  Goal.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-08.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class Goal {
    var name: String
    var duration: String
    var isCompleted = false
    var checkpointOne: String
    var checkpointTwo: String
    
    init(name: String, duration: String, checkpointOne: String, checkpointTwo: String) {
        self.name = name
        self.duration = duration
        self.checkpointOne = checkpointOne
        self.checkpointTwo = checkpointTwo
    }
    
}


