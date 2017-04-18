//
//  InputPetTableViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/14/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit

class InputPetTableViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
    @IBOutlet var petNameField: UITextField!
    @IBOutlet var petPicker: UIPickerView!
    @IBOutlet var detailLabelSex: UILabel!
    @IBOutlet var speciesPicker: UIPickerView!
    @IBOutlet var detailLabelSpeices: UILabel!
    
    var petPickerHidden = true
    var speciesPickerHidden = true
    var genderValues = ["Select", "Male", "Female"]
    var speciesValues = ["Select", "Bird", "Cat", "Dog", "Reptile", "Other"]

    override func viewDidLoad() {
        super.viewDidLoad()

        petPicker.isHidden = true
        speciesPicker.isHidden = true
       

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    //MARK: Table View
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if !petPickerHidden && indexPath.section == 0 && indexPath.row == 2 {
            return 85
        } else if petPickerHidden && indexPath.section == 0 && indexPath.row == 2{
            return 0
        } else if !speciesPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 115
        } else if speciesPickerHidden && indexPath.section == 0 && indexPath.row == 4 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 && indexPath.row == 1 {
            togglePetPickerOn()
        } else if indexPath.section == 0 && indexPath.row == 3 {
            toggleSpeciesPickerOn()
        }
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
        if pickerView.tag == 0 {
            detailLabelSex.text = genderValues[row]
            petPicker.isHidden = true
            togglePetPickerOff()
        } else {
            detailLabelSpeices.text = speciesValues[row]
            speciesPicker.isHidden = true
            toggleSpeciesPickerOff()
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    
    
}
