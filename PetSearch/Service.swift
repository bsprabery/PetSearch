//
//  Service.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/29/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuthUI

class Service : NSObject {
    
    static var sharedSingleton = Service()
    
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
                    
                    let uid = dictionary["uid"] as? String
                    let email = dictionary["email"] as? String
                    let firstName = dictionary["firstName"] as? String
                    let phoneNumber = dictionary["phoneNumber"] as? String
                    
                    self.writeToDisk(email: email!, firstName: firstName!, phoneNumber: phoneNumber!, uid: uid!)
                }

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
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "password": password, "phoneNumber": phoneNumber, "uid": uid]
            
            self.writeToDisk(email: email, firstName: firstName, phoneNumber: phoneNumber, uid: uid)
            
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

    func writeToDisk(email: String, firstName: String, phoneNumber: String, uid: String) {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = directories[0] as! String
        let path = documentsDirectory.appending("/userInfo.plist")
        self.setUrl(path: path)
        
        let dictionary = ["email" : email, "name" : firstName, "phoneNumber" : phoneNumber, "uid" : uid] as NSDictionary
        dictionary.write(toFile: path, atomically: true)
        print(dictionary)
    }
    
    func getUserDetails() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                let uid = dictionary["uid"] as? String
                let email = dictionary["email"] as? String
                let firstName = dictionary["firstName"] as? String
                let phoneNumber = dictionary["phoneNumber"] as? String
                
                let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
                let documentsDirectory = directories[0] as! String
                let path = documentsDirectory.appending("/userInfo.plist")
                self.setUrl(path: path)
  
                let dictionary = ["email" : email!, "name" : firstName!, "phoneNumber" : phoneNumber!, "uid" : uid!] as NSDictionary
                dictionary.write(toFile: path, atomically: true)
            }
        }, withCancel: nil)
    }

    func readFromDisk() -> NSMutableDictionary {
        print(getUrl())
        let userInfo = NSMutableDictionary(contentsOfFile: getUrl())
        print(userInfo!)
        return userInfo!
    }
    
    func handleLogin(email: String?, password: String?, completion: @escaping () -> Void) {
        print("Handle Login: Login button clicked.")
        
        guard let email = email, let password = password else {
            print("Form is not valid.")
            //TODO: Present an alert to the user
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                print(error)
                return
            }
            
            self.getUserDetails()
            
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
    
    
    //MARK: The pet photo can be retrieved with the pet ID. There is no need for a pet photoUrl anymore.
    func uploadInfoToFirebaseDatabase(photo: UIImage, pet: inout Pet, completion: () -> ()) {
        let ref = FIRDatabase.database().reference()
      
        let petRef = ref.child("pets").childByAutoId()
        let petString = "\(petRef)"
        let petID = petString.components(separatedBy: "https://petsearch-8b839.firebaseio.com/pets/")
        pet.petID = petID[1]
        pet.photoUrl = petID[1]
        
        let userDict = readFromDisk()
        let uid = userDict["uid"] as! String
        pet.userID = "\(uid)"

        
        petRef.setValue(pet.toAnyObject())
        uploadImageToFirebaseStorage(photo: photo, pet: pet, completion: completion)
    }
    
    func uploadImageToFirebaseStorage(photo: UIImage, pet: Pet, completion: () -> ()) {
        
        guard let imageData = UIImageJPEGRepresentation(photo, 0.8) else {
            return
        }
        
        let data = imageData
        let storageRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        storageRef.put(data as Data, metadata: uploadMetadata) { (metadata, error) in
            if (error != nil) {
               // self.presentAlert(message: "There was an error uploading your image. Please try again.")
                print("There was an error! \(error?.localizedDescription)")
            } else {
                print("Upload complete! Here's some metadata: \(metadata)")
                print("Download URL: \(metadata?.downloadURL())")
            }
        }
        
        completion()
    }
    
    
    func fetchPets(viewControllerName: String, completion: @escaping () -> Void) {
       
        let ref = FIRDatabase.database().reference().child("pets").queryOrdered(byChild: "status")
        
        switch viewControllerName {
        case "Adopt":
            ref.queryEqual(toValue: "Available to Adopt").observe(.value, with: { (snapshot) in
                var adoptPets: [Pet] = []
                
                for pet in snapshot.children {
                    let adoptPet = Pet(snapshot: pet as! FIRDataSnapshot)
                    adoptPets.append(adoptPet)
                    
                    self.setPets(pets: adoptPets)
                }
                completion()
        })
        case "Found":
            ref.queryEqual(toValue: "Found").observe(.value, with: { (snapshot) in
                var foundPets: [Pet] = []
                
                for pet in snapshot.children {
                    let foundPet = Pet(snapshot: pet as! FIRDataSnapshot)
                    foundPets.append(foundPet)
                    
                    self.setPets(pets: foundPets)
                }
                completion()
        })
        case "Lost":
            ref.queryEqual(toValue: "Lost").observe(.value, with: { (snapshot) in
                var lostPets: [Pet] = []

                for pet in snapshot.children {
                    let lostPet = Pet(snapshot: pet as! FIRDataSnapshot)
                    lostPets.append(lostPet)
                    
                    self.setPets(pets: lostPets)
                }
                completion()
        })
        default:
            print("There were no views found with this identifier.")
        }
        
    }

    private var petArray: [Pet]
    private var userInfoPath: String
    
    override init() {
        petArray = [Pet]()
        userInfoPath = String()
    }
    
    func setPets(pets: [Pet]) {
        self.petArray = pets
    }

    func getPets() -> [Pet] {
        return petArray
    }
    
    func setUrl(path: String) {
        self.userInfoPath = path
        print(path)
    }
    
    func getUrl() -> String {
        print(self.userInfoPath)
        return self.userInfoPath
    }
    
}
