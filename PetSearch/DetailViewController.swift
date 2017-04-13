//
//  DetailViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class DetailViewController: UIViewController {
    
    var pet: Pet!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var petImage: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var contactButton: UIButton!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameLabel.text = pet.name
        dateLabel.text = pet.date
        detailLabel.text = pet.petDetails
        petImage.image = pet.petImage
        locationLabel.text = pet.location
        
        
    }
    
}
