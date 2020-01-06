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
    
    
    @IBOutlet weak var tableView: UITableView!
    var managedContext: NSManagedObjectContext!
    var rewards: [Reward] = []
    var selectedReward: Reward!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        
        
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchRewards()
        tableView.reloadData()
    }
    
    
    
    @IBAction func unwindAfterAddingReward(_ segue: UIStoryboardSegue) {
        fetchRewards()
        print(rewards.count)
        tableView.reloadData()
    }
    
    func fetchRewards() {
        
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "stock > 0")
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            rewards = results
            print(results.count)
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Error fetching rewards: \(error), \(error.userInfo)")
        }
    }
    
    
}


extension RewardsViewController: UITableViewDelegate, UITableViewDataSource  {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        print(tableView.frame.size.height / 7)
        return tableView.frame.size.height / 7
    }
    
    
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
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedReward = rewards[indexPath.row]
        
        
      
        
        let alert = UIAlertController(title: "Redeem \(selectedReward.name ?? "Reward")", message: "", preferredStyle: .alert)
        
        let confirmAction = UIAlertAction(title: "Redeem!", style: .default) {  _ in
            
            self.updateStockLevels(self.selectedReward)
            self.tableView.reloadData()
            
        }
        
        let cancelAction = UIAlertAction(title: "Nevermind", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func updateStockLevels(_ reward: Reward) {
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", reward.uuid! as CVarArg)
        
        do {
            let result = try managedContext.fetch(fetchRequest)
            
            var newStock = 0
            
            if let stockAmt = result.first?.stock {
                newStock = Int(stockAmt) - 1
                
                if newStock > 0 {
                    result.first?.setValue(newStock, forKey: "stock")
                }
                    
                else if newStock <= 0 {
                    result.first?.isRedeemed = true
                    result.first?.setValue(0, forKey: "stock")
//                    managedContext.delete(reward)
                }
                
                try managedContext.save()
            }
        } catch let error as NSError {
            print("Error redeeming reward: \(error), \(error.userInfo)")
        }
        
        self.tableView.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        let reward = rewards[indexPath.row]
        
        if reward.stock == 0 {
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
        
        if editingStyle == .insert {
            print("HI")
        }
    }
}


