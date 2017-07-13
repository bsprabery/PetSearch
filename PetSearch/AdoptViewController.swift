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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 107
//    }
 
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
      //  let indexPath = tableView.indexPathForSelectedRow!
       // let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Detail View")
        navigationController?.pushViewController(destination, animated: true)
        
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Adopt VC.")
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
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
