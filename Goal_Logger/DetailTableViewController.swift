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
    
    
    var passedGoal: Goal!
    var managedContext: NSManagedObjectContext!
    
    let cpOneCriteria = "isCpOneComplete"
    let cpTwoCriteria = "isCpTwoComplete"
    @IBOutlet weak var firstCPSwitch: UISwitch!
    @IBOutlet weak var secondCPSwitch: UISwitch!
    @IBOutlet weak var firstCPTextField: UITextField!
    @IBOutlet weak var secondCPTextField: UITextField!
    @IBOutlet weak var goalNameTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd HH:mm"
        
        
        
        
        //        firstCPTextField.delegate = self
        //        secondCPTextField.delegate = self
        firstCPTextField.text = passedGoal.cpOne
        firstCPTextField.isEnabled = false
        secondCPTextField.text = passedGoal.cpTwo
        secondCPTextField.isEnabled = false
        goalNameTextField.text = passedGoal.name
        goalNameTextField.isEnabled = false
        
    }
    
    func updatingIsCPComplete(for checkpoint: String, complete: Bool) {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", passedGoal.uuid! as CVarArg)
        
        //        let newDate = Date().addingTimeInterval(1.0)
        do {
            let goal = try managedContext.fetch(fetchRequest)
            if goal.isEmpty == false {
                if checkpoint == cpOneCriteria {
                    print("First")
                    goal.first?.setValue(complete, forKey: checkpoint)
                } else if checkpoint == cpTwoCriteria {
                    print("Second")
                    goal.first?.setValue(complete, forKey: checkpoint)
                }
                //                goal.first?.setValue(newDate, forKey: "endDate")
                try! managedContext.save()
            }
        } catch let error as NSError {
            print("Error fetching \(error), \(error.userInfo)")
        }
        
    }
    
    func changeCP() {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", passedGoal.uuid! as CVarArg)
        do {
            let goal = try managedContext.fetch(fetchRequest)
            if goal.isEmpty == false {
                
                goal.first?.setValue(firstCPTextField.text, forKey: "cpOne")
                goal.first?.setValue(secondCPTextField.text, forKey: "cpTwo")
                goal.first?.setValue(goalNameTextField.text, forKey: "name")
                
                
                try! managedContext.save()
            }
        } catch let error as NSError {
            print("Error updating \(error), \(error.userInfo)")
        }
        
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let nameArray = ["Test", "Test2", passedGoal.name]
        return nameArray[section]
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerText = UILabel()
        headerText.textAlignment = .right
        headerText.textColor = .lightGray
        switch section {
        case 0:
            headerText.text = "Completed?"
        case 1:
            headerText.text = ""
        case 2:
            headerText.text = ""
        default:
            headerText.text = ""
        }
        return headerText
    }
    
    //    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    //        // #warning Incomplete implementation, return the number of rows
    //        return
    //    }
    //
    
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let identifier = cell.reuseIdentifier {
            switch identifier {
            case cpOneCriteria:
                
                if passedGoal.isCpOneComplete == false {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            case cpTwoCriteria:
                
                if passedGoal.isCpTwoComplete == false {
                    cell.accessoryType = .none
                } else {
                    cell.accessoryType = .checkmark
                }
            default:
                break
            }
        }
    }
        
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = indexPath.section
        let numberOfRows = tableView.numberOfRows(inSection: section)

        for row in 0..<numberOfRows {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: section)) {

                if cell.reuseIdentifier == cpOneCriteria {
                    if cell.accessoryType == .none {
                        updatingIsCPComplete(for: cpOneCriteria, complete: true)
                        cell.accessoryType = .checkmark
                    } else if cell.accessoryType == .checkmark{
                        updatingIsCPComplete(for: cpOneCriteria, complete: false)
                        cell.accessoryType = .none
                    }
                }
                
                if cell.reuseIdentifier == cpTwoCriteria {
                    if cell.accessoryType == .none {
                        updatingIsCPComplete(for: cpTwoCriteria, complete: true)
                        cell.accessoryType = .checkmark
                    } else if cell.accessoryType == .checkmark{
                        updatingIsCPComplete(for: cpTwoCriteria, complete: false)
                        cell.accessoryType = .none
                    }
                    
                }
            }
        }
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
    
 

    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if sender.title == "Edit" {
            sender.title = "Save"
            firstCPTextField.isEnabled = true
            secondCPTextField.isEnabled = true
            goalNameTextField.isEnabled = true
            
        } else {
            sender.title = "Edit"
            firstCPTextField.isEnabled = false
            secondCPTextField.isEnabled = false
            goalNameTextField.isEnabled = false
            changeCP()
        }
    }
}

extension DetailTableViewController: UITextFieldDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.delegate = self
        textField.resignFirstResponder()
        print("HI 2")
        return true
    }
}
