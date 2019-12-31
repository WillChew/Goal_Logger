//
//  RewardsViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-27.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class RewardsViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    var width = CGFloat()
    var height = CGFloat()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
   
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    

}


extension RewardsViewController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RewardCell", for: indexPath)
        
        cell.textLabel?.text = "Hi"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
  
    
    
    
}
