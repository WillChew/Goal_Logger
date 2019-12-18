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
    
    var passedGoalName: String?
    var passedGoalPoints: Int?
    var passedDuration: String?
    var passedGoal: Goal!
    var managedContext: NSManagedObjectContext!
    

    @IBOutlet weak var firstCPSwitch: UISwitch!
    
    @IBOutlet weak var secondCPSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd HH:mm"
        
        
        if passedGoal.isCpOneComplete == true {
            firstCPSwitch.isOn = true
        }
    if passedGoal.isCpTwoComplete == true {
        secondCPSwitch.isOn = true
    }

        
        
        tableView.tableFooterView?.backgroundColor = .clear

    }
    
    func updatingIsCPComplete(for checkpoint: String) {
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", passedGoal.uuid! as CVarArg)
        
        do {
            let goal = try managedContext.fetch(fetchRequest)
            if goal.isEmpty == false {
                if checkpoint == "isCpOneComplete" {
        goal.first?.setValue(firstCPSwitch.isOn, forKey: checkpoint)
                } else if checkpoint == "isCpTwoComplete" {
                    goal.first?.setValue(secondCPSwitch.isOn, forKey: checkpoint)
                }
                
                try! managedContext.save()
            }
        } catch let error as NSError {
            print("Error fetching \(error), \(error.userInfo)")
        }
        
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 3
    }

//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return
//    }
//
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let nameArray = [passedGoal?.cpOne, passedGoal?.cpTwo, passedGoalName]
        
        return nameArray[section]
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
    @IBAction func firstCPChanged(_ sender: UISwitch) {
        
       
        updatingIsCPComplete(for: "isCpOneComplete")
    }
    @IBAction func secondCPChanged(_ sender: UISwitch) {
        updatingIsCPComplete(for: "isCpTwoComplete")
    }
}
