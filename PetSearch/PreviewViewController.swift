//
//  PreviewViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/24/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class PreviewViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet var petNameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var breedLabel: UILabel!
    @IBOutlet var descriptionView: UITextView!
    @IBOutlet var contactButton: UIButton!
    @IBOutlet var statusLabel: UILabel!
    
    var petName: String?
    var date: String?
    var sex: String?
    var species: String?
    var breed: String?
    var petDescription: String?
    var status: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setText()
        addTap()
 
    }
    
    func setText() {
        self.petNameLabel.text = petName
        self.dateLabel.text = date
        self.speciesLabel.text = species
        self.breedLabel.text = breed
        self.sexLabel.text = sex
        self.descriptionView.text = petDescription
        self.statusLabel.text = status
    }
    
    func addTap() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        petImage.isUserInteractionEnabled = true
        petImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let picker = UIImagePickerController()
        picker.delegate = self
     //   let tappedImage = tapGestureRecognizer.view as! UIImageView
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
                picker.sourceType = .camera
            }))
            alert.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
                picker.sourceType = .photoLibrary
                self.present(picker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                picker.dismiss(animated: true, completion: nil)
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        petImage.image = image
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
}
