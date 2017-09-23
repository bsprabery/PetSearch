//
//  ManagePets.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 7/24/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class ManagePets: UITableViewController {
    
    var userPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        self.navigationItem.title = "Manage Pets"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //Retrieve pets specific to the current user:
        self.userPets = Service.sharedSingleton.getPets()
    }
    
    func getStatusFor(petID: String) -> String {
        var status = userPets.filter({$0.petID == petID}).last?.status
        
        //If status is "availabe to adopt" this will catch it and set the status as the expected "adopt":
        if ((status?.range(of: "adopt")) != nil) {
            status = "adopt"
        }
        return status!
    }
    
//MARK: TableView Methods:
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = userPets[indexPath.row]
        let placeholderImage = UIImage(named: "Placeholder")
        cell.petImageView?.image = placeholderImage!
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.contents = 5.0
        cell.petInfoLabel.text = "\(pet.petID)"
        cell.activityIndicator.isHidden = false
        cell.activityIndicator.startAnimating()
        
        //Download pet image from Firebase Storage:
        let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
        storRef.data(withMaxSize: INT64_MAX) { (data, error) in
            
            guard error == nil else {
                self.presentWarningToUser(title: "Error", message: "Photo not found.")
                return
            }
            
            let petImage = UIImage.init(data: data!, scale: 50)
            if cell == tableView.cellForRow(at: indexPath) {
                //Set image:
                DispatchQueue.main.async {
                    cell.petImageView.image = petImage
                    cell.petImageView.layer.cornerRadius = 5.0
                    cell.activityIndicator.stopAnimating()
                    cell.activityIndicator.isHidden = true
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)! as! PetCell
            
            //Get PetID to delete from database:
            let petID = cell.petInfoLabel.text
            
            //Delete pet from database:
            Service.sharedSingleton.deletePets(status: getStatusFor(petID: petID!), petID: petID!)
            
            //Remove from pet array populating tableView:
            userPets.remove(at: indexPath.row)
            
            //Delete row from table:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//MARK: Action Methods:
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: notificationKey), object: self)
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    
    
    
    
    
    
    
}
