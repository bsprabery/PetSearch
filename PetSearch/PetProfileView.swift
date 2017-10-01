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
    @IBOutlet var petDetailsTextView: UITextView!
    @IBOutlet var contactButton: UIButton!
        
    var petProfile: Pet?
    var petImage: UIImage?
    let mailComposer = MailComposer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProfile(petDetails: petProfile)
        layoutView()
        
        let pictureTap = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(_:)))
        petImageView.addGestureRecognizer(pictureTap)
        petImageView.isUserInteractionEnabled = true
    }
    
    func imageTapped(_ sender: UITapGestureRecognizer) {
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        newImageView.frame = UIScreen.main.bounds
        newImageView.backgroundColor = .black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullScreenImage))
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    func dismissFullScreenImage(_ sender: UITapGestureRecognizer) {
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
//MARK: Methods for populating the view controller's information fields:
    func setUpProfile(petDetails: Pet?) {
        guard let petDetails = petDetails else {
            self.presentWarningToUser(title: "We're sorry!", message: "Something seems to have gone wrong. Please try viewing this pet again.")
            return
        }
        
        statusLabel.text! = "\(petDetails.status.capitalized) since \(petDetails.date)"
        petNameLabel.text! = petDetails.name
        petImageView.image = petImage!
        animalTypeLabel.text! = "\(petDetails.species), \(petDetails.sex)"
        breedLabel.text! = petDetails.breed
        petOwnerNameLabel.text! = "Point of contact: \(petDetails.user)"
        petDetailsTextView.text! = petDetails.petDetails
        setNavTitle(status: petDetails.status)        
    }

    func setNavTitle(status: String) {
        
        guard let petDetails = petProfile else {
            self.presentWarningToUser(title: "We're sorry!", message: "Something seems to have gone wrong. Please try viewing this pet again.")
            return
        }
        
        switch status {
        case "lost":
            self.navigationItem.title = "MISSING"
        case "found":
            self.navigationItem.title = "FOUND"
        case "available to adopt":
            self.navigationItem.title = "Adopt me!"
        default:
            self.navigationItem.title = petDetails.name
        }
    }
    
//MARK: Action methods:
    @IBAction func backButtonTapped(_ sender: AnyObject) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func contactButtonTapped(_ sender: AnyObject) {
        guard let petDetails = petProfile else {
            self.presentWarningToUser(title: "We're sorry!", message: "Something seems to have gone wrong while retrieving this pet owner's contact information.")
            return
        }
        
        let application = UIApplication.shared
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Call Telephone Number", style: .default, handler: { (action) in
                let phoneNumber = URL(string: "tel://\(petDetails.phoneNumber)")
                if application.canOpenURL(phoneNumber!) {
                    application.open(phoneNumber!, options: [:], completionHandler: nil)
                } else {
                    self.presentWarningToUser(title: "Error", message: "The phone number provided is invalid. Please try another contact method.")
                }
            }))
            
            alert.addAction(UIAlertAction(title: "Send Email", style: .default, handler: { (action) in
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
