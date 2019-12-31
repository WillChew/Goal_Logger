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
    
    func fetchRewards() {
        
        let fetchRequest: NSFetchRequest<Reward> = Reward.fetchRequest()
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            
            rewards = results
            print(results.count)
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Error fetching rewards: \(error), \(error.userInfo)")
        }
        
        
    }
    
    @IBAction func unwindAfterAddingReward(_ segue: UIStoryboardSegue) {
        fetchRewards()
        print(rewards.count)
        tableView.reloadData()
    }
    
    
}


extension RewardsViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rewards.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell", for: indexPath)
        
        cell.textLabel?.text = rewards[indexPath.row].name
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
