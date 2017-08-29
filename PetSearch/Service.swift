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
            
            //Present InputPetTableVC or Manage Pets View
                segueTwo()
        }
    }
    
    func IsUserLoggedInReturnBool() -> Bool {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            print("User is not logged in.")
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            
            return false
            
        } else {
            return true
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
    func uploadInfoToFirebaseDatabase(status: String, photo: UIImage, pet: inout Pet, completion: @escaping () -> ()) {
        let ref = FIRDatabase.database().reference()
        var petRef: FIRDatabaseReference = FIRDatabaseReference()
        var petStatus: String = ""
        
        switch status {
        case "Lost":
            petRef = ref.child("pets").child("lost").childByAutoId()
            petStatus = "lost"
        case "Found":
            petRef = ref.child("pets").child("found").childByAutoId()
            print("petRef: \(petRef)")
            petStatus = "found"
        case "Adopt":
            petRef = ref.child("pets").child("adopt").childByAutoId()
            petStatus = "adopt"
        default:
            break
        }
        
        let petString = "\(petRef)" + "\(petStatus)"
        let petID = petString.components(separatedBy: "https://petsearch-8b839.firebaseio.com/pets/\(petStatus)/")
        let petIDwStatus: String = petID[1]
        let newPetID = petIDwStatus.components(separatedBy: "found")[0]
        pet.petID = newPetID
        
        let geoFire = GeoFire(firebaseRef: ref.child("pets_location"))
        geoFire?.setLocation(CLLocation(latitude: pet.latitude, longitude: pet.longitude), forKey: pet.petID)
        
        let userDict = readFromDisk()
        let uid = userDict["uid"] as! String
        pet.userID = "\(uid)"
        
        petRef.setValue(pet.toAnyObject())
        uploadImageToFirebaseStorage(photo: photo, pet: pet, completion: completion)
    }
    
    func uploadImageToFirebaseStorage(photo: UIImage, pet: Pet, completion: @escaping () -> ()) {
        
        guard let imageData = UIImageJPEGRepresentation(photo, 0.8) else {
            return
        }
        
        let data = imageData
        let storageRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
        let uploadMetadata = FIRStorageMetadata()
        uploadMetadata.contentType = "image/jpeg"
        
        storageRef.put(data as Data, metadata: uploadMetadata) { (metadata, error) in
            if (error != nil) {
                print("There was an error! \(error?.localizedDescription)")
            } else {
                print("Upload complete! Here's some metadata: \(metadata)")
                print("Download URL: \(metadata?.downloadURL())")
                print("downloadUrl: \(metadata?.downloadURL())")
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }
    }
    
    func deletePets(petID: String) {
        
        let ref = FIRDatabase.database().reference().child("pets").child("\(petID)")
        let storageRef = FIRStorage.storage().reference(withPath: "\(petID).jpg")
        
        //Delete pet data from database:
        ref.removeValue { error in
            if error != nil {
                print("There was an error deleting the pet from the database. Error: \(error)")
            }
        }
        
        //Deletes the photo from storage:
        storageRef.delete(completion: { (error) in
            if let error = error {
                print("There was an error deleting an image from storage: \(error)")
            } else {
                print("Image was successfully deleted from storage.")
            }
        })
        
    }

    func fetchPetsForUser(segue: @escaping () -> ()) {
        
        self.setPets(pets: [])
        let ref = FIRDatabase.database().reference().child("pets").queryOrdered(byChild: "userID")
        let userID = FIRAuth.auth()?.currentUser?.uid
        
        ref.queryEqual(toValue: userID).observe(.value, with: { (snapshot) in
          
            var userPets: [Pet] = []
            
            for pet in snapshot.children {
                print(pet)
                let userPet = Pet(snapshot: pet as! FIRDataSnapshot)
                userPets.append(userPet)
                
                self.setPets(pets: userPets)
            }
            segue()
        })
    }
    
    
    func fetchPets(viewControllerName: String, completion: @escaping () -> Void) {
        self.setPets(pets: [])
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
                self.setPets(pets: [])
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
                self.setPets(pets: [])
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
                self.setPets(pets: [])
        })
        default:
            print("There were no views found with this identifier.")
        }
    }
    
    var petsDownloaded = false
    
    func fetchPetsForLocation(viewController: String, completion: @escaping () -> ()) {
        let userLocation = getUserLocation()
        let geoFireRef = FIRDatabase.database().reference().child("pets_location")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        let center = CLLocation(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        let circleQuery = geoFire!.query(at: center, withRadius: 100)
        
        
        
        circleQuery?.observe(.keyEntered, with: { (key, location) in
            if let key = key {
                self.locatedPetIDs.append(key)
                print("The key returned by Firebase: \(key)")
                print("The number of keys in the locatedPetIDs array: \(self.locatedPetIDs.count)")
                
                //This is true if the observeReady block has been called before. 
                //Calling this ensures that any pets added to the database after the initial download, will be downloaded and added to the tableView.
                if self.petsDownloaded {
                    self.fetchLocatedPets(viewControllerName: viewController, petID: key, completion: completion)
                }
            } else {
                completion()
            }
        })
        
        //This block is triggered once the above query has finished returning ALL the results for the location query:
        circleQuery?.observeReady({
            for petID in self.locatedPetIDs {
                self.fetchLocatedPets(viewControllerName: viewController, petID: petID, completion: completion)
            }
            self.petsDownloaded = true
        })
    }
    
    func fetchLocatedPets(viewControllerName: String, petID: String, completion: @escaping () -> ()) {
        let ref = FIRDatabase.database().reference().child("pets").child(viewControllerName).queryOrdered(byChild: "petID")
        ref.queryEqual(toValue: petID).observeSingleEvent(of: .value, with: { (snapshot) in
            if (snapshot.exists()) {
                for pet in snapshot.children {
                    let locatedPet = Pet(snapshot: pet as! FIRDataSnapshot)
                    print(locatedPet)
                    switch viewControllerName{
                    case "found":
                        self.foundPets.append(locatedPet)
                    case "lost":
                        self.lostPets.append(locatedPet)
                    case "adopt":
                        self.adoptPets.append(locatedPet)
                    default:
                        break
                    }
                }
            }
            
            //MARK: Seems sloppy:
            if self.locatedPetIDs.count == self.foundPets.count {
                completion()
            }
        })
    }

    private var petArray: [Pet]
    private var userInfoPath: String
    private var userLocation: CLLocation?
    private var locatedPetIDs: [String]
    lazy var lostPets = [Pet]()
    lazy var foundPets = [Pet]()
    lazy var adoptPets = [Pet]()
    
    override init() {
        petArray = [Pet]()
        userInfoPath = String()
        userLocation = CLLocation()
        locatedPetIDs = [String]()
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
    
    func setUserLocation(location: CLLocation) {
        self.userLocation = location
    }
    
    func getUserLocation() -> CLLocation? {
        print(self.userLocation)
        return self.userLocation
    }
    
    func setPetsForLocation(array: [String]) {
        self.locatedPetIDs = array
    }
    
    func getPetsForLocation() -> [String] {
        return self.locatedPetIDs
    }
    
    func getFoundPets() -> [Pet] {
        return self.foundPets
    }

}
