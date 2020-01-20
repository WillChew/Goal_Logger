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
    var blurEffectView: UIVisualEffectView!
    var dismissInfoViewTapGesture: UITapGestureRecognizer!
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    @IBOutlet var infoView: UIView!
    @IBOutlet weak var segValue: UISegmentedControl!
    @IBOutlet weak var goalTableView: UITableView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    //InfoViewVC outlets
    @IBOutlet weak var currentPointsLabel: UILabel!
    
    @IBOutlet weak var totalPointsLabel: UILabel!
    @IBOutlet weak var redeemedRewardsLabel: UILabel!
    @IBOutlet weak var completedGoalsLabel: UILabel!
    @IBOutlet weak var lastCompletedGoalLabel: UILabel!
    @IBOutlet weak var firstGoalCompletedLabel: UILabel!
    
    @IBOutlet weak var dismissButton: UIButton!
    
    @IBOutlet weak var resetButton: UIButton!
    
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
        goalTableView.reloadData()
        
        
        
        
    }
    
    @objc func refresh(_ sender: Any) {
        
        removeExpiredGoals()
        goalTableView.reloadData()
        refreshControl.endRefreshing()
    }
    
    @objc func dismissInfo(_ sender: UITapGestureRecognizer) {
        animateOut()
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
            cell.progressLabel.text = "Progress to \(goalAtIP.points) points"
            
            if (goalAtIP.isCpOneComplete && !goalAtIP.isCpTwoComplete) || (goalAtIP.isCpTwoComplete && !goalAtIP.isCpOneComplete) {
                cell.progressBar.progress = 0.5
            } else if goalAtIP.isCpOneComplete && goalAtIP.isCpTwoComplete {
                cell.progressBar.progress = 1.0
            } else {
                cell.progressBar.progress = 0.0
            }
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
            cell.progressLabel.text = "Progress to \(goalAtIP.points) points"
            
            
            if (goalAtIP.isCpOneComplete && !goalAtIP.isCpTwoComplete) || (goalAtIP.isCpTwoComplete && !goalAtIP.isCpOneComplete) {
                cell.progressBar.progress = 0.5
            } else if goalAtIP.isCpOneComplete && goalAtIP.isCpTwoComplete {
                cell.progressBar.progress = 1.0
            } else {
                cell.progressBar.progress = 0.0
            }
            
            
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        //        guard let addGoalVC = segue.source as? AddGoalTableViewController else { return }
        
        goalTableView.reloadData()
        
        
        
    }
    
    func calculateTimeRemaining(deadline endDate: Date) -> String {
        //time remaining in seconds
        let timeRemainingInhours = -(endDate.distance(to: Date()) / 3600)
        var measureOfTime = 0
        
        if timeRemainingInhours / 730.0 > 1 {
            measureOfTime = abs(Int((timeRemainingInhours / 730.0).rounded()))
            if measureOfTime == 1 {
                return "1 month remaining"
            } else {
                return "\(measureOfTime) months remaining"
            }
        } else if timeRemainingInhours / 168.0 > 1 {
            
            measureOfTime = abs(Int((timeRemainingInhours / 168.0).rounded()))
            if measureOfTime == 1 {
                return "1 week remaining"
            } else {
                return "\(measureOfTime) weeks remaining"
            }
        } else if timeRemainingInhours / 24.0 > 1 {
            
            measureOfTime = abs(Int((timeRemainingInhours / 24.0).rounded()))
            if measureOfTime == 1 {
                return "1 day remaining"
            } else {
                return "\(measureOfTime) days remaining"
            }
        } else if timeRemainingInhours > 1 {
            measureOfTime = abs(Int(timeRemainingInhours.rounded()))
            if measureOfTime == 1 {
                return "1 hour remaining"
            }
            return "\(measureOfTime) hours remaining"
        } else if timeRemainingInhours > 0 {
            measureOfTime = abs(Int((timeRemainingInhours * 60.0).rounded()))
            if measureOfTime == 1 {
                return "1 minute remaining"
            } else {
                return "\(measureOfTime) minutes remaining"
            }
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
        title = "Your Goals"
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
        
        let expiredPredicate = NSPredicate(format: "%K < %@", #keyPath(Goal.endDate), now as CVarArg)
        let completePredicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        let orPredicate = NSCompoundPredicate(type: .or, subpredicates: [expiredPredicate, completePredicate])
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Goal")
        fetchRequest.predicate = orPredicate
        
        
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results.count > 0 {
                for result in results {
                    managedContext.delete(result as! NSManagedObject)
                }
            }
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
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Reset Everything", message: "This clears everything including goals and rewards as well. \n Are you sure?", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            
            self.deleteGoals()
            self.deleteRewards()
            UserDefaults.standard.set(0, forKey: "Points")
            UserDefaults.standard.set(0, forKey: "TotalPoints")
            UserDefaults.standard.set(0, forKey: "TotalRewards")
            UserDefaults.standard.set(0, forKey: "TotalGoals")
            UserDefaults.standard.set("", forKey: "StartDate")
            UserDefaults.standard.set("", forKey: "LastGoal")
            self.animateOut()
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(confirmAction)
        
        present(alert, animated: true, completion: nil)
        
        
        
        
        
    }
    
    
    
}
extension MainScreenViewController: UIGestureRecognizerDelegate {
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == infoView {
            return false
        }
        return true
    }
    
    
    func deleteGoals() {
        
        let fetchRequest: NSFetchRequest<Goal> = Goal.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for result in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting goals: \(error), \(error.userInfo)")
        }
        
    }
    
    func deleteRewards() {
        
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            for result in results {
                managedContext.delete(result)
            }
            
            try managedContext.save()
        } catch let error as NSError {
            print("Error deleting rewards: \(error), \(error.userInfo)")
        }
        
    }
    
    
    @IBAction func infoButtonPressed(_ sender: Any) {
        
        animateViewIn()
        
    }
    @IBAction func dismissInfoViewButtonPressed(_ sender: UIButton) {
        
        animateOut()
    }
    
    func animateViewIn() {
        
        dismissButton.layer.cornerRadius = 10
        dismissButton.layer.borderWidth = 1
        dismissButton.layer.borderColor = UIColor.black.cgColor
        
        
        
        //        resetButton.layer.cornerRadius = 10
        //        resetButton.layer.borderWidth = 1
        //        resetButton.layer.borderColor = UIColor.black.cgColor
        
        
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            infoView.layer.cornerRadius = 10
            blurEffectView = UIVisualEffectView(effect: nil)
            blurEffectView.frame = self.view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
        } else {
            view.backgroundColor = .black
        }
        
        self.view.addSubview(infoView)
        infoView.center = self.view.center
        infoView.alpha = 0
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
        dismissInfoViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissInfo(_:)))
        self.view.addGestureRecognizer(dismissInfoViewTapGesture)
        dismissInfoViewTapGesture.delegate = self
        UIView.animate(withDuration: 0.3, animations:  {
            self.blurEffectView.effect = UIBlurEffect(style: .dark)
            self.infoView.alpha = 1
            self.infoButton.isEnabled = false
            self.addButton.isEnabled = false
            
            
        }) { (_) in
            self.currentPointsLabel.text = "Current Points: \(UserDefaults.standard.integer(forKey: "Points"))"
            self.totalPointsLabel.text = "Total Points Earned: \(UserDefaults.standard.integer(forKey: "TotalPoints"))"
            self.redeemedRewardsLabel.text = "Number of Redeemed Rewards: \(UserDefaults.standard.integer(forKey: "TotalRewards"))"
            self.completedGoalsLabel.text = "Number of Goals Completed: \(UserDefaults.standard.integer(forKey: "TotalGoals")) "
            
            if let start = UserDefaults.standard.string(forKey: "StartDate") {
                self.firstGoalCompletedLabel.text = "First Goal Completed On: " + start
            }
            if let end = UserDefaults.standard.string(forKey: "LastGoal") {
                self.lastCompletedGoalLabel.text = "Last Goal Completed On: " + end
                
            }
        }
    }
    
    func animateOut() {
        
        UIView.animate(withDuration: 0.3, animations: {
            
            self.infoView.alpha = 0
            self.infoButton.isEnabled = true
            self.addButton.isEnabled = true
            self.blurEffectView.effect = nil
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }) { (_) in
            
            self.infoView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            self.view.removeGestureRecognizer(self.dismissInfoViewTapGesture)
            self.goalTableView.reloadData()
        }
    }
    
    
    
}
