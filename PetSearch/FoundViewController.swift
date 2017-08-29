
//  FoundViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class FoundViewController: UITableViewController, CLLocationManagerDelegate {
    
    var foundPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    private let imageCache = NSCache<NSString, UIImage>()
    let locationManager = CLLocationManager()
    var warningHasBeenShown: Bool = false
    var didFindLocation: Bool = false
    
    @IBOutlet var activityView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.bringSubview(toFront: activityView)
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
               
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        
        print("Found Pets Array contains: \(foundPets.count)")
        
        didFindLocation = false
        configureLocationServices()
        locationManager.startUpdatingLocation()
     
    }
    
    func configureLocationServices() {
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1000.0
        
        let authorizationStatus = CLLocationManager.authorizationStatus()
        
        switch authorizationStatus {
        case .notDetermined:
            self.locationManager.requestWhenInUseAuthorization()
            break
        case .denied:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        default: break
        }
       
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("Location Services: Authorized Always")
        case .authorizedWhenInUse:
            print("Location Services: Authorized When In Use")
        case .denied:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Found", completion: tableView.reloadData)
        default:
            break
        }
    }
    
    func showWarningOnce() {
        if self.warningHasBeenShown == false {
            self.presentWarningToUser(title: "Location Services Restricted", message: "In order to see pets in your area, please open this app's settings and enable location access.")
            self.warningHasBeenShown = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: Notify the user of an error?
        print("Error: \(error)")
    }
        
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return foundPets.count
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFindLocation != true {
            let location = locations[0]
            Service.sharedSingleton.setUserLocation(location: location)
            //MARK: This function is being called multiple times which causes the downloadImage func to be called multiple times, which reloads the tableView multiple times. TableView is seriously unresponsive.
            Service.sharedSingleton.fetchPetsForLocation(viewController: "found", completion: downloadImage)
            didFindLocation = true
        } else {
            print("Location has already been found.")
        }
    }
    
    var imageDict = [String: Data]()
    
    func downloadImage() {
        var count = 0
        self.foundPets = Service.sharedSingleton.getFoundPets()
        
        print("Number of found pets: \(self.foundPets.count).")
        print("Count: \(count)")
        
        for pet in self.foundPets {
            let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                self.imageDict["\(pet.petID)"] = data!
                print("Dictionary contains: \(self.imageDict.count) pairs.")
                print("Dictionary pairs: \(self.imageDict)")
                count = count + 1
                if count == self.foundPets.count {
                    self.reloadTable()
                }
            }
        }
    }
    
    func reloadTable() {
        self.foundPets = Service.sharedSingleton.getFoundPets()
        
        self.foundPets.sort {
            $0.timeStamp.compare($1.timeStamp) == ComparisonResult.orderedDescending
        }
        
        self.tableView.reloadData()
    }
    
    //TODO: Download pet images in a separate function and add them to the Pet struct as a UIImage. Then, populate the cells with array of the pet structs.
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        print("\n\n\n The foundPets array contains: \(foundPets.count) number of Pets.")
        let pet = foundPets[indexPath.row]
        let placeholderImage = UIImage(named: "Placeholder")
        cell.petImageView?.image = placeholderImage!
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        cell.tag = indexPath.row
        
        let petImage = UIImage.init(data: imageDict["\(pet.petID)"]!, scale: 50)
        cell.petImageView.image = petImage
        
////        if let cachedImage = imageCache.object(forKey: pet.petID as NSString) {
////            cell.petImageView?.image = cachedImage
////            cell.setNeedsLayout()
////        } else {
//            //Returning the cell before completing the storage download:
//            let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
//            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
//                
//                guard error == nil else {
//                    print("Error downloading: \(error)")
//                    return
//                }
//                
//                let petImage = UIImage.init(data: data!, scale: 50)
//            
////                self.imageCache.setObject(petImage!, forKey: pet.petID as NSString)
//                //if cell == tableView.cellForRow(at: indexPath) {
//                    DispatchQueue.main.async {
//                        //if cell.tag == indexPath.row {
//                            cell.petImageView.image = petImage
//                            cell.setNeedsLayout()
//                            //TODO: This activity indicator does not appear in the view
//                            self.activityIndicator.stopAnimating()
//                        //}
//                    }
                //}
//            }
//        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = foundPets[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! PetCell
        petPic = cell.petImageView.image
        
        performSegue(withIdentifier: "SegueToProfileView", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToProfileView" {
            let destinationNavController = segue.destination as! UINavigationController
            let petProfileVC = destinationNavController.topViewController as! PetProfileView
            petProfileVC.petProfile = petDetails
            petProfileVC.petImage = petPic!
        }
    }
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        if hasConnectivity() == false {
            self.presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please connect to a network to add a pet.")
        } else {
            Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Manage My Pets", style: .default, handler: { (action) in
                if Service.sharedSingleton.IsUserLoggedInReturnBool() {
                    Service.sharedSingleton.fetchPetsForUser(segue: self.segueToManageScreen)
                    //self.performSegue(withIdentifier: "Segue To Manage", sender: nil)
                } else {
                    self.segueToLoginScreen()
                }
                print("Manage my pets clicked.")
            }))
            alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
                Service.sharedSingleton.handleLogout()
                self.presentWarningToUser(title: "Success!", message: "You have logged out.")
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Found VC.")
    }
}
