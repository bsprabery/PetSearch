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
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    static var sharedSingleton = Service()
    
//MARK: Authentication Methods:
    func checkIfUserIsLoggedIn(segueOne: () -> Void, segueTwo: @escaping () -> Void) {
        if FIRAuth.auth()?.currentUser?.uid == nil {
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            //Present Login Screen
            segueOne()
        } else {
            let uid = FIRAuth.auth()?.currentUser?.uid
            FIRDatabase.database().reference().child("users").child(uid!).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
                
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
            perform(#selector(handleLogout), with: nil, afterDelay: 0)
            return false
        } else {
            return true
        }
    }
    
    func handleRegister(callingViewController: LoginScreen, email: String?, password: String?, firstName: String?, lastName: String?, phoneNumber: String?, completion: @escaping () -> Void) {
        
        func checkIfStringIsEmpty(string: String) -> Bool {
            if string.isEmpty {
                return true
            } else {
                return false
            }
        }
        
        if checkIfStringIsEmpty(string: email!) || checkIfStringIsEmpty(string: password!) || checkIfStringIsEmpty(string: firstName!) || checkIfStringIsEmpty(string: lastName!) || checkIfStringIsEmpty(string: phoneNumber!) {
            self.appDelegate.alertView(errorMessage: "Please provide information for each field. All fields are required to register.", viewController: callingViewController)
            return
        }
        
        guard let email = email, let password = password, let firstName = firstName, let lastName = lastName, let phoneNumber = phoneNumber else {
            return
        }
        
        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user: FIRUser?, error) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    self.handleAuthError(errCode: errCode, callingViewController: callingViewController)
                }
                return
            }
            
            guard let uid = user?.uid else {
                return
            }
            
            let ref = FIRDatabase.database().reference(fromURL: "https://petsearch-8b839.firebaseio.com/")
            let usersRef = ref.child("users").child(uid).child("userInfo")
            let values = ["firstName": firstName, "lastName": lastName, "email": email, "password": password, "phoneNumber": phoneNumber, "uid": uid]
            
            self.writeToDisk(email: email, firstName: firstName, phoneNumber: phoneNumber, uid: uid)
            
            usersRef.updateChildValues(values, withCompletionBlock: { (err, ref) in
                if err != nil {
                    print(err)
                    return
                }
                
                print("Successfully saved user into Firebase Database.")
                
                completion()
            })
       })
    }
    
    func handleLogin(email: String?, password: String?, callingViewController: LoginScreen, completion: @escaping () -> Void) {
        print("Handle Login: Login button clicked.")
        
        guard let email = email, let password = password else {
            return
        }
        
        FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user: FIRUser?, error: Error?) in
            if error != nil {
                if let errCode = FIRAuthErrorCode(rawValue: error!._code) {
                    self.handleAuthError(errCode: errCode, callingViewController: callingViewController)
                }
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
            print("Error: \(logoutError)")
        }
    }
    
//MARK: Authentication Error Handling:
    func handleAuthError(errCode: FIRAuthErrorCode, callingViewController: UIViewController) {
        switch errCode {
        case .errorCodeInvalidEmail:
            self.appDelegate.alertViewTwo(errorMessage: "Please enter a valid email address.", viewController: callingViewController)
        case .errorCodeNetworkError:
            self.appDelegate.alertViewTwo(errorMessage: "We were unable to add you as a new user due to a poor network connection. Please try again.", viewController: callingViewController)
        case .errorCodeUserNotFound:
            self.appDelegate.alertViewTwo(errorMessage: "We were unable to locate your account information.", viewController: callingViewController)
        case .errorCodeUserTokenExpired:
            self.appDelegate.alertViewTwo(errorMessage: "Your login has expired. Please sign in again.", viewController: callingViewController)
        case .errorCodeInternalError:
            self.appDelegate.alertViewTwo(errorMessage: "An unknown error has occurred. Please try again later.", viewController: callingViewController)
        case .errorCodeUserDisabled:
            self.appDelegate.alertViewTwo(errorMessage: "Your account has been disabled.", viewController: callingViewController)
        case .errorCodeWrongPassword:
            self.appDelegate.alertViewTwo(errorMessage: "You have entered an incorrect password.", viewController: callingViewController)
        case .errorCodeEmailAlreadyInUse:
            self.appDelegate.alertViewTwo(errorMessage: "That email is already in use.", viewController: callingViewController)
        case .errorCodeWeakPassword:
            self.appDelegate.alertViewTwo(errorMessage: "Weak Password: Passwords must contain at least six characters.", viewController: callingViewController)
        default:
            print(errCode)
            
        }
    }

