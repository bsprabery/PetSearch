//
//  LostViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class LostViewController: UITableViewController {
        
    @IBOutlet var searchPetsButton: UIBarButtonItem!
    @IBOutlet var addPetButton: UIBarButtonItem!
    
    var lostPets: [Pet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedSingleton.fetchPets(viewControllerName: "Lost", completion: tableView.reloadData)
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.lostPets = Service.sharedSingleton.getPets()
        print(lostPets)
        return lostPets.count
    }
    
    let imageCache = NSCache<NSString, UIImage>()
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = lostPets[indexPath.row]
        let placeholderImage = UIImage(named: "Placeholder")
        cell.petImageView?.image = placeholderImage!
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        
        
        if let cachedImage = imageCache.object(forKey: pet.photoUrl as NSString) {
            cell.petImageView?.image = cachedImage
            cell.setNeedsLayout()
        } else {
            let storRef = FIRStorage.storage().reference(withPath: "\(pet.photoUrl).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                let petImage = UIImage.init(data: data!, scale: 50)
                self.imageCache.setObject(petImage!, forKey: pet.photoUrl as NSString)
                if cell == tableView.cellForRow(at: indexPath) {
                    DispatchQueue.main.async {
                        cell.petImageView.image = petImage
                        cell.setNeedsLayout()
                        print(petImage)
                    }
                }
            }
        }
        
        return cell
    }
    
      //  let storRef = FIRStorage.storage().reference(withPath: "\(pet.photoUrl).jpg")
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addPet(_ sender: AnyObject) {
        Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Lost VC.")
    }
    
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        Service.sharedSingleton.handleLogout()
    }
    
    
}
