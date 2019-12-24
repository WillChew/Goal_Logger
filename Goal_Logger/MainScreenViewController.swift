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
    var goals: [NSManagedObject] = []
    
    lazy var dateFormatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .current
        dateFormatter.dateFormat = "MMM d, h:mm a"
        return dateFormatter
    }()
    var refreshControl: UIRefreshControl!
    var managedContext: NSManagedObjectContext!
    
    
    @IBOutlet weak var segValue: UISegmentedControl!
    @IBOutlet weak var goalTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        goalTableView.addSubview(refreshControl)
        
        
        goalTableView.rowHeight = goalTableView.frame.size.height / 6
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        if currentDuration != nil {
            fetchDurationName((currentDuration?.name!)!)
        } else {
            segValue.selectedSegmentIndex = 0
        }
        goalTableView.reloadData()
        
    }
    
    @objc func refresh(_ sender: Any) {
        
        removeExpiredGoals()
        goalTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    // MARK: - Table view data source
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let segTitle = segValue.titleForSegment(at: segValue.selectedSegmentIndex)!
        
        
        if segValue.selectedSegmentIndex == 1 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 2 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 3 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 4 {
            fetchDurationName(segTitle)
            return currentDuration?.goals?.count ?? 1
        } else if segValue.selectedSegmentIndex == 0 {
            fetchAll()
            return goals.count
        } else {
            return 0
        }
    }
    
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath) as! GoalCell
        
        if segValue.selectedSegmentIndex == 0 {
                 let goalAtIP = goals[indexPath.row] as! Goal
                 cell.nameLabel.text = goalAtIP.name as String?
                 cell.startedLabel.text = "Started: " + dateFormatter.string(from: goalAtIP.startDate!)
                 cell.endedLabel.text = calculateTimeRemaining(deadline: goalAtIP.endDate!)
                 cell.firstCpLabel.text = goalAtIP.cpOne
                 cell.secondCpLabel.text = goalAtIP.cpTwo
             }
        
        if (currentDuration?.goals?.array.count) != 0 && segValue.selectedSegmentIndex != 0 {
            let goalAtIP = (currentDuration?.goals?[indexPath.row] as! Goal)
            cell.firstCpLabel.isHidden = false
            cell.secondCpLabel.isHidden = false
            cell.endedLabel.isHidden = false
            cell.nameLabel.text = goalAtIP.name as String?
            cell.startedLabel.text = "Started: " + dateFormatter.string(from: goalAtIP.startDate!)
            cell.endedLabel.text = calculateTimeRemaining(deadline: goalAtIP.endDate!)
            cell.firstCpLabel.text = goalAtIP.cpOne
            cell.secondCpLabel.text = goalAtIP.cpTwo
            
        }
        
     
        
        return cell
    }
    
    
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        
        if segValue.selectedSegmentIndex != 0 {
            guard let goal = currentDuration?.goals?[indexPath.row] as? Goal else { return false }
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
        } else {
            return false
        }
       
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
            
        } else if !goals.isEmpty {
            selectedGoal = goals[indexPath.row] as? Goal
            
        }
        navigationController?.navigationBar.prefersLargeTitles.toggle()
        performSegue(withIdentifier: "DetailSegue", sender: nil)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailSegue" {
            let vc = segue.destination as! DetailTableViewController
            
            //            vc.passedGoalPoints = selectedGoal?.points as? Int32
            
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
        removeExpiredGoals()
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        let sort = NSSortDescriptor(key: #keyPath(Goal.endDate), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        title = "All Goals"
    }
    
    func fetchDurationName(_ duration: String) {
        removeExpiredGoals()
        
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
    
    func removeExpiredGoals() {
        
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
