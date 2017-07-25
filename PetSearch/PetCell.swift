//
//  PetCell.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 7/6/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit

class PetCell: UITableViewCell {


    @IBOutlet var petImageView: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var detailsLabel: UILabel!
    
    //This label allows the petID to be saved to the cell for the Manage Pets scene. The label is always hidden.
    @IBOutlet var petInfoLabel: UILabel!

    
    
}
