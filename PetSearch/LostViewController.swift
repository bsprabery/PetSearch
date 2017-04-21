//
//  LostViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class LostViewController: UITableViewController {
    
    
    @IBOutlet var searchPetsButton: UIBarButtonItem!
    @IBOutlet var addPetButton: UIBarButtonItem!
    
    var lostPets: [Pet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Lost Cell", for: indexPath) as UITableViewCell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    @IBAction func addPet(_ sender: AnyObject) {
//        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let destination = storyboard.instantiateViewController(withIdentifier: "Input Table View")
////        navigationController?.setViewControllers([destination], animated: true)
//        
//        present(destination, animated: true, completion: nil)
        
    }

    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Lost VC.")
    }
    
}
