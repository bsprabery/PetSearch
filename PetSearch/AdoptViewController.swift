//
//  AdoptViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseDatabaseUI


class AdoptViewController: UITableViewController, CLLocationManagerDelegate {
    
    var adoptPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    let imageCacheAdopt = NSCache<NSString, UIImage>()
    let locationManager = CLLocationManager()
    var warningHasBeenShown: Bool = false
 
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        
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
            Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        default: break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        Service.sharedSingleton.setUserLocation(location: location)
   //     Service.sharedSingleton.fetchPetsForLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            print("Location Services: Authorized Always")
        case .authorizedWhenInUse:
            print("Location Services: Authorized When In Use")
        case .denied:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
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
        let adoptPetsArray = Service.sharedSingleton.getPets()
        self.adoptPets = adoptPetsArray.reversed()
        return adoptPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = adoptPets[indexPath.row]
        
        let placeholderImage = UIImage(named: "Placeholder")
        cell.petImageView?.image = placeholderImage!
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        
        
        if let cachedImage = imageCacheAdopt.object(forKey: pet.petID as NSString) {
            cell.petImageView?.image = cachedImage
            cell.setNeedsLayout()
        } else {
            let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                let petImage = UIImage.init(data: data!, scale: 50)
                self.imageCacheAdopt.setObject(petImage!, forKey: pet.petID as NSString)
                if cell == tableView.cellForRow(at: indexPath) {
                    DispatchQueue.main.async {
                        cell.petImageView.image = petImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = adoptPets[indexPath.row]
        
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
    
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to Adopt VC.")
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
}

extension UIViewController {
    func segueToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Login Screen")
        present(destination, animated: true, completion: nil)
    }
    
    func segueToInputView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Nav Controller Two")
        self.present(destination, animated: true, completion: nil)
    }
    
    func segueToManageScreen() {
        self.performSegue(withIdentifier: "Segue To Manage", sender: nil)
        
    }
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        print(networkStatus)
        if networkStatus != 0 {
            return true
        } else {
            return false
        }
    }
    
    func presentWarningToUser(title: String?, message: String) {
        
        var topController = UIApplication.shared.keyWindow!.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        if let title = title {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alertController.addAction(okayAction)
            topController?.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alertController.addAction(okayAction)
            topController?.present(alertController, animated: true)
        }
    }
    
}
