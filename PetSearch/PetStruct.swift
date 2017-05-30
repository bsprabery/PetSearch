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
    
    let name: String
    //Probably be better to do location as coordinates and map it, so you can filter by miles around the user.
   // let location: String
    let species: String
    let sex: String
    let breed: String
    var photoUrl: String
    let petDetails: String
    let date: String
    let status: String
    let user: String
    let email: String
    let phoneNumber: String
    
    init(name: String, species: String, sex: String, breed: String, photoUrl: String, petDetails: String, date: String, status: String, user: String, email: String, phoneNumber: String) {
        self.name = name
        self.species = species
        self.sex = sex
        self.breed = breed
        self.photoUrl = photoUrl
        self.petDetails = petDetails
        self.date = date
        self.status = status
        self.user = user
        self.email = email
        self.phoneNumber = phoneNumber
    }
    
    func toAnyObject() -> [String:String] {
        return [
            "name": name,
            "species": species,
            "sex": sex,
            "breed": breed,
            "photoUrl": photoUrl,
            "petDetails": petDetails,
            "date": date,
            "status": status,
            "user": user,
            "email": email,
            "phoneNumber": phoneNumber
        ]
    }
    
}
//
//struct User {
//    let name: String
//    let email: String
//    let phoneNumber: Double
//}
