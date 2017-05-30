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
    
    let ref = FIRDatabase.database().reference()
    

    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var statusLabel: UILabel!
    
    var petPhoto: UIImage?
    
    let imagePicker = UIImagePickerController()
    
    var pet: Pet?
    
       
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker.delegate = self
        setText()
        addTap()
    }
    
    func setText() {
        self.petNameLabel.text = pet?.name
        self.dateLabel.text = pet?.date
        self.speciesLabel.text = pet?.species
        self.breedLabel.text = pet?.breed
        self.sexLabel.text = pet?.sex
        self.descriptionView.text = pet?.petDetails
        self.statusLabel.text = pet?.status
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
        let alertController = UIAlertController(title: "Default Style", message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            print("Okay.")
        }
        
        alertController.addAction(okayAction)
        self.present(alertController, animated: true)
    }
    
    func uploadImageToFirebaseStorage(uniqueID: String) {
        
        guard let petPhoto = petPhoto else {
            presentAlert(message: "Please select a photo of your pet to display.")
            return
        }
        
        guard let imageData = UIImageJPEGRepresentation(petPhoto, 0.8) else {
            presentAlert(message: "Please select a photo of your pet to display.")
            return
        }

        let data = imageData
        let storageRef = FIRStorage.storage().reference(withPath: "petPhotos/\(uniqueID).jpg")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        storageRef.put(data as Data, metadata: uploadMetadata) { (metadata, error) in
            if (error != nil) {
                self.presentAlert(message: "There was an error uploading your image. Please try again.")
                print("There was an error! \(error?.localizedDescription)")
            } else {
                print("Upload complete! Here's some metadata: \(metadata)")
                print("Download URL: \(metadata?.downloadURL())")
            }
        }
    }

    
    func uploadInfoToFirebaseDatabase() {

        let petRef = self.ref.childByAutoId()
        let stringRef = "\(petRef)"
        let photoRef = stringRef.components(separatedBy: "https://petsearch-8b839.firebaseio.com/")
        pet?.photoUrl = photoRef[1]
        petRef.setValue(pet?.toAnyObject())
        uploadImageToFirebaseStorage(uniqueID: (pet?.photoUrl)!)
    }
    
    
    @IBAction func savePreview(_ sender: AnyObject) {
        //MARK: Save the information to firebase Database
        //MARK: Save photo to firebase Storage
        uploadInfoToFirebaseDatabase()
        
        //TODO: Transition back to original view controller
        
    }
    
  
    
    
    
    
    
}
