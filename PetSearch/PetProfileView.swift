//
//  Pet Profile View.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/15/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class PetProfileView: UIViewController {
    
    
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var petImageView: UIImageView!
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var animalTypeLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var petOwnerNameLabel: UILabel!
    @IBOutlet var petDetailsLabel: UILabel!
    @IBOutlet var contactButton: UIButton!
        
    var petProfile: Pet?
    var petImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpProfile(petDetails: petProfile)
        roundCorners()
        layoutView()
    }
    
    
    func setUpProfile(petDetails: Pet?) {
        
        guard let petDetails = petProfile else {
            return
        }
     //   petImageView.backgroundColor = UIColor.black
        
        statusLabel.text! = "\(petDetails.status) since \(petDetails.date)"
        petNameLabel.text! = petDetails.name
        petImageView.image = petImage!
        animalTypeLabel.text! = "\(petDetails.species), \(petDetails.sex)"
        breedLabel.text! = petDetails.breed
        petOwnerNameLabel.text! = "Point of contact: \(petDetails.user)"
        petDetailsLabel.text! = petDetails.petDetails
        setNavTitle(status: petDetails.status)

    }
    
    func roundCorners() {
        petImageView.layer.cornerRadius = 5.0
        petImageView.clipsToBounds = true
        contactButton.layer.cornerRadius = 5.0
    }
    
    func setNavTitle(status: String) {
        
        guard let petDetails = petProfile else {
            return
        }
        
        switch status {
        case "Lost":
            self.navigationItem.title = "MISSING"
        case "Found":
            self.navigationItem.title = "FOUND"
        case "Adopt":
            self.navigationItem.title = "Adopt me!"
        default:
            self.navigationItem.title = petDetails.name
        }
    }
    
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactButtonTapped(_ sender: AnyObject) {
        print("Contact Button Tapped.")
    }
}
