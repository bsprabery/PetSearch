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
    let mailComposer = MailComposer()
    
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
        
        guard let petDetails = petProfile else {
            return
        }
        
        let application = UIApplication.shared
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Call Telephone Number", style: .default, handler: { (action) in
                let phoneNumber = URL(string: petDetails.phoneNumber)
                
                if application.canOpenURL(phoneNumber!) {
                    application.open(phoneNumber!, options: [:], completionHandler: nil)
                } else {
                    self.presentWarningToUser(title: "Error", message: "The phone number provided is invalid. Please try another contact method.")
                }
            }))
            alert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { (action) in
                 print("Send Email clicked.")
                let mailComposeViewController = self.mailComposer.configuredMailComposeViewController(recipient: ["\(petDetails.email)"], subject: "Your PetSearch post regarding: \(petDetails.name)", messageBody: "Text Body")
                if self.mailComposer.canSendEmail() {
                    self.present(mailComposeViewController, animated: true, completion: nil)
                } else {
                    self.presentWarningToUser(title: "Error", message: "We are unable to contact this user through email at this time. Please try another contact method.")
                }
            }))           
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
        
    }

    
}
