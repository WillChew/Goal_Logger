//
//  AddRewardViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-31.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit

class AddRewardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rewardNameTF: UITextField!
    @IBOutlet weak var costTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        let points = UserDefaults.standard.integer(forKey: "Points")
        
        pointsLabel.text = "Your Points: \(points)"
       

        // Do any additional setup after loading the view.
    }
    
   
    
    @objc func dismissView(_ sender: UITapGestureRecognizer) {

        
        let alert = UIAlertController(title: "Leave without Saving?", message: "", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { _ in
            self.dismiss(animated: true, completion: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(confirmAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
        
    }
   
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == addView {
            return false
        }
        return true
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {

    }
    
    

}
