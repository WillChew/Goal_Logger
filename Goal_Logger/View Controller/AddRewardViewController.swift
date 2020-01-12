//
//  AddRewardViewController.swift
//  Goal_Logger
//
//  Created by Will Chew on 2019-12-31.
//  Copyright © 2019 Will Chew. All rights reserved.
//

import UIKit
import CoreData

class AddRewardViewController: UIViewController, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var addView: UIView!
    @IBOutlet weak var pointsLabel: UILabel!
    @IBOutlet weak var rewardNameTF: UITextField!
    @IBOutlet weak var costTF: UITextField!
    @IBOutlet weak var stockTF: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var addImageView: UIImageView!
    
    var managedContext: NSManagedObjectContext!
    var data: Data!
    var passedReward: Reward?
    var editMode = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        managedContext = appDelegate?.persistentContainer.viewContext
        setupView()
        
        
        
    }
    
    
    @objc func dismissView(_ sender: Any) {
        
        
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
    
    func setupView() {
        
        costTF.delegate = self
        
        addView.layer.cornerRadius = 8
        blurView.alpha = 0.8
        
        saveButton.layer.cornerRadius = 10
        saveButton.layer.borderWidth = 2
        saveButton.layer.borderColor = UIColor.black.cgColor
        saveButton.isEnabled = false
        
        if !saveButton.isEnabled {
            saveButton.setTitleColor(.gray, for: .disabled)
        }
        
        cancelButton.layer.cornerRadius = 10
        cancelButton.layer.borderWidth = 2
        cancelButton.layer.borderColor = UIColor.black.cgColor
        
        addImageView.layer.borderWidth = 1
        addImageView.layer.borderColor = UIColor.black.cgColor
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView(_:)))
        view.addGestureRecognizer(tapGesture)
        tapGesture.delegate = self
        let points = UserDefaults.standard.integer(forKey: "Points")
        
        pointsLabel.text = "Your Points: \(points)"
        
        let imageViewGesture = UITapGestureRecognizer(target: self, action: #selector(imagePressed(_:)))
        addImageView.addGestureRecognizer(imageViewGesture)
        
        let dismissKB = UITapGestureRecognizer(target: self.addView, action: #selector(UIView.endEditing(_:)))
        addView.addGestureRecognizer(dismissKB)
        
        
        if passedReward == nil {
            editMode = false
        } else {
            editMode = true
            saveButton.setTitle("Save", for: .normal)
            saveButton.isEnabled = true
            
            guard let passedReward = passedReward else { return }
            rewardNameTF.text = passedReward.name
            costTF.text = "\(passedReward.cost)"
            stockTF.text = "\(passedReward.stock)"
            guard let data = passedReward.image else { return }
            addImageView.image = UIImage(data: data)
            
        }
    }
    
    // #PRAGMA MARK: SEGUE
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "unwindAfterAddingRewardSegue" {
            if editMode == false {
                addReward()
            } else if editMode == true {
                editReward(for: passedReward!)
            }
        }
    }
    
    // #PRAGMA MARK: CORE DATA FUNCTIONS
    func addReward() {
        let reward = Reward(context: managedContext)
        
        var rewardName = ""
        
        if rewardNameTF.text == "" {
            rewardName = "Unnamed Reward"
        } else {
            rewardName = rewardNameTF.text!
        }
        reward.name = rewardName
        
        
        let cost = Int32(costTF.text!)!
        reward.cost = cost
        
        var stock : Int32 = 0
        if stockTF.text == "" {
            stock = 1
        } else {
            stock = Int32(stockTF.text!)!
            
        }
        reward.stock = stock
        reward.uuid = UUID()
        
        if data != nil {
            reward.image = data
        }
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Error Saving: \(error), \(error.userInfo)")
        }
    }
    
    func editReward(for reward: Reward) {
        let fetchRequest : NSFetchRequest<Reward> = Reward.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", "uuid", reward.uuid! as CVarArg)
        
        do {
            let reward = try managedContext.fetch(fetchRequest)
            let rewardToChange = reward.first
            
            let cost = Int32(costTF.text!)
            let name = rewardNameTF.text ?? "Unnamed Reward"
            var stock : Int32 = 0
            
            if stockTF.text != nil {
                stock = 1
            } else {
                stock = Int32(stockTF.text!)!
            }
            
            if let data = addImageView.image?.jpegData(compressionQuality: 0.6) {
                rewardToChange?.setValue(data, forKey: "image")
            }
            
            rewardToChange?.setValue(name, forKey: "name")
            rewardToChange?.setValue(cost, forKey: "cost")
            rewardToChange?.setValue(stock, forKey: "stock")
            
            
            try managedContext.save()
            
            
        } catch let error as NSError {
            print("Error editing: \(error), \(error.userInfo)")
        }
    }
    
    
    @IBAction func cancelButtonPressed(_ sender: UIButton) {
        dismissView(self)
    }
    @IBAction func saveButtonPressed(_ sender: UIButton) {
        
        //        dismiss(animated: true, completion: nil)
    }
    
}

extension AddRewardViewController: UITextFieldDelegate {
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if costTF.text != "" {
            saveButton.isEnabled = true
            saveButton.setTitleColor(.white, for: .normal)
        } else {
            saveButton.isEnabled = false
            saveButton.setTitleColor(.darkGray, for: .disabled)
        }
    }
}

extension AddRewardViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // #PRAMGA MARK: IMAGE SELECTION RELATED FUNCTIONS
    
    @objc func imagePressed(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Select a Picture", message: "", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.getImage(fromSourceType: .camera)
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { (action) in
            self.getImage(fromSourceType: .photoLibrary)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func getImage(fromSourceType sourceType: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(sourceType) {
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = sourceType
            self.present(myPickerController, animated: true, completion: nil)
        }
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            addImageView.image = image
            data = image.jpegData(compressionQuality: 0.6)
            
        } else {
            print("Something went wrong")
        }
        self.dismiss(animated: true, completion: nil)
    }
}
