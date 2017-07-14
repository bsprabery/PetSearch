//
//  AdoptViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class AdoptViewController: UITableViewController {
    
    //TODO: Add a link to the website icons8.com where I got the top left bar button item - or pay them money.
    
    
    
    var adoptPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
    }

 
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.adoptPets = Service.sharedSingleton.getPets()
        print(adoptPets)
        return adoptPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = adoptPets[indexPath.row]
        let storRef = FIRStorage.storage().reference(withPath: "\(pet.photoUrl).jpg")
        let placeholderImage = UIImage(named: "Placeholder")
        
        cell.petImageView?.sd_setImage(with: storRef, placeholderImage: placeholderImage)
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
       
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = adoptPets[indexPath.row]
        
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Adopt VC.")
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
    }
    
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Manage My Pets", style: .default, handler: { (action) in
                print("Manage my pets clicked.")
            }))
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
                Service.sharedSingleton.handleLogout()
                self.presentAlert(message: "You have signed out successfully.")
                print("Logged out successful")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
}

extension UIViewController {
    func segueToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Login Screen")
        present(destination, animated: true, completion: nil)
    }
    
    func segueToInputView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Nav Controller Two")
        self.present(destination, animated: true, completion: nil)
    }
    
}
