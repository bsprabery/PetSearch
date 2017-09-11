//
//  PSBaseViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 9/6/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseStorageUI

class PSBaseViewController: UITableViewController, CLLocationManagerDelegate {
    
    var petsArray: [Pet] = []
    var petDetails: Pet?
    var petPic: UIImage?
    let locationManager = CLLocationManager()
    var warningHasBeenShown: Bool = false
    var didFindLocation: Bool = false
    var imageDict = [String: UIImage]()
       
    @IBOutlet var activityView: UIView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
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
        
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        NotificationCenter.default.addObserver(self, selector: #selector(PSBaseViewController.reloadTable), name: Notification.Name("refreshAfterDeletion"), object: nil)
        
    }
    
    func handleRefresh( _ refreshControl: UIRefreshControl) {
        Service.sharedSingleton.addListener(viewController: self.getStatusForViewController(), refreshView: reloadTable)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            refreshControl.endRefreshing()
        }
        
    }
    
    func getStatusForViewController() -> String {
        return "found"
    }
    
    //MARK: Location Manager Methods:
    
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
            Service.sharedSingleton.fetchPets(viewControllerName: self.getStatusForViewController(), completion: tableView.reloadData)
        default: break
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if didFindLocation != true {
            let location = locations[0]
            Service.sharedSingleton.setUserLocation(location: location)
            Service.sharedSingleton.addListener(viewController: self.getStatusForViewController(), refreshView: reloadTable)
           // Service.sharedSingleton.fetchPetsForLocation(viewController: self.getStatusForViewController(), refreshView: reloadTable)
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
            Service.sharedSingleton.fetchPets(viewControllerName: self.getStatusForViewController(), completion: tableView.reloadData)
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .restricted:
            showWarningOnce()
            Service.sharedSingleton.fetchPets(viewControllerName: self.getStatusForViewController(), completion: tableView.reloadData)
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
    
    //MARK: Methods related to TableView:
    
    func reloadTable() {
        self.petsArray = Service.sharedSingleton.getPetsForStatus(status: self.getStatusForViewController())
        self.tableView.reloadData()
    }
    
    
    //MARK: TableView Datasource Methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections: Int = 0
        
        if self.petsArray.count > 0 {
            self.tableView.backgroundView = nil
            numberOfSections = self.petsArray.count
        } else {
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
            activityView.isHidden = true
            let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
            noDataLabel.text = "There are no pets currently listed in your area."
            noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
            noDataLabel.textAlignment = NSTextAlignment.center
            self.tableView.backgroundView = noDataLabel
            
        }
        
        return numberOfSections
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCell", for: indexPath) as! PetCell
        let pet = petsArray[indexPath.row]
        
        cell.nameLabel.text = pet.name
        cell.detailsLabel.text = pet.petDetails
        cell.petImageView.layer.cornerRadius = 5.0
        
        self.imageDict = Service.sharedSingleton.getImages()
        if let image = imageDict["\(pet.petID)"] {
            cell.petImageView?.image = image
        } else {
            let placeholderImage = UIImage(named: "Placeholder")
            cell.petImageView?.image = placeholderImage!
        }
        
        self.activityIndicator.stopAnimating()
        self.activityView.isHidden = true
                
        return cell
    }
    
    //MARK: TableView Delegate Methods:
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let indexPath = tableView.indexPathForSelectedRow!
        petDetails = petsArray[indexPath.row]
        
        let cell = tableView.cellForRow(at: indexPath) as! PetCell
        petPic = cell.petImageView.image
        
        performSegue(withIdentifier: "SegueToProfileView", sender: self)
    }
    
    //MARK: Segue Methods:
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SegueToProfileView" {
            let destinationNavController = segue.destination as! UINavigationController
            let petProfileVC = destinationNavController.topViewController as! PetProfileView
            petProfileVC.petProfile = petDetails
            petProfileVC.petImage = petPic!
        }
    }
    
    //MARK: Methods related to UI Buttons:
    
    @IBAction func addButtonTapped(_ sender: AnyObject) {
        if hasConnectivity() == false {
            self.presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please connect to a network to add a pet.")
        } else {
            Service.sharedSingleton.checkIfUserIsLoggedIn(segueOne: segueToLoginScreen, segueTwo: segueToInputView)
        }
    }
    
    @IBAction func optionsButtonTapped(_ sender: AnyObject) {
        
        //TODO: After signing out, there is no option to sign back into the app. The options menu still reads "Sign Out"
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
