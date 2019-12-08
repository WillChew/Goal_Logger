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
    
    let durationArray = ["Daily Goal", "Weekly Goal", "Monthly Goal", "Annual Goal"]
    let durationPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        durationTextField.inputView = durationPickerView
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if goalNameTextField.text == "" {
            goalNameTextField.text = "Unnamed Goal"
        }
        
        if durationTextField.text == "" {
            durationTextField.text = durationArray[0]
        }
        
        if checkpointOneTextField.text == "" {
            checkpointOneTextField.text = "checkpoint one"
        }
        
        if checkpointTwoTextField.text == "" {
            checkpointTwoTextField.text = "checkpoint two"
        }
        
        
        
        var futureDate = Date()
        var points = 0
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd HH:mm"
        
        
        let minute: TimeInterval = 60.0
        let hour: TimeInterval = 60.0 * minute
        let day: TimeInterval = 24.0 * hour
        
        
        
        
        
        switch durationTextField.text {
        case "Daily Goal":
            futureDate.addTimeInterval(day)
            points = 50
        case "Weekly Goal":
            futureDate.addTimeInterval(day * 7.0)
            points = 250
        case "Monthly Goal":
            futureDate.addTimeInterval(day * 30.0)
            points = 1000
        case "Annual Goal":
            futureDate.addTimeInterval(day * 365.0)
            points = 2500
        default:
            print("No date")
        }
        
        
        guard let checkpointOne = checkpointOneTextField.text,
            let checkpointTwo = checkpointTwoTextField.text else { return }
        
        if segue.identifier == "SaveGoalSegue",
            let goalName = goalNameTextField.text,
            let goalDuration = durationTextField.text
            
        {
            goal = Goal(name: goalName, points: points, duration: goalDuration, checkpointOne: checkpointOne, checkpointTwo: checkpointTwo, endDate: futureDate)
        }
        
    }
    
    
}

extension AddGoalTableViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
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
    
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if durationTextField.text!.isEmpty {
    //            durationTextField.text = durationArray[0]
    //            textField.endEditing(true)
    //        }
    //    }
    
    
    
    
    
    
}
