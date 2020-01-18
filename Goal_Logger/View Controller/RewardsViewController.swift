//
//  RewardsViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-27.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class RewardsViewController: UIViewController {
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext!
    var rewards: [Reward] = []
    var selectedReward: Reward!
    var refreshControl: UIRefreshControl!
    var editModeOn = false
    var rewardToPass: Reward!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        tableView.rowHeight = tableView.frame.size.height / 7
        refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(refreshControl)
        
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editButton.title = "Edit"
        fetchRewards()
        tableView.reloadData()
    }
    
    @objc func refresh() {
        fetchRewards()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    //#PRAGMA MARK: CORE DATA FUNCTIONS
    func fetchRewards() {
        
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stock > 0")
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            rewards = results
            
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Error fetching rewards: \(error), \(error.userInfo)")
        }
    }
    
    func updateStockLevels(_ reward: Reward) {
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", reward.uuid! as CVarArg)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var newStock = 0
            var rewardCount = UserDefaults.standard.integer(forKey: "TotalRewards")
            
            if let stockAmt = result.first?.stock, let cost = result.first?.cost {
                newStock = Int(stockAmt) - 1
                var points = UserDefaults.standard.integer(forKey: "Points")
                
                points -= Int(cost)
                UserDefaults.standard.setValue(points, forKey: "Points")
                
                
                rewardCount += 1
                
                UserDefaults.standard.set(rewardCount, forKey: "TotalRewards")
                
                
                if newStock > 0 {
                    result.first?.setValue(newStock, forKey: "stock")
                }
                    
                else if newStock <= 0 {
                    result.first?.isRedeemed = true
                    result.first?.setValue(0, forKey: "stock")
                    fetchRewards()
                }
                
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Error redeeming reward: \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        
        if editButton.title == "Edit" {
            editButton.title = "Done"
            editModeOn = true
        } else {
            editButton.title = "Edit"
            editModeOn = false
        }
        tableView.reloadData()
    }
    
    // #PRAGMA MARK: SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editSegue" {
            let vc = segue.destination as! AddRewardViewController
            vc.passedReward = selectedReward
        }
    }
    
    
    @IBAction func unwindAfterAddingReward(_ segue: UIStoryboardSegue) {
        fetchRewards()
        editButton.title = "Edit"
        tableView.reloadData()
    }
    
    
    
}


extension RewardsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count
    }
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell", for: indexPath) as! RewardTableViewCell
        
        let reward = rewards[indexPath.row]
        
        cell.nameLabel.text = reward.name
        cell.costLabel.text = "\(reward.cost) Points"
        cell.stockLevel.text = "\(reward.stock) in stock"
        
        if reward.stock == 0 {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }
        if let data = reward.image {
            cell.rewardImage.image = UIImage(data: data)
            cell.rewardImage.layer.borderWidth = 1
            cell.rewardImage.layer.borderColor = UIColor.lightGray.cgColor
            
        }
        
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedReward = rewards[indexPath.row]
        
        
        if editModeOn == false {
            if UserDefaults.standard.integer(forKey: "Points") >= selectedReward.cost {
                let alert = UIAlertController(title: "Redeem \(selectedReward.name ?? "Reward")?", message: "", preferredStyle: .alert)
                
                let confirmAction = UIAlertAction(title: "Redeem!", style: .default) {  _ in
                    
                    self.updateStockLevels(self.selectedReward)
                    
                    let alert = UIAlertController(title: "\(self.selectedReward.name!) Redeemed!", message: "\(self.selectedReward.cost) points redeemed!", preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                    
                    let timer = DispatchTime.now() + 1.5
                    DispatchQueue.main.asyncAfter(deadline: timer) {
                        alert.dismiss(animated: true, completion: nil)
                        
                    }
                }
                
                let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
                
                alert.addAction(confirmAction)
                alert.addAction(cancelAction)
                present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Not enough points", message: "Complete more goals first!", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "OK!", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
        if editModeOn == true {
            performSegue(withIdentifier: "editSegue", sender: self)
            editButton.title = "Edit"
            editModeOn = false
        }
    }
    
    
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let reward = rewards[indexPath.row]
        
        if reward.stock == 0 || editModeOn == true {
            return false
        }
        
        
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            managedContext.delete(rewards[indexPath.row])
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Error deleting reward: \(error), \(error.userInfo)")
            }
            fetchRewards()
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
        
        
    }
    
    
}




