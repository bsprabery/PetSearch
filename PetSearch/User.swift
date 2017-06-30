//
//  User.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/28/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation

struct User {
    
    static var sharedSingleton = User()
    
    var firstName: String?
    var lastName: String?
    var email: String?
    var phoneNumber: String?
    
}
