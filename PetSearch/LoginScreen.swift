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

enum Button : Int {
    case manageButton = 0
    case signInButton = 1
    case registerButton = 2
    case addButton = 3
}

enum AuthStatus : Int {
    case signedIn = 0
    case signedOut = 1
}

var status: AuthStatus = AuthStatus(rawValue: 1)!
var button: Button = Button(rawValue: 2)!

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
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var forgotPasswordButton: UIButton!
    @IBOutlet var forgotPasswordTop: NSLayoutConstraint!
    @IBOutlet var forgotPasswordLeading: NSLayoutConstraint!
    
    let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
    var registerButtonTapped = false
    
    
    override func loadView() {
        super.loadView()
        if launchedBefore {
            print("Not first launch")
        } else {
            button = .registerButton
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addStackContainerToView()
        layoutView()
        addObservers()
        setTextFieldDelegates()
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true
        
        loginButton.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(LoginScreen.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    func showActivityIndicator() {
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
    }
    
    func hideActivityIndicator() {
        activityIndicator.stopAnimating()
    }
        
    @objc func handleLoginRegister() {
        showActivityIndicator()
        if !hasConnectivity() {
            presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please try again later.")
            hideActivityIndicator()
        } else {
            if button == .registerButton {
                Service.sharedSingleton.handleRegister(callingViewController: self, email: emailTextField.text, password: passwordTextField.text, confirmPassword: confirmPasswordTextField.text, firstName: firstNameTextField.text, lastName: lastNameTextField.text, phoneNumber: phoneNumberTextField.text, completion: segueToInputView)
            } else {
                //Handles segues to appropriate destinations (based on the path taken to reach this view):
                if button == .manageButton {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: segueToManageScreen)
                } else if button == .signInButton {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: unwindToOriginalView)
                } else if button == .addButton {
                    Service.sharedSingleton.handleLogin(email: emailTextField.text, password: passwordTextField.text, callingViewController: self, completion: segueToInputView)
                }
            }
        }
    }
    
    func unwindToOriginalView() {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
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
    @objc func keyboardWillShow(notification: NSNotification) {
        if phoneNumberTextField.isFirstResponder || lastNameTextField.isFirstResponder || firstNameTextField.isFirstResponder || confirmPasswordTextField.isFirstResponder || passwordTextField.isFirstResponder == true || emailTextField.isFirstResponder == true {
            view.frame.origin.y = -getKeyboardHeight(notification: notification)
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if phoneNumberTextField.isFirstResponder || lastNameTextField.isFirstResponder || firstNameTextField.isFirstResponder || confirmPasswordTextField.isFirstResponder || passwordTextField.isFirstResponder == true || emailTextField.isFirstResponder == true {
            view.frame.origin.y = 0
        }
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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
//MARK: Action methods:
    @IBAction func loginButtonClicked(_ sender: AnyObject) {
        button = .signInButton
        registerButtonTapped = false
        loginButtonStackView.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        dismissKeyboard()
        repeatUserLayout()
    }
    
    @IBAction func registerButtonClicked(_ sender: AnyObject) {
        button = .registerButton
        registerButtonTapped = true
        registerButton.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        dismissKeyboard()
        newUserLayout()
    }
    
    @IBAction func forgotPassword(_ sender: AnyObject) {
        if !self.hasConnectivity() {
            self.presentWarningToUser(title: "Warning", message: "You are not connected to the internet. Please connect to a network to reset your password.")
        } else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(UIAlertAction(title: "Reset Password", style: .default, handler: { (action) in
                    if let email = self.emailTextField.text {
                        if email == "" {
                            self.presentWarningToUser(title: "Email Address Required", message: "Please enter the email address associated with your PetSearch account.")
                        } else {
                            Service.sharedSingleton.sendPasswordReset(email: email, callingViewController: self)
                        }
                    } else {
                        self.presentWarningToUser(title: "Email Address Required", message: "Please enter the email address associated with your PetSearch account.")
                    }
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
                    self.dismiss(animated: true, completion: nil)
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
        }
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
