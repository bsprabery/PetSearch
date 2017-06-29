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
    
    var foundPets: [Pet] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Found Cell", for: indexPath) as UITableViewCell
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
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Login Screen")
        //navigationController?.setViewControllers([destination], animated: true)
        
        present(destination, animated: true, completion: nil)
    }
    
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Found VC.")
    }
}
