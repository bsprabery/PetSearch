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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var petPhoto: UIImage?
    let imagePicker = UIImagePickerController()
    var pet: Pet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        addTapGesture()
        layoutView()
        imagePicker.delegate = self
        activityIndicator.isHidden = true
        activityIndicator.layer.zPosition = 1
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    func setText() {
        if let pet = pet {
            self.petNameLabel.text = pet.name
            self.breedLabel.text = pet.breed
            self.sexLabel.text = "\(pet.sex) \(pet.species)"
            self.descriptionView.text = pet.petDetails
            self.statusLabel.text = "\(pet.status.capitalized) since \(pet.date)"
            self.userNameLabel.text = "Point of contact: \(pet.user)"
        } else {
            self.presentWarningToUser(title: "Error", message: "Something seems to have gone wrong. Please try adding your pet information again.")
        }
    }
    
//MARK: Methods relating to picking an image:
    func addTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petImage.isUserInteractionEnabled = true
        petImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        imagePicker.allowsEditing = false
        DispatchQueue.main.async {
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    self.imagePicker.allowsEditing = false
                    self.imagePicker.sourceType = .camera
                    self.imagePicker.cameraCaptureMode = .photo
                    self.imagePicker.modalPresentationStyle = .fullScreen
                    self.present(self.imagePicker, animated: true, completion: nil)
                } else {
                    self.presentWarningToUser(title: "Error", message: "The camera is not available on this device.")
                }
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
    
//MARK: Action methods
    //Upon clicking the "Save" button, this function saves the information and photo to Firebase before unwinding back to the initial view controller.
    @IBAction func savePreview(_ sender: AnyObject) {
        if let photo = petPhoto {
            if var pet = pet {
                Service.sharedSingleton.uploadInfoToFirebaseDatabase(status: pet.status, photo: photo, pet: &pet, completion: segueToUnwind)
                self.navigationItem.rightBarButtonItem?.isEnabled = false
                activityIndicator.isHidden = false
                activityIndicator.startAnimating()
            } else {
                self.presentWarningToUser(title: "Error", message: "There was an error while saving your pet. Please try again.")
            }
        } else {
            self.presentWarningToUser(title: "Photo Required", message: "Please choose a photo of your pet to display.")
        }
    }
    
    func segueToUnwind() {
        self.performSegue(withIdentifier: "unwindAfterSaving", sender: nil)
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
    }
    
    @IBAction func backToInputTableView(_ sender: AnyObject) {
        _ = navigationController?.popViewController(animated: true)
    }
}
