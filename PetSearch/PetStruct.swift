//
//  PetStruct.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/13/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

struct Pet {
    
    let name: String!
    //Probably be better to do location as coordinates and map it, so you can filter by miles around the user.
    let location: String!
    let species: String!
    let breed: String
    let petImage: UIImage!
    let petDetails: String
    let date: String
    
}
