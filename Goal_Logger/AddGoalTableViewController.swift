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
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var checkpointOneTextField: UITextField!
    @IBOutlet weak var checkpointTwoTextField: UITextField!
    
     let durationArray = ["Daily Goal", "Weekly Goal", "Monthly Goal", "Lifetime Goal"]
    let durationPickerView = UIPickerView()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        durationTextField.inputView = durationPickerView
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
       
        
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if goalNameTextField.text == "" {
            goalNameTextField.text = "Unnamed Goal"
        }
        
        if segue.identifier == "SaveGoalSegue",
            let goalName = goalNameTextField.text,
            let goalDuration = durationTextField.text,
            let checkpointOne = checkpointOneTextField.text,
            let checkpointTwo = checkpointTwoTextField.text{
            goal = Goal(name: goalName, duration: goalDuration, checkpointOne: checkpointOne, checkpointTwo: checkpointTwo)
        }
        
    }


}

extension AddGoalTableViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return durationArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return durationArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        durationTextField.text = durationArray[row]
        
        
        
    }
    


    
    
    
}
