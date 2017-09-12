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
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Retrieve pets specific to the current user:
        self.userPets = Service.sharedSingleton.getPets()
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        self.navigationItem.title = "Manage Pets"
        self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("User Pets: \(userPets.count)")
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
        cell.petStatusLabel.text = "\(pet.status)"
        
        //TODO: Remove unnecessary code about cache
        
        if let cachedImage = imageCache.object(forKey: pet.petID as NSString) {
            cell.petImageView?.image = cachedImage
            cell.setNeedsLayout()
        } else {
            let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                let petImage = UIImage.init(data: data!, scale: 50)
                self.imageCache.setObject(petImage!, forKey: pet.petID as NSString)
                if cell == tableView.cellForRow(at: indexPath) {
                    DispatchQueue.main.async {
                        cell.petImageView.image = petImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell

    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func getStatusFor(petID: String) -> String {
        var status = userPets.filter({$0.petID == petID}).last?.status
        if ((status?.range(of: "adopt")) != nil) {
            status = "adopt"
        }
        return status!
    }
    
    //TODO: Deletes only one at a time, does not delete multiple?
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let cell = tableView.cellForRow(at: indexPath)! as! PetCell
            
            //Get PetID to delete from database:
            let petID = cell.petInfoLabel.text
//            let status = cell.petStatusLabel.text
            
            //Delete pet from database:
            Service.sharedSingleton.deletePets(status: getStatusFor(petID: petID!), petID: petID!)
            
            //Remove from pet array populating tableView:
            userPets.remove(at: indexPath.row)
            
            //Delete row from table:
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }

    @IBAction func backButtonTapped(_ sender: AnyObject) {
        NotificationCenter.default.post(name: Notification.Name("refreshAfterDeletion"), object: nil)
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
       // dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
