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

let notificationKey = "refreshAfterDeletion"

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
        self.tabBarController?.tabBarItem.title = "Title"
        self.navigationController?.view.addSubview(activityView)
        setInitialActivityIndicatorAttributes()
        
        didFindLocation = false
        configureLocationServices()
        locationManager.startUpdatingLocation()
        
        tableView.register(UINib(nibName: "PetCell", bundle: nil), forCellReuseIdentifier: "PetCell")
        self.refreshControl?.addTarget(self, action: #selector(self.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(PSBaseViewController.reloadTable),
                                               name: Notification.Name(rawValue: notificationKey),
                                               object: nil)
        
        Service.sharedSingleton.addAuthListener()
    }
    
    func setInitialActivityIndicatorAttributes() {
        activityView.backgroundColor = UIColor.white.withAlphaComponent(0.01)
        activityView.center = (self.navigationController?.view.center)!
        activityIndicator.isHidden = false
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.hidesWhenStopped = true
        activityView.isHidden = true
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
            didFindLocation = true
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
        print("Error: \(error)")
    }
    
    func showWarningOnce() {
        if self.warningHasBeenShown == false {
            self.presentWarningToUser(title: "Location Services Restricted", message: "In order to see pets in your area, please open this app's settings and enable location access.")
            self.warningHasBeenShown = true
        }
    }
    
    func setNoPetsLabel() {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: self.tableView.bounds.size.height))
        noDataLabel.text = "There are no pets currently listed in your area."
        noDataLabel.textColor = UIColor(red: 22.0/255.0, green: 106.0/255.0, blue: 176.0/255.0, alpha: 1.0)
        noDataLabel.textAlignment = NSTextAlignment.center
        noDataLabel.numberOfLines = 2
        self.tableView.backgroundView = noDataLabel
    }
    
//MARK: Methods related to TableView:
    func reloadTable() {
        self.petsArray = Service.sharedSingleton.getPetsForStatus(status: self.getStatusForViewController())
        self.tableView.reloadData()
        
        if self.petsArray.isEmpty {
            setNoPetsLabel()
        }
        
        hideActivityIndicator()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var numberOfSections: Int = 0
        
        if self.petsArray.count > 0 {
            self.tableView.backgroundView = nil
            numberOfSections = self.petsArray.count
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
        
        return cell
    }
    
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
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            alert.addAction(UIAlertAction(title: "Manage My Pets", style: .default, handler: { (action) in
                if Service.sharedSingleton.IsUserLoggedInReturnBool() {
                    self.segueToManageScreen()
                } else {
                    Service.sharedSingleton.manageButtonPressed = true
                    Service.sharedSingleton.signInButtonTapped = false
                    self.segueToLoginScreen()
                }
            }))
            if Service.sharedSingleton.signedOut {
                alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (action) in
                    Service.sharedSingleton.manageButtonPressed = false
                    Service.sharedSingleton.signInButtonTapped = true
                    self.segueToLoginScreen()
                }))
            } else {
                alert.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (action) in
                    Service.sharedSingleton.handleLogout()
                    self.presentWarningToUser(title: "Success!", message: "You have logged out.")
                }))
            }
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                self.dismiss(animated: true, completion: nil)
            }))
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //The unwindSegues' receiver:
    @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        print("Performing unwind segue to initial view controller.")
    }
}
