//
//  FoundViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class FoundViewController: UITableViewController {
    let service: Service = Service()
    var foundPets: [Pet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        service.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.foundPets = service.getPets()
        print(foundPets)
        return foundPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = foundPets[indexPath.row]
        cell.petImageView?.image = service.fetchImage(photoUrl: pet.photoUrl)
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        
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
        service.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Found VC.")
    }
}
