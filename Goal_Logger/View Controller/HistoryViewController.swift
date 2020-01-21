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
    @IBOutlet weak var goalsLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        managedContext = appDelegate.persistentContainer.viewContext
        
        goalsLabel.translatesAutoresizingMaskIntoConstraints = false
        goalsLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        goalsLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        goalsLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: goalsLabel.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: rewardsLabel.topAnchor).isActive = true
        
        
        tableView.heightAnchor.constraint(equalToConstant: (self.view.bounds.size.height - goalsLabel.frame.size.height*2) / 2.5).isActive = true
        
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
        
        rewardsLabel.text = "Redeemed Rewards"
        goalsLabel.text = "Completed Goals"
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
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
            cell.detailTextLabel?.text = "Get started now!"
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
            cell.nameLabel.textAlignment = .right
            
        }
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.size.height 
        
        return CGSize(width: height, height: height)
    }
    
}

extension HistoryViewController {
    
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
    
    
}
