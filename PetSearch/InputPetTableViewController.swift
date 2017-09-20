//
//  InputPetTableViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/14/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit
import MapKit


class InputPetTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate, MKMapViewDelegate {
    
    @IBOutlet var petNameField: UITextField!
    @IBOutlet var petPicker: UIPickerView!
    @IBOutlet var detailLabelSex: UILabel!
    @IBOutlet var speciesPicker: UIPickerView!
    @IBOutlet var detailLabelSpeices: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var detailLabelDate: UILabel!
    @IBOutlet var statusLabel: UILabel!
    @IBOutlet var breedTextField: UITextField!
    @IBOutlet var sexLabel: UILabel!
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var statusPicker: UIPickerView!
    @IBOutlet var datePicker: UIDatePicker!
    
    var mapPins = [MKPointAnnotation]()
    let mapLocationManager = CLLocationManager()
    var petPickerHidden = true
    var speciesPickerHidden = true
    var datePickerHidden = true
    var statusPickerHidden = true
    var genderValues = ["", "Male", "Female"]
    var speciesValues = ["", "Cat", "Dog", "Other"]
    var statusValues = ["", "Lost", "Found", "Available to Adopt"]
    private var latitude: Double!
    private var longitude: Double!
    
    //Ticks is used as a timeStamp for sorting the pets so they are displayed in most-recently-added order:
    var ticks: NSNumber {
        let value = Int64((Date().timeIntervalSince1970 + 62_135_596_800) * 10_000_000)
        let ticks = NSNumber(value: value)
        return ticks
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hidePickers()
        datePickerChanged()
        hideDatePicker()
        
        mapLocationManager.delegate = self
        
        mapLocationManager.distanceFilter = 300.0
        mapAuthorization()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        mapPins.removeAll()
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd, yyyy"
        
        let date = "\(datePicker.date)"
        dateFormatter.date(from: "\(date)")
        return dateFormatterPrint.string(from: datePicker.date)
    }
    
    //This function passes the information from this view controller to the next view controller (PreviewVC):
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PreviewViewController" {
            let destinationVC = segue.destination as! PreviewViewController
            
            if self.petNameField.text?.isEmpty ?? true || self.speciesLabel.text == "Select" || self.statusLabel.text == "Select" || self.sexLabel.text == "Select" {
                    let alertController = UIAlertController(title: "Missing Information!", message: "Please check to make sure all required fields are answered. Required fields include: Pet Name, Sex, Type, Status", preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "Okay", style: .default) { (action) in
                        print("Okay.")
                    }
                    
                    alertController.addAction(okayAction)
                    self.present(alertController, animated: true)
            } else {
                
                var breedText: String
                
                if breedTextField.text == "" {
                    breedText = "Unknown Breed"
                } else {
                    breedText = breedTextField.text!
                }
                
                let userInfoDict = Service.sharedSingleton.readFromDisk()
                let userName = userInfoDict["name"] as! String!
                let userEmail = userInfoDict["email"] as! String!
                let phoneNumber = userInfoDict["phoneNumber"] as! String!
                let uid = userInfoDict["uid"] as! String!

                destinationVC.pet = Pet(name: petNameField.text!,
                                        species: speciesLabel.text!,
                                        sex: sexLabel.text!,
                                        breed: breedText,
                                        petDetails: detailsTextView.text!,
                                        date: "\(formatDate())",
                                        status: statusLabel.text!.lowercased(),
                                        user: userName!,
                                        email: userEmail!,
                                        phoneNumber: phoneNumber!,
                                        latitude: latitude,
                                        longitude: longitude,
                                        petID: "",
                                        userID: uid!,
                                        timeStamp: ticks
                )
            }
        }
    }
    
//    //Is this segue ever used?
//    @IBAction func unwindToInputSegue(_ segue: UIStoryboardSegue) {
//        print("Performing unwind segue to Lost VC.")
//    }
    
