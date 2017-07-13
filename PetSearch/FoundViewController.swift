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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedSingleton.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.foundPets = Service.sharedSingleton.getPets()
        print(foundPets)
        return foundPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = foundPets[indexPath.row]
        
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
         let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
//        valueToPass = currentCell.textLabel?.text
//        performSegue(withIdentifier: "Found to Detail", sender: self)
        
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let destination = storyboard.instantiateViewController(withIdentifier: "Detail View")
//        navigationController?.pushViewController(destination, animated: true)
        
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if (segue.identifier == "Found to Detail") {
//            var viewController = segue.destination as! DetailViewController
//            viewController. = valueToPass
//            
//        }
//    }
    
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Found VC.")
    }
}
