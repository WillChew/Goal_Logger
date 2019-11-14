//
//  AddGoalTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-09.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class AddGoalTableViewController: UITableViewController {
    
    var goal: Goal?
    
    @IBOutlet weak var goalNameTextField: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveGoalSegue",
            let goalName = goalNameTextField.text {
            goal = Goal(name: goalName)
        }
        
    }


}
