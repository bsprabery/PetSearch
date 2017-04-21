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
    @IBOutlet var phoneTextField: UITextField!
    @IBOutlet var textView: UITextView!
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var detailLabelDate: UILabel!

    @IBOutlet var datePicker: UIDatePicker!
    
    @IBOutlet var textFields: [UITextField]!

    var mapPins = [MKPointAnnotation]()
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
        hideDatePicker()
        
        
        mapLocationManager.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
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
    
    @IBAction func showMap(_ sender: AnyObject) {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapLocationManager.startUpdatingLocation()
        } else {
            self.addDropPinTouch()
            mapLocationManager.requestWhenInUseAuthorization()
        }
        
        mapLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        mapView.isHidden = false
        mapViewHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKPointAnnotation {
            let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "myPin")
            pinAnnotationView.isDraggable = true
            pinAnnotationView.animatesDrop = true
            return pinAnnotationView
        }
        return nil
    }
    
    func addAnnotation(gestureRecognizer: UIGestureRecognizer) {
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: mapView)
            let newCoordinate = mapView.convert(touchPoint, toCoordinateFrom: self.mapView)
            let annotation = MKPointAnnotation()
            
        //Later will need to add the coordinates to a managed Object or to firebase to be persisted
            annotation.coordinate = newCoordinate
            annotation.title = "Pet Location"
//            let latitude = annotation.coordinate.latitude
//            let longitude = annotation.coordinate.longitude
            
            mapPins.append(annotation)
            
            if mapPins.count <= 1 {
                self.mapView.addAnnotation(annotation)
            } else {
                print("There is already a pin on the map.")
            }
        }
    }
    
    //Use this function to update coordinates of user's location if pin is dragged.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationViewDragState, fromOldState oldState: MKAnnotationViewDragState) {

        switch (newState) {
        case .ending:
            view.dragState = .none
        default:
            print("break")
        }
    }
    
    func addDropPinTouch() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation(gestureRecognizer:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
    }
    
    func toggleMapViewOn() {
        self.mapView.isHidden = false
        self.mapViewHidden = false
        tableView.beginUpdates()
        tableView.endUpdates()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error: \(error)")
    }
    
    //MARK: Picker and DatePicker Views
    
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
            petPickerHidden = true
            togglePickerOff(picker: petPicker)
        } else if pickerView.tag == 1 {
            detailLabelSpeices.text = speciesValues[row]
            speciesPickerHidden = true
            togglePickerOff(picker: speciesPicker)
        } else if datePicker.tag == 2 {
            datePicker.isHidden = true
            toggleDatePickerOff()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func hidePickers() {
        petPicker.isHidden = true
        speciesPicker.isHidden = true
        mapView.isHidden = true
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
    
    
    //TODO: Change the size of the text in the labels if screen size is not big enough to dispay full label. OR - make Label longer/change label text for smaller screen sizes.
    
}

