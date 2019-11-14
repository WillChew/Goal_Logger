//
//  DetailViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-11-14.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var points: UILabel!
    @IBOutlet weak var isCompleted: UILabel!
    
    
    var passedGoalName: String?
    var passedGoalPoints: Int?
    var passedIsCompleted: Bool?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        name.text = passedGoalName
        points.text = String(100)
        

        // Do any additional setup after loading the view.
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
