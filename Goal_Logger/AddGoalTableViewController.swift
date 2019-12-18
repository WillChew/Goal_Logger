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
//    lazy var coreDataStack = CoreDataStack(modelName: "GoalLogger")
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    var managedContext: NSManagedObjectContext!
    
    
    var currentDuration: Duration?
    
    
    
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var durationTextField: UITextField!
    @IBOutlet weak var checkpointOneTextField: UITextField!
    @IBOutlet weak var checkpointTwoTextField: UITextField!
    
    let durationArray = ["Daily", "Weekly", "Monthly", "Annual"]
    let durationPickerView = UIPickerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        managedContext = appDelegate?.persistentContainer.viewContext
        durationTextField.inputView = durationPickerView
        durationTextField.text = durationArray[0]
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
        case "Daily":
            futureDate.addTimeInterval(day)
            points = 50
        case "Weekly":
            futureDate.addTimeInterval(day * 7.0)
            points = 250
        case "Monthly":
            futureDate.addTimeInterval(day * 30.0)
            points = 1000
        case "Annual":
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
            
            
            let goal = Goal(context: managedContext)
            goal.name = goalName
            goal.points = Int32(points)
            goal.duration = goalDuration
            
            
            goal.cpOne = checkpointOne
            goal.cpTwo = checkpointTwo
            goal.endDate = futureDate
            goal.startDate = Date()
            goal.uuid = UUID()
            
            
            
            
                self.fetchDurationName(goalDuration)
                self.currentDuration?.addToGoals(goal)
                try! self.managedContext.save()
                
            
            
            
            
            //            goal = Goal(name: goalName, points: points, duration: goalDuration, checkpointOne: checkpointOne, checkpointTwo: checkpointTwo, endDate: futureDate)
        }
        
    }
    
//    func fetchAll() {
//       let allGoals = "All"
//       let goalFetch: NSFetchRequest<Duration> = Duration.fetchRequest()
//       goalFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Duration.name), allGoals)
//
//       do {
//           let results = try managedContext.fetch(goalFetch)
//           if results.count > 0 {
//               currentDuration = results.first
//           } else {
//               currentDuration = Duration(context: managedContext)
//               currentDuration?.name = allGoals
//               try! managedContext.save()
//           }
//       } catch let error as NSError {
//           print("Fetch error: \(error) description: \(error.userInfo)")
//       }
//       }
    
    
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
    
    
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        if durationTextField.text!.isEmpty {
    //            durationTextField.text = durationArray[0]
    //            textField.endEditing(true)
    //        }
    //    }
    
    
    
    
    
    
}
