//
//  MainScreenTableViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-08.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class MainScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var currentDuration: Duration?
    var selectedGoal: Goal?
    let format = DateFormatter()
    var refreshControl: UIRefreshControl!
    
    //    lazy var coreDataStack = CoreDataStack(modelName: "GoalLogger")
    var managedContext: NSManagedObjectContext!
    
    
    @IBOutlet weak var segValue: UISegmentedControl!
    @IBOutlet weak var goalTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        format.timeZone = .current
        format.dateFormat = "MMM d, h:mm a"
        
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        goalTableView.addSubview(refreshControl)
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        fetchDurationName("Daily")
        goalTableView.reloadData()
        print("HI")
        print(segValue.selectedSegmentIndex)
        
    }
    
    @objc func refresh(_ sender: Any) {
        
        removeGoal()
        goalTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let segTitle = segValue.titleForSegment(at: segValue.selectedSegmentIndex)!
        
        
        if segValue.selectedSegmentIndex == 0 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 1 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 2 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 3 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else {
            return 0
        }
        
        
        
        
        
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        
        tableView.rowHeight = tableView.frame.size.height / 6
        
//        removeGoal()

        if (currentDuration?.goals?.array.count) != 0 {
            let goalAtIP = (currentDuration?.goals?[indexPath.row] as! Goal)
            cell.firstCpLabel.isHidden = false
            cell.secondCpLabel.isHidden = false
            cell.endedLabel.isHidden = false
            cell.nameLabel.text = goalAtIP.name as String?
            cell.startedLabel.text = "Started: " + format.string(from: goalAtIP.startDate!)
            cell.endedLabel.text = calculateTimeRemaining(deadline: goalAtIP.endDate!)
            cell.firstCpLabel.text = goalAtIP.cpOne
            cell.secondCpLabel.text = goalAtIP.cpTwo

            
//        } else {
            
//            cell.nameLabel.text = "No Current Goals"
//            cell.startedLabel.text = "Start One Now!"
//            cell.firstCpLabel.isHidden = true
//            cell.secondCpLabel.isHidden = true
//            cell.endedLabel.isHidden = true
//            return cell
//
        }
        
  
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        
        let goal = currentDuration?.goals?[indexPath.row] as! Goal
        
        if goal.endDate! < Date() {
            return false
        }
        
        for g in currentDuration!.goals! {
            let g2 = g as! Goal
            if g2.endDate! < Date() {
                return false
            }
        }
        
        return true
    }
    
    
    
    // Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        
        
        guard let currentDuration = currentDuration else { return }
        let goalToRemove: NSManagedObject = currentDuration.goals?[indexPath.row] as! NSManagedObject
        
        
        if editingStyle == .delete {
            
            
            
            
            
            managedContext.delete(goalToRemove)
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error deleting row: \(error), \(error.userInfo)")
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        }
        
        
        
    }
    
    
    
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
        
        if (currentDuration?.goals?.array.first) != nil {
            selectedGoal = currentDuration?.goals?[indexPath.row] as? Goal
            performSegue(withIdentifier: "DetailSegue", sender: nil)
        }
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailTableViewController
            vc.passedGoalName = selectedGoal?.name
            //            vc.passedGoalPoints = selectedGoal?.points as? Int32
            vc.passedDuration = selectedGoal?.duration
            vc.passedGoal = selectedGoal
            
        }
    }
    
    @IBAction func saveButtonPressed(_ segue: UIStoryboardSegue) {
        //        guard let addGoalVC = segue.source as? AddGoalTableViewController else { return }
        
        goalTableView.reloadData()
        
        
        
    }
    
    func calculateTimeRemaining(deadline endDate: Date) -> String {
        //time remaining in seconds
        let timeRemainingInhours = endDate.distance(to: Date()) / 3600
        var measureOfTime = 0
        
        if -timeRemainingInhours / 730.0 > 1 {
            measureOfTime = abs(Int((timeRemainingInhours / 730.0).rounded()))
            return "\(measureOfTime) months remaining"
        } else if -timeRemainingInhours / 168.0 > 1 {
            measureOfTime = abs(Int((timeRemainingInhours / 168.0).rounded()))
            return "\(measureOfTime) weeks remaining"
        } else if -timeRemainingInhours / 24.0 > 1 {
            measureOfTime = abs(Int((timeRemainingInhours / 24.0).rounded()))
            return "\(measureOfTime) days remaining"
        } else if -timeRemainingInhours > 1 {
            measureOfTime = abs(Int(timeRemainingInhours.rounded()))
            return "\(measureOfTime) hours remaining"
        } else if -timeRemainingInhours > 0 {
            measureOfTime = abs(Int((timeRemainingInhours * 60.0).rounded()))
            return "\(measureOfTime) minutes remaining"
        } else {
            return "Expired"
        }
    }
    
    func fetchAll(){
        let fetchRequest = NSFetchRequest<Duration>(entityName: "Goal")
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    func fetchDurationName(_ duration: String) {
        removeGoal()
        
        let goalFetch: NSFetchRequest<Duration> = Duration.fetchRequest()
        goalFetch.predicate = NSPredicate(format: "%K == %@", #keyPath(Duration.name), duration)
        
        do {
            let results = try managedContext.fetch(goalFetch)
            if results.count > 0 {
                currentDuration = results.first
            } else {
                currentDuration = Duration(context: managedContext)
                currentDuration?.name = duration
                
                do {
                    try managedContext.save()
                }
            }
            
        } catch let error as NSError {
            print("Fetch error: \(error) description: \(error.userInfo)")
        }
        title = "Your " + (currentDuration?.name)! + " Goals"
        
    }
    
    func removeGoal() {
        
        let now = Date()
        let request : NSFetchRequest<Goal> = Goal.fetchRequest()
        request.predicate = NSPredicate(format: "%K < %@", #keyPath(Goal.endDate), now as CVarArg)
        
        let expired = try! managedContext.fetch(request)
        
        for exp in expired {
            managedContext.delete(exp)
            
        }
        
        do {
            try managedContext.save()
            
        } catch let error as NSError {
            print("Error deleting: \(error), \(error.userInfo)")
        }
        
        
        
    }
    
    
    @IBAction func segChanged(_ sender: UISegmentedControl) {
        
        let segTitle = segValue.titleForSegment(at: segValue.selectedSegmentIndex)!
        fetchDurationName(segTitle)
        
        goalTableView.reloadData()
        
    }
}