//MARK: Methods related to User details:
    func getUserDetails() {
        let uid = FIRAuth.auth()?.currentUser?.uid
        FIRDatabase.database().reference().child("users").child(uid!).child("userInfo").observeSingleEvent(of: .value, with: { (snapshot) in
            
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
    
    func writeToDisk(email: String, firstName: String, phoneNumber: String, uid: String) {
        let directories = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as NSArray
        let documentsDirectory = directories[0] as! String
        let path = documentsDirectory.appending("/userInfo.plist")
        self.setUrl(path: path)
        
        let dictionary = ["email" : email, "name" : firstName, "phoneNumber" : phoneNumber, "uid" : uid] as NSDictionary
        dictionary.write(toFile: path, atomically: true)
        print(dictionary)
    }
    
    func readFromDisk() -> NSMutableDictionary {
        let userInfo = NSMutableDictionary(contentsOfFile: getUrl())
        return userInfo!
    }
    
//MARK: Uploading to Database and Storage:
    func uploadInfoToFirebaseDatabase(status: String, photo: UIImage, pet: inout Pet, completion: @escaping () -> ()) {
        let ref = FIRDatabase.database().reference()
        var petRef: FIRDatabaseReference = FIRDatabaseReference()
        var petStatus: String = ""
        
        switch status {
        case "lost":
            petRef = ref.child("pets").child("lost").childByAutoId()
            petStatus = "lost"
        case "found":
            petRef = ref.child("pets").child("found").childByAutoId()
            petStatus = "found"
        case "available to adopt":
            petRef = ref.child("pets").child("adopt").childByAutoId()
            petStatus = "adopt"
        default:
            break
        }
        
        let petString = "\(petRef)"
        let petID = petString.components(separatedBy: "https://petsearch-8b839.firebaseio.com/pets/\(petStatus)/")
        let petIdWithStatus: String = petID[1]
        pet.petID = petIdWithStatus
       
        let geoFire = GeoFire(firebaseRef: ref.child("pets_location"))
        geoFire?.setLocation(CLLocation(latitude: pet.latitude, longitude: pet.longitude), forKey: pet.petID)
        
        let userDict = readFromDisk()
        let uid = userDict["uid"] as! String
        pet.userID = "\(uid)"
        
        petRef.setValue(pet.toAnyObject())
        uploadInfoToFirebaseUsersBranch(petID: pet.petID, userID: pet.userID, pet: pet)
        uploadImageToFirebaseStorage(photo: photo, pet: pet, completion: completion)
    }
    
    func uploadInfoToFirebaseUsersBranch(petID: String, userID: String, pet: Pet) {
        let ref = FIRDatabase.database().reference().child("users").child(userID).child("pets").child(petID)
        ref.setValue(pet.toAnyObject())
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
    
//MARK: Downloading Pet from Firebase:
    
    //This returns pets for a specific user when "Manage My Pets" is tapped from the Options menu:
    func fetchPetsForUser(segue: @escaping () -> ()) {
        self.setPets(pets: [])
        let userID = FIRAuth.auth()?.currentUser?.uid
        print("User ID: \(userID)")
        let ref = FIRDatabase.database().reference().child("users").child(userID!).child("pets")
        
        ref.observeSingleEvent(of: .value, with: { (snapshot) in
            var userPets: [Pet] = []
            
            for pet in snapshot.children {
                
                let userPet = Pet(snapshot: pet as! FIRDataSnapshot)
                userPets.append(userPet)
                print("User Pet: \(userPet)")
                
                self.setPets(pets: userPets)
                print("User Pets: \(userPets)")
            }
            segue()
        })
    }
    
    //This returns pets if the user has not enabled location services:
    func fetchPets(viewControllerName: String, completion: @escaping () -> Void) {
        self.setPets(pets: [])
        let ref = FIRDatabase.database().reference().child("pets").queryOrdered(byChild: "status")
        
        switch viewControllerName {
        case "adopt":
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
        case "found":
            ref.queryEqual(toValue: "found").observe(.value, with: { (snapshot) in
                var foundPets: [Pet] = []
                
                for pet in snapshot.children {
                    let foundPet = Pet(snapshot: pet as! FIRDataSnapshot)
                    foundPets.append(foundPet)
                    
                    self.setPets(pets: foundPets)
                }
                completion()
                self.setPets(pets: [])
            })
        case "lost":
            ref.queryEqual(toValue: "lost").observe(.value, with: { (snapshot) in
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
    
    //This returns pets based on user's location:
    func addListener(viewController: String, refreshView: @escaping() -> ()) {
        let userLocation = getUserLocation()
        let geoFireRef = FIRDatabase.database().reference().child("pets_location")
        let geoFire = GeoFire(firebaseRef: geoFireRef)
        let center = CLLocation(latitude: (userLocation?.coordinate.latitude)!, longitude: (userLocation?.coordinate.longitude)!)
        let circleQuery = geoFire!.query(at: center, withRadius: 100)
        let handle = circleQuery?.observe(.keyEntered, with: { (key, location) in
            if let key = key {
                self.fetchLocatedPets(viewControllerName: viewController, petID: key, refreshView: refreshView)
            }
        })
        
        listeners.append(handle!)
        
        let when = DispatchTime.now() + 1
        DispatchQueue.main.asyncAfter(deadline: when) {
            for handle in self.listeners {
                circleQuery?.removeObserver(withFirebaseHandle: handle)
            }
            self.listeners = []
        }
    }
    
    //This returns pets that have been located with GeoFire location data:
    func fetchLocatedPets(viewControllerName: String, petID: String, refreshView: @escaping () -> ()) {
        if !self.petDict.keys.contains(petID) {
            
            let ref = FIRDatabase.database().reference().child("pets").child(viewControllerName).queryOrdered(byChild: "petID")
            ref.queryEqual(toValue: petID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if (snapshot.exists()) {
                    for pet in snapshot.children {
                        let locatedPet = Pet(snapshot: pet as! FIRDataSnapshot)
                        
                        switch locatedPet.status{
                        case "found":
                            self.foundPets.append(locatedPet)
                        case "lost":
                            self.lostPets.append(locatedPet)
                        case "available to adopt":
                            self.adoptPets.append(locatedPet)
                        default:
                            print("Default case hit.")
                        }
                        
                        self.petDict[locatedPet.petID] = locatedPet
                        self.downloadImage(petID: locatedPet.petID, refreshView: refreshView)
                    }
                } else {
                    print("Snapshot does not exist.")
                }
            })
        }
    }

    //Downloads image from Firebase storage:
    func downloadImage(petID: String, refreshView: @escaping () -> ()) {
        if (!self.imageDict.keys.contains(petID)) {
            let storRef = FIRStorage.storage().reference(withPath: "\(petID).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                self.imageDict["\(petID)"] = UIImage.init(data: data!, scale: 50)
                
                refreshView()
            }
        } else {
            refreshView()
        }
    }
    
    func insertPetIntoDict(pet: Pet, image: UIImage) {
        self.imageDict[pet.petID] = image
        self.petDict[pet.petID] = pet
        
        switch pet.status{
        case "found":
            self.foundPets.append(pet)
        case "lost":
            self.lostPets.append(pet)
        case "available to adopt":
            self.adoptPets.append(pet)
        default:
            print("Default case hit.")
        }
        
    }
    
//MARK: Deleting pets from the database:
    func deletePets(status: String, petID: String) {

        //Delete pet and image from dictionaries which populate tableView:
        imageDict.removeValue(forKey: petID)
        if( petDict.removeValue(forKey: petID) == nil) {
            print("Unable to remove \(petID) from the dict!")
        }
        
        //Delete pet data from database:
        deletePetFromDatabase(status: status, petID: petID)
        
        //Delete the photo from storage:
        deleteImageFromStorage(petID: petID)

        //Delete pet's location data:
        deletePetLocationData(petID: petID)

        //Delete pet from user branch of database:
        deletePetFromUserChild(petID: petID)
    }
    
    func deletePetFromDatabase(status: String, petID: String) {
        let ref = FIRDatabase.database().reference().child("pets").child(status).child(petID)
        
        ref.removeValue { (error, ref) in
            if error != nil {
                print("There was an error deleting the pet from the database. Error: \(error)")
            } else {
                print("Pet data was successfully deleted from the database.")
            }
        }
    }
    
    func deletePetFromUserChild(petID: String) {
        let userID = FIRAuth.auth()?.currentUser?.uid
        let ref = FIRDatabase.database().reference().child("users").child(userID!).child("pets").child(petID)
        
        ref.removeValue { (error, ref) in
            
            if error != nil {
                print("There was an error deleting the pet from the database. Error: \(error)")
            }
        }
    }
    
    func deletePetLocationData(petID: String) {
        let locationDataRef = FIRDatabase.database().reference().child("pets_location").child(petID)
        
        locationDataRef.removeValue{ (error, ref) in
            if error != nil {
                print("There was an error deleting the pet's location data. Error: \(error)")
            } else {
                print("Pet location data was successfully deleted.")
            }
        }

    }

    func deleteImageFromStorage(petID: String) {
        let storageRef = FIRStorage.storage().reference(withPath: "\(petID).jpg")
        storageRef.delete { error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("Image was successfully deleted from Storage.")
            }
        }
    }

//MARK: Class properties and other methods:
    private var petArray: [Pet]
    private var userInfoPath: String
    private var userLocation: CLLocation?
    private var locatedPetIDs: Set<String>
    lazy var lostPets = [Pet]()
    lazy var foundPets = [Pet]()
    lazy var adoptPets = [Pet]()
    var listeners = [UInt]()
    var petDict = [String: Pet]()
    var imageDict = [String: UIImage]()
    var manageButtonPressed: Bool = false
    var signedOut: Bool = false
    var signInButtonTapped: Bool = false
    
    override init() {
        petArray = [Pet]()
        userInfoPath = String()
        userLocation = CLLocation()
        locatedPetIDs = Set<String>()
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
        return self.userInfoPath
    }
    
    func setUserLocation(location: CLLocation) {
        self.userLocation = location
    }
    
    func getUserLocation() -> CLLocation? {
        return self.userLocation
    }
    
    func getPetsForLocation() -> Set<String> {
        return self.locatedPetIDs
    }
    
    func getPetsForStatus(status: String) -> [Pet] {
        petArray = Array(petDict.values)
        var pets = [Pet]()
        pets = Array(petDict.values.filter({($0.status.range(of: status) != nil)}))
        pets.sort {
            $0.timeStamp.compare($1.timeStamp) == ComparisonResult.orderedDescending
        }
        return pets
    }
    
    func getImages() -> [String: UIImage] {
        return self.imageDict
    }
    
    func emptyLocatedPetIDArray() {
        self.locatedPetIDs.removeAll()
    }
}
