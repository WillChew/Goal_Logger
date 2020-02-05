//
//  HistoryViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2020-01-21.
//  Copyright © 2020 Will Chew. All rights reserved.
//

import UIKit
import CoreData


class HistoryViewController: UIViewController {
    
    var managedContext: NSManagedObjectContext!
    var goalsArray = [Goal]()
    var rewardsArray = [Reward]()
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var rewardsLabel: UILabel!
    
    @IBOutlet var infoView: UIView!
    
    @IBOutlet weak var infoButton: UIBarButtonItem!
    var blurEffectView: UIVisualEffectView!
    var dismissInfoViewTapGesture: UITapGestureRecognizer!
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
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: rewardsLabel.topAnchor).isActive = true
        
        
        tableView.heightAnchor.constraint(equalToConstant: self.view.bounds.size.height/2).isActive = true
        
        tableView.tableFooterView = UIView()
        
        rewardsLabel.translatesAutoresizingMaskIntoConstraints = false
        rewardsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        rewardsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: rewardsLabel.bottomAnchor).isActive = true
        
        collectionView.automaticallyAdjustsScrollIndicatorInsets = false
        collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkCompleted()
        checkRewards()
        collectionView.reloadData()
        tableView.reloadData()
        
        if !rewardsArray.isEmpty {
        rewardsLabel.text = "Redeemed Rewards"
        } else {
            rewardsLabel.text = ""
        }
        
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    @IBAction func infoButtonPressed(_ sender: UIBarButtonItem) {
        animateViewIn()
    }
    
    @IBAction func dismissButtonPressed(_ sender: UIButton) {
        animateOut()
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

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if !goalsArray.isEmpty {
            return goalsArray.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoalCell", for: indexPath)
        
        
        if !goalsArray.isEmpty {
            cell.textLabel?.text = goalsArray[indexPath.row].name
            cell.detailTextLabel?.text = "Earned \(goalsArray[indexPath.row].points) points"
            
            
        } else {
            cell.textLabel?.text = "No completed goals yet..."
            cell.detailTextLabel?.text = ""
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

extension HistoryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if !rewardsArray.isEmpty {
            return rewardsArray.count
        } else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RewardCell", for: indexPath) as! HistoryCollectionViewCell
        
        if !rewardsArray.isEmpty {
            guard let data = rewardsArray[indexPath.row].image else { return cell }
            cell.imageView.image = UIImage(data: data)
            cell.nameLabel.text =  rewardsArray[indexPath.row].name! + " - \(rewardsArray[indexPath.row].cost) points"
        } else {
            cell.nameLabel.text = "Nothing has been claimed yet!"
            cell.nameLabel.textAlignment = .center
            cell.imageView.image = nil
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height 
        
        return CGSize(width: height, height: height)
    }
    
}

extension HistoryViewController : UIGestureRecognizerDelegate {
    
    func checkCompleted() {
        let fetch : NSFetchRequest<Goal> = Goal.fetchRequest()
        fetch.predicate = NSPredicate(format: "isCompleted == %@", NSNumber(value: true))
        
        do {
            goalsArray = try managedContext.fetch(fetch)
            
        } catch {
            print("Error fetching completed")
        }
    }
    
    func checkRewards() {
        let fetch : NSFetchRequest<Reward> = Reward.fetchRequest()
        fetch.predicate = NSPredicate(format: "isRedeemed == %@", NSNumber(value: true))
        
        do {
            rewardsArray = try managedContext.fetch(fetch)
            
        } catch {
            print("Error fetching rewards")
        }
        
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
        self.goalsArray.removeAll()
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
        self.rewardsArray.removeAll()
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        
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
            self.blurEffectView.effect = nil
            self.navigationController?.isNavigationBarHidden = false
            self.tabBarController?.tabBar.isHidden = false
        }) { (_) in
            
            self.infoView.removeFromSuperview()
            self.blurEffectView.removeFromSuperview()
            self.view.removeGestureRecognizer(self.dismissInfoViewTapGesture)
            self.checkRewards()
            self.checkCompleted()
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            
            
        }
    }
    
    @objc func dismissInfo(_ sender: UITapGestureRecognizer) {
        animateOut()
    }
  
    
    
    
    
}
