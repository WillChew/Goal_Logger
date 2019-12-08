//
//  MainScreenTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-08.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectedGoal: Goal?
    var goalArray = [Goal]()
    var dailyArray = [Goal]()
    var weeklyArray = [Goal]()
    var monthlyArray = [Goal]()
    var annualArray = [Goal]()
    
    @IBOutlet weak var segValue: UISegmentedControl!
    @IBOutlet weak var goalTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        
        if segValue.selectedSegmentIndex == 1 {
            return dailyArray.count
        } else if segValue.selectedSegmentIndex == 2 {
            return weeklyArray.count
        } else if segValue.selectedSegmentIndex == 3 {
            return monthlyArray.count
        } else if segValue.selectedSegmentIndex == 4 {
            return annualArray.count
        } else if segValue.selectedSegmentIndex == 0 && goalArray.count > 0 {
            return goalArray.count
        } else {
            return 1
        }

        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        
        if goalArray.isEmpty {
            cell.nameLabel.text = "No Current Goals"
        } else {
            cell.nameLabel.text = goalArray[indexPath.row].name
        }
        
        
        
        
        if segValue.selectedSegmentIndex == 1 && dailyArray.count > 0{
            cell.nameLabel.text = dailyArray[indexPath.row].name
        } else if segValue.selectedSegmentIndex == 2 && weeklyArray.count > 0 {
            cell.nameLabel.text = weeklyArray[indexPath.row].name
        } else if segValue.selectedSegmentIndex == 3 && monthlyArray.count > 0 {
            cell.nameLabel.text = monthlyArray[indexPath.row].name
        } else if segValue.selectedSegmentIndex == 4 && annualArray.count > 0 {
            cell.nameLabel.text = annualArray[indexPath.row].name
        }
        
        return cell
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

    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        goalTableView.deselectRow(at: indexPath, animated: true)
        if goalArray.count != 0 {
            selectedGoal = goalArray[indexPath.row]
            performSegue(withIdentifier: "DetailSegue", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailTableViewController
            vc.passedGoalName = selectedGoal?.name
            vc.passedGoalPoints = 100
            vc.passedDuration = selectedGoal?.duration
            vc.passedGoal = selectedGoal
            
        }
    }
    
    @IBAction func saveButtonPressed(_ segue: UIStoryboardSegue) {
        guard let addGoalVC = segue.source as? AddGoalTableViewController,
            let goal = addGoalVC.goal
            else {
                return
        }
        
        goalArray.append(goal)
        if goal.duration == "Daily Goal" {
            dailyArray.append(goal)
        } else if goal.duration == "Weekly Goal" {
            weeklyArray.append(goal)
        } else if goal.duration == "Monthly Goal" {
            monthlyArray.append(goal)
        } else if goal.duration == "Annual Goal" {
            annualArray.append(goal)
        }
        
        
        

        
        goalTableView.reloadData()
        
    }
    
    @IBAction func segChanged(_ sender: Any) {
        print(segValue.selectedSegmentIndex)
        goalTableView.reloadData()
        
    }
}


