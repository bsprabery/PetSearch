//
//  PetStruct.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/13/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import Firebase

struct Pet {
        
    var name: String
    let species: String
    let sex: String
    let breed: String
    let petDetails: String
    let date: String
    var status: String
    let user: String
    let email: String
    let phoneNumber: String
    let latitude: Double
    let longitude: Double
    var petID: String
    var userID: String
    var key: String
    var timeStamp: NSNumber
    
    init(name: String, species: String, sex: String, breed: String, petDetails: String, date: String, status: String, user: String, email: String, phoneNumber: String, latitude: Double, longitude: Double, petID: String, userID: String, key: String = "", timeStamp: NSNumber) {
        self.name = name
        self.species = species
        self.sex = sex
        self.breed = breed
        self.petDetails = petDetails
        self.date = date
        self.status = status
        self.user = user
        self.email = email
        self.phoneNumber = phoneNumber
        self.latitude = latitude
        self.longitude = longitude
        self.petID = petID
        self.userID = userID
        self.key = key
        self.timeStamp = timeStamp
    }
    
    init(snapshot: FIRDataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value! as! [String: AnyObject]
        name = snapshotValue["name"] as! String
        species = snapshotValue["species"] as! String
        sex = snapshotValue["sex"] as! String
        breed = snapshotValue["breed"] as! String
        petDetails = snapshotValue["petDetails"] as! String
        date = snapshotValue["date"] as! String
        status = snapshotValue["status"] as! String
        user = snapshotValue["user"] as! String
        email = snapshotValue["email"] as! String
        phoneNumber = snapshotValue["phoneNumber"] as! String
        latitude = snapshotValue["latitude"] as! Double
        longitude = snapshotValue["longitude"] as! Double
        petID = snapshotValue["petID"] as! String
        userID = snapshotValue["userID"] as! String
        timeStamp = snapshotValue["timeStamp"] as! NSNumber
    }
    
    func toAnyObject() -> [String:Any] {
        return [
            "name": name,
            "species": species,
            "sex": sex,
            "breed": breed,
            "petDetails": petDetails,
            "date": date,
            "status": status,
            "user": user,
            "email": email,
            "phoneNumber": phoneNumber,
            "latitude": latitude,
            "longitude": longitude,
            "petID": petID,
            "userID": userID,
            "timeStamp": timeStamp
        ]
    }
}
