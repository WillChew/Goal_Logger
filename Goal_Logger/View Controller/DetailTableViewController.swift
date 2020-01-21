//
//  DetailTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-22.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData


class DetailTableViewController: UITableViewController {
    
    let cpOneCriteria = "isCpOneComplete"
    let cpTwoCriteria = "isCpTwoComplete"
    var passedGoal: Goal!
    var managedContext: NSManagedObjectContext!
    var editMode = false
    lazy var dateFormatter : DateFormatter = {
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "MMM d, yyyy"
        return format
    }()
    
    
    
    @IBOutlet weak var firstCPTextField: UITextField!
    @IBOutlet weak var secondCPTextField: UITextField!
    @IBOutlet weak var goalNameTextField: UITextField!
    @IBOutlet weak var completeButton: UIButton!
    @IBOutlet weak var cpOneSwitch: UISwitch!
    @IBOutlet weak var cpTwoSwitch: UISwitch!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        configureTextFields()
        
        if passedGoal.isCpOneComplete == true {
            cpOneSwitch.isOn = true
        } else {
            cpOneSwitch.isOn = false
        }
        
        if passedGoal.isCpTwoComplete == true {
            cpTwoSwitch.isOn = true
        } else {
            cpTwoSwitch.isOn = false
        }
        
        checkButton()
        
