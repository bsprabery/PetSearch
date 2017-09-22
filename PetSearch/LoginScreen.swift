//
//  LoginScreen.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/15/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class LoginScreen: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var firstNameTextField: UITextField!
    @IBOutlet var lastNameTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    @IBOutlet var confirmPasswordTextField: UITextField!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var loginButtonStackView: UIButton!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var phoneNumberTextField: UITextField!
    @IBOutlet var cancelButton: UIButton!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet var stackContainer: UIView!
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var stackContainerHeight: NSLayoutConstraint!
    @IBOutlet var stackContainerBottom: NSLayoutConstraint!
    @IBOutlet var cancelButtonTop: NSLayoutConstraint!
    @IBOutlet var loginButtonTop: NSLayoutConstraint!
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var registerButtonTapped = false
    
    override func loadView() {
        super.loadView()
        if launchedBefore {
            print("Not first launch")
        } else {
            print("First time launch, setting NSUserDefaults.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStackContainerToView()
        layoutView()
        addObservers()
        setTextFieldDelegates()
        
        loginButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func handleLoginRegister() {
        if hasConnectivity() == false {
            self.presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please try again later.")
        } else {
            if registerButtonTapped == true {
                Service.sharedSingleton.handleRegister(callingViewController: self, email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, phoneNumber: phoneNumberTextField.text, completion: segueToInputView)
            } else {
                //MARK: Handles segues to appropriate destinations (based on the path taken to reach this view):
                if Service.sharedSingleton.manageButtonPressed {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: segueToManageScreen)
                } else if Service.sharedSingleton.signInButtonTapped {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: unwindToOriginalView)
                } else {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: segueToInputView)
                }
            }
        }
    }
    
    func unwindToOriginalView() {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
        Service.sharedSingleton.signInButtonTapped = false
    }
    
    func setTextFieldDelegates() {
        phoneNumberTextField.delegate = self
        lastNameTextField.delegate = self
        firstNameTextField.delegate = self
        confirmPasswordTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        
    }

//MARK: Keyboard Notifications - adjusts view when keyboard obscures parts of the view:
    func keyboardWillShow(notification: NSNotification) {
        if phoneNumberTextField.isFirstResponder || lastNameTextField.isFirstResponder || firstNameTextField.isFirstResponder || confirmPasswordTextField.isFirstResponder || passwordTextField.isFirstResponder == true || emailTextField.isFirstResponder == true {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        } else {}
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if phoneNumberTextField.isFirstResponder || lastNameTextField.isFirstResponder || firstNameTextField.isFirstResponder || confirmPasswordTextField.isFirstResponder || passwordTextField.isFirstResponder == true || emailTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        } else {}
    }
    
    func getKeyboardHeight(notification: NSNotification)  -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen.keyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(LoginScreen.keyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
    
//MARK: Action methods:
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        registerButtonTapped = false
        loginButtonStackView.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        dismissKeyboard()
        repeatUserLayout()
    }
    
    @IBAction func registerButtonClicked(_ sender: AnyObject) {
        registerButtonTapped = true
        registerButton.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        dismissKeyboard()
        newUserLayout()
    }
    
    @IBAction func cancelButtonClicked(_ sender: AnyObject) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Cancel Login", message: "Are you sure you want to cancel?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (action) in
                self.performSegue(withIdentifier: "unwindSegue", sender: self)
            }))
            
            alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
                
            }))
        
            self.present(alert, animated: true, completion: nil)
        }
    }
}
