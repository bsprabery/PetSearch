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
    
    @IBOutlet var activityView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    
    var adoptPets: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    let locationManager = CLLocationManager()
    var warningHasBeenShown: Bool = false
    var didFindLocation: Bool = false
    var imageDict = [String: Data]()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.view.addSubview(activityView)
        activityView.center = (self.navigationController?.view.center)!
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        
        didFindLocation = false
        configureLocationServices()
        locationManager.startUpdatingLocation()
        
        self.refreshControl?.addTarget(self, action: #selector(FoundViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
    }
    
    func handleRefresh( _ refreshControl: UIRefreshControl) {
        Service.sharedSingleton.addListener(viewController: "found", refreshView: reloadTable)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            refreshControl.endRefreshing()
        }
    }
    
    func downloadImage() {
        var count = 0
        self.adoptPets = Service.sharedSingleton.getAdoptPets()
        
        for pet in self.adoptPets {
            let storRef = FIRStorage.storage().reference(withPath: "\(pet.petID).jpg")
            storRef.data(withMaxSize: INT64_MAX) { (data, error) in
                
                guard error == nil else {
                    print("Error downloading: \(error)")
                    return
                }
                
                self.imageDict["\(pet.petID)"] = data!
                
                count = count + 1
                if count == self.adoptPets.count {
                    Service.sharedSingleton.emptyLocatedPetIDArray()
                    self.reloadTable()
                }
            }
        }
    }
    
//MARK: Location Manager Methods
    
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
        if didFindLocation != true {
            let location = locations[0]
            Service.sharedSingleton.setUserLocation(location: location)
            Service.sharedSingleton.fetchPetsForLocation(viewController: "adopt", refreshView: downloadImage)
            didFindLocation = true
        } else {
            print("Location has already been found.")
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
            Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: "Adopt", completion: tableView.reloadData)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //TODO: Notify the user of an error?
        print("Error: \(error)")
    }
    
    func showWarningOnce() {
        if self.warningHasBeenShown == false {
            self.presentWarningToUser(title: "Location Services Restricted", message: "In order to see pets in your area, please open this app's settings and enable location access.")
            self.warningHasBeenShown = true
        }
    }
    
//MARK: TableView Related Methods
    
    func reloadTable() {
        self.adoptPets.sort {
            $0.timeStamp.compare($1.timeStamp) == ComparisonResult.orderedDescending
        }
        self.tableView.reloadData()
    }
    
//MARK: TableView Datasource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return adoptPets.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = adoptPets[indexPath.row]
        
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        
        if let image = imageDict["\(pet.petID)"] {
            cell.petImageView.image = UIImage.init(data: image, scale: 50)
        } else {
            let placeholderImage = UIImage(named: "Placeholder")
            cell.petImageView?.image = placeholderImage!
        }
        
        self.activityIndicator.stopAnimating()
        self.activityView.isHidden = true
        return cell
    }

    
//MARK: TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = adoptPets[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! PetCell
        petPic = cell.petImageView.image
        
        performSegue(withIdentifier: "SegueToProfileView", sender: self)
    }
    

//MARK: Segue Methods
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToProfileView" {
            let destinationNavController = segue.destination as! UINavigationController
            let petProfileVC = destinationNavController.topViewController as! PetProfileView
            petProfileVC.petProfile = petDetails
            petProfileVC.petImage = petPic!
            
        }
    }


//MARK: Methods related to UI Buttons
    
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