        let dismissKB = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        dismissKB.cancelsTouchesInView = false
        tableView.addGestureRecognizer(dismissKB)
        
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 4
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if editMode == false {
            if section == 2 {
                return 0
            } else {
                return 1
            }
        } else {
            return 1
        }
    }
    //    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        let nameArray = ["Test", "Test2", passedGoal.name, "Test"]
    //        return nameArray[section]
    //    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.textAlignment = .right
        headerText.textColor = .lightGray
        switch section {
        case 0:
            headerText.text = "Completed?"
        default:
            break
        }
        return headerText
    }
    
    
    
    
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    //MARK: - Custom Functions
    
    fileprivate func configureTextFields() {
        completeButton.setTitle("Complete \(passedGoal.name!)!", for: .normal)
        
        
        firstCPTextField.text = passedGoal.cpOne
        firstCPTextField.isEnabled = false
        secondCPTextField.text = passedGoal.cpTwo
        secondCPTextField.isEnabled = false
        goalNameTextField.text = passedGoal.name
        goalNameTextField.isEnabled = false
        goalNameTextField.isHidden = true
    }
    
    func updatingIsCPComplete(for checkpoint: String, complete: Bool) {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", passedGoal.uuid! as CVarArg)
        
//                let newDate = Date().addingTimeInterval(3.0)
        do {
            let goal = try managedContext.fetch(fetchRequest)
            
            if checkpoint == cpOneCriteria {
                goal.first?.setValue(complete, forKey: checkpoint)
//                goal.first?.setValue(newDate, forKey: "endDate")
                
            } else if checkpoint == cpTwoCriteria {
                
                goal.first?.setValue(complete, forKey: checkpoint)
            }
            //                goal.first?.setValue(newDate, forKey: "endDate")
            try! managedContext.save()
            
        } catch let error as NSError {
            print("Error fetching \(error), \(error.userInfo)")
        }
        
    }
    
    func editGoal() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", passedGoal.uuid! as CVarArg)
        do {
            let goal = try managedContext.fetch(fetchRequest)
            
            
            goal.first?.setValue(firstCPTextField.text, forKey: "cpOne")
            goal.first?.setValue(secondCPTextField.text, forKey: "cpTwo")
            goal.first?.setValue(goalNameTextField.text, forKey: "name")
            
            
            try! managedContext.save()
            
        } catch let error as NSError {
            print("Error updating \(error), \(error.userInfo)")
        }
        
    }
    
  
    
    fileprivate func completeGoal() {
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        fetchRequest.predicate = NSPredicate(format: "uuid == %@", passedGoal.uuid! as CVarArg)
        
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            if results.count > 0 {
                results.first!.isCompleted = true
                
                adjustPoints(Int(results.first!.points / 3))
                
                var goalCount = UserDefaults.standard.integer(forKey: "TotalGoals")
                goalCount += 1
                UserDefaults.standard.set(goalCount, forKey: "TotalGoals")
                
                
                if UserDefaults.standard.string(forKey: "StartDate") == "" {
                    UserDefaults.standard.set(dateFormatter.string(from: Date()), forKey: "StartDate")
                }
                
                UserDefaults.standard.set(dateFormatter.string(from: Date()), forKey: "LastGoal")
                
                
                try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Error completing task: \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if sender.title == "Edit" {
            sender.title = "Save"
            editMode = true
            firstCPTextField.isEnabled = true
            secondCPTextField.isEnabled = true
            goalNameTextField.isEnabled = true
            goalNameTextField.isHidden = false
            tableView.allowsSelection = false
            tableView.reloadData()
        } else {
            sender.title = "Edit"
            editMode = false
            firstCPTextField.isEnabled = false
            secondCPTextField.isEnabled = false
            goalNameTextField.isEnabled = false
            tableView.allowsSelection = true
            goalNameTextField.isHidden = true
            editGoal()
            completeButton.setTitle("Complete \(passedGoal.name!)!", for: .normal)
            tableView.reloadData()
        }
    }
    
    func adjustPoints(_ pointsChanged: Int) {
        
        let userDefaults = UserDefaults.standard
        var points = userDefaults.integer(forKey: "Points")
        points += pointsChanged
        userDefaults.set(points, forKey: "Points")
        
        var totalPoints = userDefaults.integer(forKey: "TotalPoints")
        totalPoints += pointsChanged
        userDefaults.set(points, forKey: "TotalPoints")
        
    }
    
    func checkButton() {
        if cpTwoSwitch.isOn && cpOneSwitch.isOn {
            completeButton.isEnabled = true
        } else {
            completeButton.isEnabled = false
        }
        tableView.reloadData()
    }
    
    @IBAction func cpOneSwitchChanged(_ sender: UISwitch) {
        
        
        if sender.isOn == true {
            updatingIsCPComplete(for: cpOneCriteria, complete: true)
            adjustPoints(Int(passedGoal!.points / 3))
        } else {
            updatingIsCPComplete(for: cpOneCriteria, complete: false)
            adjustPoints(Int(-passedGoal.points / 3))
        }
        checkButton()
        
        
    }
    
    @IBAction func cpTwoSwitchChanged(_ sender: UISwitch) {
        
        if sender.isOn == true {
            updatingIsCPComplete(for: cpTwoCriteria, complete: true)
            adjustPoints(Int(passedGoal!.points / 3))
        } else {
            updatingIsCPComplete(for: cpTwoCriteria, complete: false)
            adjustPoints(Int(-passedGoal.points / 3))
        }
        checkButton()
    }
    
    
    
    
    
    
    @IBAction func completeButtonPressed(_ sender: UIButton) {
        completeGoal()
        
        let alert = UIAlertController(title: "Task Complete", message: "\(passedGoal.points) points rewarded!", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        
        let timer = DispatchTime.now() + 0.75
        DispatchQueue.main.asyncAfter(deadline: timer) {
            alert.dismiss(animated: true, completion: nil)
            self.performSegue(withIdentifier: "SaveGoalSegue", sender: self)
        }
        
    }
}

extension DetailTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.delegate = self
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        if textField == firstCPTextField {
            if textField.text == "" {
                textField.text = "First Checkpoint"
            }
        }
        if textField == secondCPTextField {
            if textField.text == "" {
                textField.text = "First Checkpoint"
            }
        }
        
        if textField == goalNameTextField {
            if textField.text == "" {
                textField.text = "Unnamed Goal"
            }
        }
    }
}
