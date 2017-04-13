//
//  InputTableView.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/13/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class InputTableView: UITableViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    @IBOutlet var speciesLabel: UILabel!
    @IBOutlet var speciesDropDown: UIPickerView!
    @IBOutlet var nameTextField: UITextField!
    
    let species = ["Cat", "Dog", "Bird", "Reptile", "Other"]
        
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        nameTextField.placeholder = "Name"
        
    }
    
    @IBAction func cancelToPetViewController(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func savePet(segue: UIStoryboardSegue){
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
   
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return species.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return species[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.speciesLabel.text = self.species[row]
        self.speciesDropDown.isHidden = true
    }
    
    
    
    
}
