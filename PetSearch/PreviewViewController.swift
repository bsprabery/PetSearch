//
//  PreviewViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/24/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class PreviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var petPhoto: UIImage?
    
    let imagePicker = UIImagePickerController()
    
    var pet: Pet?
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setText()
        addTap()
        contactButton.isEnabled = false
        activityIndicator.isHidden = true
        layoutView()
        roundCorners()
        activityIndicator.layer.zPosition = 1
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func setText() {
        
        if let pet = pet {
            self.petNameLabel.text = pet.name
            self.breedLabel.text = pet.breed
            self.sexLabel.text = "\(pet.sex) \(pet.species)"
            self.descriptionView.text = pet.petDetails
            self.statusLabel.text = "\(pet.status) since \(pet.date)"
            self.userNameLabel.text = "Point of contact: \(pet.user)"
        } else {
            //TODO: Present an error message to the user.
        }
    }
    
    func addTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petImage.isUserInteractionEnabled = true
        petImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        imagePicker.allowsEditing = false
        //   let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                self.imagePicker.sourceType = .camera
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                self.imagePicker.sourceType = .photoLibrary
                self.present(self.imagePicker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.imagePicker.dismiss(animated: true, completion: nil)
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            petImage.contentMode = .scaleAspectFit
            petImage.image = image
            petPhoto = image
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Wait!", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("Okay.")
        }
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    

    
    //MARK: Upon clicking the "Save" button, this function saves the information and photo to Firebase before unwinding back to the initial view controller.
    @IBAction func savePreview(_ sender: AnyObject) {
        if let photo = petPhoto {
            if var pet = pet {
                Service.sharedSingleton.uploadInfoToFirebaseDatabase(photo: photo, pet: &pet, completion: segueToUnwind)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                print("pet was nil.")
            }
        } else {
            presentAlert(message: "Please select a photo of your pet to display.")
            print("No pet photo was selected.")
        }  
    }
       
    func segueToUnwind() {
        self.performSegue(withIdentifier: "unwindAfterSaving", sender: nil)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    
}
