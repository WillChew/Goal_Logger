//
//  AddGoalTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-09.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class AddGoalTableViewController: UITableViewController {
    
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext: NSManagedObjectContext!
    var currentDuration: Duration?
    let durationArray = ["Daily", "Weekly", "Monthly", "Annual"]
    let durationPickerView = UIPickerView()
    
    
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var checkpointOneTextField: UITextField!
    @IBOutlet weak var checkpointTwoTextField: UITextField!
    @IBOutlet weak var pointsTextField: UITextField!
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate?.persistentContainer.viewContext
        setupTextFields()
        let dismissKB = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        dismissKB.cancelsTouchesInView = false
        view.addGestureRecognizer(dismissKB)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: self)
        
    }
    
    fileprivate func setupTextFields() {
        durationTextField.inputView = durationPickerView
        durationTextField.text = durationArray[0]
        durationPickerView.delegate = self
        durationPickerView.dataSource = self
        goalNameTextField.delegate = self
        durationTextField.delegate = self
        checkpointOneTextField.delegate = self
        checkpointTwoTextField.delegate = self
        pointsTextField.delegate = self
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let kbSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: kbSize.height, right: 0)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    
    // #PRAMGA MARK: TABLEVIEW FUNCTIONS
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // #PRAMGA MARK: CORE DATA RELATED FUNCTIONS
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if goalNameTextField.text == "" {
            goalNameTextField.text = "Unnamed Goal"
        }
        
        if durationTextField.text == "" {
            durationTextField.text = durationArray[0]
        }
        
        if checkpointOneTextField.text == "" {
            checkpointOneTextField.text = "First Checkpoint"
        }
        
        if checkpointTwoTextField.text == "" {
            checkpointTwoTextField.text = "Second Checkpoint"
        }
        
        var futureDate = Date()
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd HH:mm"
        let minute: TimeInterval = 60.0
        let hour: TimeInterval = 60.0 * minute
        let day: TimeInterval = 24.0 * hour
        
        
        switch durationTextField.text {
        case "Daily":
            futureDate.addTimeInterval(day)
        case "Weekly":
            futureDate.addTimeInterval(day * 7.0)
        case "Monthly":
            futureDate.addTimeInterval(day * 30.0)
        case "Annual":
            futureDate.addTimeInterval(day * 365.0)
        default:
            print("No date")
        }
        
        
        
        guard let checkpointOne = checkpointOneTextField.text,
            let checkpointTwo = checkpointTwoTextField.text else { return }
        
        if segue.identifier == "SaveGoalSegue",
            let goalName = goalNameTextField.text,
            let goalDuration = durationTextField.text
            
        {
            do {
                let goal = Goal(context: managedContext)
                goal.name = goalName
                goal.duration = goalDuration
                goal.cpOne = checkpointOne
                goal.cpTwo = checkpointTwo
                goal.endDate = futureDate
                goal.startDate = Date()
                goal.uuid = UUID()
                goal.isCompleted = false
                
                var points: Int32 = 0
                if pointsTextField.text!.isEmpty {
                    switch durationTextField.text {
                    case "Daily":
                        goal.points = 300 as Int32
                        
                    case "Weekly":
                        goal.points = 600 as Int32
                    case "Monthly":
                        goal.points = 1800 as Int32
                    case "Annual":
                        goal.points = 3600 as Int32
                    default:
                        break
                    }
                } else {
                    points = Int32(pointsTextField.text!)!
                    goal.points = points
                }
                
                self.fetchDurationName(goalDuration)
                self.currentDuration?.addToGoals(goal)
                try self.managedContext.save()
            } catch let error as NSError {
                print("Error creating goal : \(error)")
            }
        }
        
    }
    
    
    
    func fetchDurationName(_ duration: String) {
        
        
        let goalFetch: NSFetchRequest<Duration> = Duration.fetchRequest()
        goalFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Duration.name), duration)
        
        do {
            let results = try managedContext.fetch(goalFetch)
            if results.count > 0 {
                currentDuration = results.first
                
            } else {
                currentDuration = Duration(context: managedContext)
                currentDuration?.name = duration
                try! managedContext.save()
            }
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
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
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
        
    }
    
    
    
    
    
    
}