//MARK: Table View
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (true, indexPath.section, indexPath.row) {
        case (petPickerHidden, 0, 2), (speciesPickerHidden, 0, 4), (datePickerHidden, 2, 1), (statusPickerHidden, 2, 3) :
            return 0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            tableView.deselectRow(at: indexPath, animated: true)
            petPickerHidden = false
            toggleOn(picker: petPicker)
        case (0, 3):
            tableView.deselectRow(at: indexPath, animated: true)
            speciesPickerHidden = false
            toggleOn(picker: speciesPicker)
        case (2, 0):
            tableView.deselectRow(at: indexPath, animated: true)
            toggleDatePickerOn()
        case (2, 2):
            tableView.deselectRow(at: indexPath, animated: true)
            statusPickerHidden = false
            toggleOn(picker: statusPicker)
        default:
            tableView.deselectRow(at: indexPath, animated: true)
            print("hit default case for didSelectRowAt")
        }
    }
    
//MARK: Map View
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first!
        
        let span = MKCoordinateSpanMake(0.75, 0.75)
        let myLocation = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let region = MKCoordinateRegionMake(myLocation, span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = myLocation
        
        if mapPins.count < 1 {
            self.mapView.addAnnotation(annotation)
            mapPins.append(annotation)
        } else {
            print("There is already a pin on the map.")
        }
    }
    
    func mapAuthorization() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapLocationManager.startUpdatingLocation()
        } else {
            self.addDropPinTouch()
            mapLocationManager.requestWhenInUseAuthorization()
        }
        
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.animatesDrop = true
            
            self.latitude = annotation.coordinate.latitude
            self.longitude = annotation.coordinate.longitude
            
            return pinAnnotationView
        }
        return nil
    }
    
    func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = newCoordinate
            annotation.title = "Pet Location"
            
            mapPins.append(annotation)
            
            if mapPins.count < 2 {
                self.mapView.addAnnotation(annotation)
            } else {
                print("There is already a pin on the map.")
            }
        }
    }
    
    //This function updates coordinates of user's location if pin is dragged.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {

        switch (newState) {
        case .ending:
            view.dragState = .none
        default:
            print("default")
        }
        
        self.latitude = view.annotation?.coordinate.latitude
        self.longitude = view.annotation?.coordinate.longitude
    }
    
    func addDropPinTouch() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    
//MARK: Picker and DatePicker Views
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag {
        case 0:
            return genderValues.count
        case 1:
            return speciesValues.count
        case 3:
            return statusValues.count
        default:
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag {
        case 0:
            return genderValues[row]
        case 1:
            return speciesValues[row]
        case 3:
            return statusValues[row]
        default:
            print("ERROR: Default - pickerView: TitleForRow")
            return "Select"
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            detailLabelSex.text = genderValues[row]
            petPickerHidden = true
            togglePickerOff(picker: petPicker)
        case 1:
            detailLabelSpeices.text = speciesValues[row]
            speciesPickerHidden = true
            togglePickerOff(picker: speciesPicker)
        case 2:
            toggleDatePickerOff()
        case 3:
            statusLabel.text = statusValues[row]
            statusPickerHidden = true
            togglePickerOff(picker: statusPicker)
        default:
            print("Default case for pickerView: didSelectRow.")
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func hidePickers() {
        petPicker.isHidden = true
        speciesPicker.isHidden = true
        statusPicker.isHidden = true
    }
    
    func toggleOn(picker: UIPickerView) {
        picker.isHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func togglePickerOff(picker: UIPickerView) {
        picker.isHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func datePickerChanged() {
        self.datePicker.maximumDate = Date()
        detailLabelDate.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        
    }
    
    func hideDatePicker() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(minimizeDatePicker(sender:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func minimizeDatePicker(sender: AnyObject) {
        let subview = view?.hitTest(sender.location(in: view), with: nil)
        if (!(subview?.isDescendant(of: datePicker) ?? false)) {
            toggleDatePickerOff()
        }
    }
    
    @IBAction func datePickerValueChanged(_ sender: AnyObject) {
        datePickerChanged()
    }
    
    func toggleDatePickerOn() {
        datePicker.isHidden = false
        datePickerHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleDatePickerOff() {
        datePicker.isHidden = true
        datePickerHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }

//MARK: Text Fields and Views    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let defaultString = "Additional details regarding the listing that may be necessary such as the pet's personality, distinctive physical markings, or the best time to contact you."
        if textView.text == defaultString {
            textView.text = ""
        } else {}
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let limitCount = 12
        let nsString = NSString(string: textField.text!)
        let newText = nsString.replacingCharacters(in: range, with: string)
        return  newText.characters.count <= limitCount
    }
}

