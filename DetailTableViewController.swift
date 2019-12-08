//
//  DetailTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-22.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var passedGoalName: String?
    var passedGoalPoints: Int?
    var passedDuration: String?
    var passedGoal: Goal?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(passedDuration!)
        print(passedGoalPoints!)
        
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd HH:mm"
        guard let endDate = passedGoal?.endDate else { return }
        print(format.string(from: endDate))
        
        
        
        let remaining = calculateTimeRemaining(deadline: endDate)
        print(remaining)
        
        //        print(passedGoal?.startDate)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    
    func calculateTimeRemaining(deadline endDate: Date) -> String {
        //time remaining in seconds
        let timeRemainingInhours = abs(endDate.distance(to: Date())) / 3600
        var measureOfTime = 0
        
        if timeRemainingInhours / 730.0 > 1 {
            measureOfTime = Int((timeRemainingInhours / 730.0).rounded())
            return "\(measureOfTime) months remaining"
        } else if timeRemainingInhours / 168.0 > 1 {
            measureOfTime = Int((timeRemainingInhours / 168.0).rounded())
            return "\(measureOfTime) weeks remaining"
        } else if timeRemainingInhours / 24.0 > 1 {
            measureOfTime = Int((timeRemainingInhours / 24.0).rounded())
            return "\(measureOfTime) days remaining"
        } else if timeRemainingInhours > 1 {
            measureOfTime = Int(timeRemainingInhours.rounded())
            return "\(measureOfTime) hours remaining"
        } else {
            measureOfTime = Int((timeRemainingInhours * 60.0).rounded())
            return "\(measureOfTime) minutes remaining"
            
        }
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
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
    
}
