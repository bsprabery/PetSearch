//
//  FoundViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class FoundViewController: UITableViewController {
    
    var foundPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    let imageCache = NSCache<NSString, UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedSingleton.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        
//        if self.hasConnectivity() == false {
//            presentWarningToUser(title: "Warning", message: "Your device cannot connect to the network. App functionality may be impaired.")
//        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.foundPets = Service.sharedSingleton.getPets()
        print(foundPets)
        return foundPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = foundPets[indexPath.row]
        let placeholderImage = UIImage(named: "Placeholder")
        cell.petImageView?.image = placeholderImage!
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        
        if let cachedImage = imageCache.object(forKey: pet.photoUrl as NSString) {
            cell.petImageView?.image = cachedImage
            cell.setNeedsLayout()
        } else {
            //Returning the cell before completing the storage download:
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
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = foundPets[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! PetCell
        petPic = cell.petImageView.image
        
        performSegue(withIdentifier: "SegueToProfileView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToProfileView" {
            let destinationNavController = segue.destination as! UINavigationController
            let petProfileVC = destinationNavController.topViewController as! PetProfileView
            petProfileVC.petProfile = petDetails
            petProfileVC.petImage = petPic!
        }
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        if hasConnectivity() == false {
            self.presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please connect to a network to add a pet.")
        } else {
            Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Manage My Pets", style: .default, handler: { (action) in
                if Service.sharedSingleton.IsUserLoggedInReturnBool() {
                    Service.sharedSingleton.fetchPetsForUser(segue: self.segueToManageScreen)
                    //self.performSegue(withIdentifier: "Segue To Manage", sender: nil)
                } else {
                    self.segueToLoginScreen()
                }
                print("Manage my pets clicked.")
            }))
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
                Service.sharedSingleton.handleLogout()
                self.presentWarningToUser(title: "Success!", message: "You have logged out.")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Found VC.")
    }
}
