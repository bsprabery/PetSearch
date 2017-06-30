//
//  Service.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/29/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import Firebase

class Service : NSObject {
    
    func checkIfUserIsLoggedIn(segueOne: () -> Void, segueTwo: @escaping () -> Void) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("User is not logged in.")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
        
        //Present Login Screen
            segueOne()
            
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    User.sharedSingleton.email = dictionary["email"] as? String
                    User.sharedSingleton.firstName = dictionary["firstName"] as? String
                    User.sharedSingleton.lastName = dictionary["lastName"] as? String
                    User.sharedSingleton.phoneNumber = dictionary["phoneNumber"] as? String
                    
                }
                print("\(User.sharedSingleton)")
                }, withCancel: nil)
            
            //Present InputPetTableVC
                segueTwo()
        }
    }
    
    func handleRegister(email: String?, password: String?, firstName: String?, lastName: String?, phoneNumber: String?, completion: @escaping () -> Void) {
        
        guard let email = email, let password = password, let firstName = firstName, let lastName = lastName, let phoneNumber = phoneNumber else {
            print("Form is not valid.")
            //TODO: Present an alert to the user
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                print(error)
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://petsearch-8b839.firebaseio.com/")
            let usersRef = ref.child("users").child(uid)
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "password": password, "phoneNumber": phoneNumber]
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                //TODO: Password must be at least 6 characters long - present error to user
                if err != nil {
                    print(err)
                    return
                }
                
                print("Successfully saved user into Firebase Database.")
                
                completion()
            })
        })
    }
    
    func handleLogin(email: String?, password: String?, completion: @escaping () -> Void) {
        print("Handle Login: Login button clicked.")
        
        guard let email = email, let password = password else {
            print("Form is not valid.")
            //TODO: Present an alert to the user
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
            if error != nil {
                print(error)
                return
            }
            
             completion()
        })
    }
    
    func handleLogout() {
        do {
            try FIRAuth.auth()?.signOut()
        } catch let logoutError {
            print(logoutError)
        }
    }


    
}
