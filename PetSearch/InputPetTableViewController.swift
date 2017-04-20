//
//  InputPetTableViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/14/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit
import MapKit


class InputPetTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate, CLLocationManagerDelegate, UITextViewDelegate {
    
    @IBOutlet var petNameField: UITextField!
    @IBOutlet var petPicker: UIPickerView!
    @IBOutlet var detailLabelSex: UILabel!
    @IBOutlet var speciesPicker: UIPickerView!
    @IBOutlet var detailLabelSpeices: UILabel!
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var detailLabelDate: UILabel!

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var textFields: [UITextField]!

    let mapLocationManager = CLLocationManager()
    var petPickerHidden = true
    var speciesPickerHidden = true
    var datePickerHidden = true
    var mapViewHidden = true
    var genderValues = ["Select", "Male", "Female"]
    var speciesValues = ["Select", "Bird", "Cat", "Dog", "Reptile", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()
        hidePickers()
        datePickerChanged()
        
        mapLocationManager.delegate = self
        
        self.subscribeToKeyboardNotifications()
        
        hideKeyboard()
        
        hideDatePicker()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
    
    func hideKeyboard() {
        let tapToHideKeyboard: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapToHideKeyboard)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }
    
    func hidePickers() {
        petPicker.isHidden = true
        speciesPicker.isHidden = true
        mapView.isHidden = true
    }
    
    //MARK: Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch (true, indexPath.section, indexPath.row) {
        case (petPickerHidden, 0, 2), (speciesPickerHidden, 0, 4), (datePickerHidden, 3, 1), (mapViewHidden, 3, 3) :
            return 0
        default:
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if petPickerHidden && indexPath.section == 0 && indexPath.row == 2{
//            return 0
//        } else if speciesPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
//            return 0
//        } else if datePickerHidden && indexPath.section == 2 && indexPath.row ==  1 {
//            return 0
//        } else if mapViewHidden && indexPath.section == 2 && indexPath.row == 3 {
//            return 0
//        } else {
//            return super.tableView(tableView, heightForRowAt: indexPath)
//        }
//    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch (indexPath.section, indexPath.row) {
        case (0, 1):
            tableView.deselectRow(at: indexPath, animated: true)
            togglePetPickerOn()
        case (0, 3):
            tableView.deselectRow(at: indexPath, animated: true)
            toggleSpeciesPickerOn()
        case (3, 0):
            tableView.deselectRow(at: indexPath, animated: true)
            toggleDatePickerOn()
        case (3, 2):
            tableView.deselectRow(at: indexPath, animated: true)
            toggleMapViewOn()
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
        
//        let annotation = MKPointAnnotation()
//        annotation.coordinate = myLocation
//        mapView.addAnnotation(annotation)
        
        self.mapView.showsUserLocation = true
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    //MARK: Picker View
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 0 {
            return genderValues.count
        } else {
            return speciesValues.count
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 0 {
            return genderValues[row]
        } else {
            return speciesValues[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //switch statement would be good here
        if pickerView.tag == 0 {
            detailLabelSex.text = genderValues[row]
            petPicker.isHidden = true
            togglePetPickerOff()
        } else if pickerView.tag == 1 {
            detailLabelSpeices.text = speciesValues[row]
            speciesPicker.isHidden = true
            toggleSpeciesPickerOff()
        } else if datePicker.tag == 2 {
            datePicker.isHidden = true
            toggleDatePickerOff()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func datePickerChanged() {
        self.datePicker.maximumDate = Date()
        detailLabelDate.text = DateFormatter.localizedString(from: datePicker.date, dateStyle: DateFormatter.Style.short, timeStyle: DateFormatter.Style.none)
        
    }
    

    
    func togglePetPickerOn() {
        petPicker.isHidden = false
        petPickerHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func togglePetPickerOff() {
        petPicker.isHidden = true
        petPickerHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleSpeciesPickerOn() {
        speciesPickerHidden = false
        speciesPicker.isHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func toggleSpeciesPickerOff() {
        speciesPicker.isHidden = true
        speciesPickerHidden = true
        tableView.beginUpdates()
        tableView.endUpdates()
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
    
    func toggleMapViewOn() {
        self.mapView.isHidden = false
        self.mapViewHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    @IBAction func showMap(_ sender: AnyObject) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapLocationManager.startUpdatingLocation()
        } else {
            mapLocationManager.requestWhenInUseAuthorization()
        }
        
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest

        mapView.isHidden = false
        mapViewHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    @IBAction func datePickerValueChanged(_ sender: AnyObject) {
        datePickerChanged()
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        return true
    }
    
    //MARK: Keyboard
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
        
    func keyboardWillShow(notification: NSNotification) {
        if phoneTextField.isFirstResponder == true {
            self.view.frame.origin.y = -getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func keyboardWillHide(notification: NSNotification) {
//        for textField in self.textFields {
//            if textField.isFirstResponder == true {
        if phoneTextField.isFirstResponder == true {
                view.frame.origin.y = 0
            }
      //  }
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
}

