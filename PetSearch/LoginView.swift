//
//  LoginView.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 6/29/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

extension LoginScreen {
    
    func newUserLayout() {
        loginButtonStackView.backgroundColor = UIColor.lightGray
        registerButton.backgroundColor = UIColor(red: 0/255, green: 128/255, blue: 255/255, alpha: 1.0)
        firstNameTextField.isHidden = false
        lastNameTextField.isHidden = false
        confirmPasswordTextField.isHidden = false
        phoneNumberTextField.isHidden = false
        forgotPasswordButton.isHidden = true
        
        loginButton.setTitle("Register", for: .normal)
        registerButtonTapped = true
        
        let resolution = self.view.detectResolution()
        
        switch resolution {
        case (640, 1136):
            print("iPhone 5, iPhone 5s, iPhone SE")
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 218.0
                self.stackContainerBottom.constant = 78.0
                self.loginButtonTop.constant = 23
                self.cancelButtonTop.constant = 23
            }
        case (750, 1334):
            print("iPhone 6, iPhone 6s, and iPhone 7")
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 250.0
                self.stackContainerBottom.constant = 100.0
                self.loginButtonTop.constant = 28
                self.cancelButtonTop.constant = 28
            }
            
        case (1242, 2208):
            print("iPhone 7 Plus, iPhone 6s Plus")
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 260.0
                self.stackContainerBottom.constant = 110.0
                self.loginButtonTop.constant = 28
                self.cancelButtonTop.constant = 28
            }
        
        case (1125, 2436):
            print("iPhone X")
            
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 260.0
                self.stackContainerBottom.constant = 90.0
                self.loginButtonTop.constant = 28
                self.cancelButtonTop.constant = 28
            }
            
        case (1536, 2048):
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 300.0
                self.stackContainerBottom.constant = 155.0
                self.loginButtonTop.constant = 30
                self.cancelButtonTop.constant = 30
            }
            
        case (2048, 2732):
            print("iPad Pro 12.9")
            UIView.animate(withDuration: 0.15) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 410.0
                self.stackContainerBottom.constant = 200.0
            }
        default:
            print("Unknown device.")
            
        }
    }
    
    func repeatUserLayout() {
        registerButton.backgroundColor = UIColor.lightGray
        firstNameTextField.isHidden = true
        lastNameTextField.isHidden = true
        confirmPasswordTextField.isHidden = true
        phoneNumberTextField.isHidden = true
        forgotPasswordButton.isHidden = false
        
        loginButton.setTitle("Login", for: .normal)
        registerButtonTapped = false
        
        let resolution = self.view.detectResolution()
        
        switch resolution {
        case (640, 1136):
            print("iPhone 5, iPhone SE, iPhone 5s")
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 90.0
                self.stackContainerBottom.constant = 105.0
                self.cancelButtonTop.constant = 31
                self.loginButtonTop.constant = 31
            
                self.forgotPasswordTop.constant = 1
                self.forgotPasswordLeading.constant = 180
            }
            
        case (750, 1334):
            print("iPhone 6, iPhone 6s, and iPhone 7")
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 100.0
                self.stackContainerBottom.constant = 105.0
                self.cancelButtonTop.constant = 31
                self.loginButtonTop.constant = 31
                
                self.forgotPasswordTop.constant = 1
                self.forgotPasswordLeading.constant = 230
            }
            
        case (1242, 2208):
            print("iPhone 7 Plus, iPhone 6s Plus")
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 100.0
                self.stackContainerBottom.constant = 125.0
                self.cancelButtonTop.constant = 31
                self.loginButtonTop.constant = 31
                
                self.forgotPasswordTop.constant = 1
                self.forgotPasswordLeading.constant = 260
            }
            
        case (1125, 2436):
            print("iPhone X")
            
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 100.0
                self.stackContainerBottom.constant = 120.0
                self.cancelButtonTop.constant = 37
                self.loginButtonTop.constant = 37
                
                self.forgotPasswordTop.constant = 1
                self.forgotPasswordLeading.constant = 219
            }
            
        case (1536, 2048):
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 120.0
                self.stackContainerBottom.constant = 300.0
                self.cancelButtonTop.constant = 53
                self.loginButtonTop.constant = 53
                
                self.forgotPasswordTop.constant = 2
                self.forgotPasswordLeading.constant = 545
            }
        case (2048, 2732):
            print("iPad Pro 12.9")
            UIView.animate(withDuration: 0.5) {
                self.view.layoutIfNeeded()
                self.stackContainerHeight.constant = 140.0
                self.stackContainerBottom.constant = 400.0
            }
        default:
            print("Unknown device.")
        }
    }
    
    func addStackContainerToView() {
        self.stackContainer.frame = self.stackView.bounds
        self.view.bringSubview(toFront: stackContainer)
        stackContainer.addSubview(stackView)
        stackContainer.bringSubview(toFront: stackView)
    }
    
    
    func layoutBackgroundImage() {
        
        let image = UIImage(named: "Torrey_Wiley_Cookie")
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.image = image
        self.view.addSubview(imageView)
        self.view.sendSubview(toBack: imageView)
        
    }
    
    func layoutView() {
        let resolution = self.view.detectResolution()
        layoutBackgroundImage()

	//Activity Indicator Constraints
        activityIndicator.center = self.view.center
        activityIndicator.layer.zPosition = 1
        
        //Stack Container Constraints
        stackContainer.layer.cornerRadius = 7
        stackContainer.layer.borderWidth = 1.3
        stackContainer.layer.masksToBounds = true
        
        self.stackView.translatesAutoresizingMaskIntoConstraints = false
        self.cancelButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.stackContainer.translatesAutoresizingMaskIntoConstraints = false
        self.forgotPasswordButton.translatesAutoresizingMaskIntoConstraints = false
        
        switch resolution {
        case (640, 1136):
            print("iPhone SE, iPhone 5, and iPhone 5s")
            
            if launchedBefore {
                repeatUserLayout()
            } else {
                newUserLayout()
            }
            
            //Font Sizes:
            loginButtonStackView.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            emailTextField.font = UIFont.systemFont(ofSize: 14)
            passwordTextField.font = UIFont.systemFont(ofSize: 14)
            confirmPasswordTextField.font = UIFont.systemFont(ofSize: 14)
            firstNameTextField.font = UIFont.systemFont(ofSize: 14)
            lastNameTextField.font = UIFont.systemFont(ofSize: 14)
            phoneNumberTextField.font = UIFont.systemFont(ofSize: 14)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            titleLabel.font = UIFont.systemFont(ofSize: 33)
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 17)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 288)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 144)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 144)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 1.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 58)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 85)
            let cancelButtonHeight = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 45)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 85)
            let loginButtonHeight = NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 100)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 55)
            
            //Forgot Password Button Constraints
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 11), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            
            //Activate Constraints
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonLeading, cancelButtonWidth, cancelButtonHeight, loginButtonLeading, loginButtonWidth, loginButtonHeight, titleLabelLeading, titleLabelTop])
            
        case (750, 1334):
            print("iPhone 6, iPhone 6s, iPhone 7, and iPhone 8")
            
            if launchedBefore {
                repeatUserLayout()
            } else {
                newUserLayout()
            }
            
            //Font Sizes:
            loginButtonStackView.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            emailTextField.font = UIFont.systemFont(ofSize: 15)
            passwordTextField.font = UIFont.systemFont(ofSize: 15)
            confirmPasswordTextField.font = UIFont.systemFont(ofSize: 15)
            firstNameTextField.font = UIFont.systemFont(ofSize: 15)
            lastNameTextField.font = UIFont.systemFont(ofSize: 15)
            phoneNumberTextField.font = UIFont.systemFont(ofSize: 15)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
            titleLabel.font = UIFont.systemFont(ofSize: 40)
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 17)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 340)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 170)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 170)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 1.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 65)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 95)
            let cancelButtonHeight = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 55)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 95)
            let loginButtonHeight = NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 120)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 75)
            
            //Forgot Password Button Constraints
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 11), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            
            //Activate Constraints
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonLeading, cancelButtonWidth, cancelButtonHeight, loginButtonLeading, loginButtonWidth, loginButtonHeight, titleLabelLeading, titleLabelTop])
            
        case (1242, 2208):
            print("iPhone 8 Plus, iPhone 7 Plus, iPhone 6 Plus")
            
            //Font Sizes:
            loginButtonStackView.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            emailTextField.font = UIFont.systemFont(ofSize: 16)
            passwordTextField.font = UIFont.systemFont(ofSize: 16)
            confirmPasswordTextField.font = UIFont.systemFont(ofSize: 16)
            firstNameTextField.font = UIFont.systemFont(ofSize: 16)
            lastNameTextField.font = UIFont.systemFont(ofSize: 16)
            phoneNumberTextField.font = UIFont.systemFont(ofSize: 16)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            titleLabel.font = UIFont.systemFont(ofSize: 43)
            
            if launchedBefore {
                repeatUserLayout()
            } else {
                newUserLayout()
            }
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 17)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 380)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 190)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 190)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 1.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 80)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 65)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 120)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 75)
            
            //Forgot Password Button Constraints
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 12), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            
            //Activate Constraints
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonLeading, cancelButtonWidth, loginButtonLeading, loginButtonWidth, titleLabelLeading, titleLabelTop])
            
        case (1125, 2436):
            print("iPhone X")
            
            //Font Sizes:
            loginButtonStackView.titleLabel?.font = UIFont.systemFont(ofSize: 21)
            registerButton.titleLabel?.font = UIFont.systemFont(ofSize: 21)
            emailTextField.font = UIFont.systemFont(ofSize: 18)
            passwordTextField.font = UIFont.systemFont(ofSize: 18)
            confirmPasswordTextField.font = UIFont.systemFont(ofSize: 18)
            firstNameTextField.font = UIFont.systemFont(ofSize: 18)
            lastNameTextField.font = UIFont.systemFont(ofSize: 18)
            phoneNumberTextField.font = UIFont.systemFont(ofSize: 18)
            cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            loginButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
            titleLabel.font = UIFont.systemFont(ofSize: 49)
            
            if launchedBefore {
                repeatUserLayout()
            } else {
                newUserLayout()
            }
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 17)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 338)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 169)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 169)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 1.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 56)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 65)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 118)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant:94)
            
            //Forgot Password Button Constraints
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 14), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            
            //Activate Constraints
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonLeading, cancelButtonWidth, loginButtonLeading, loginButtonWidth, titleLabelLeading, titleLabelTop])

            
        case (1536, 2048):
            print("iPad Mini, iPad Air, iPad Retina, and iPad Pro 9.7")
            
            if launchedBefore {
                repeatUserLayout()
            } else {
                newUserLayout()
            }
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 230)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 490)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 245)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 245)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 1.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 270)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 55)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Forgot Password Button Constraints
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 18), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 295)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 88)
            
            //Activate Constraints
            //TODO: Remove cancelButtonTop and loginButtonTop from this array:
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonTop, cancelButtonLeading, cancelButtonWidth, loginButtonTop, loginButtonLeading, loginButtonWidth, titleLabelLeading, titleLabelTop])
            
        case (2048, 2732):
            print("iPad Pro 12.9")
            
            if launchedBefore {
                repeatUserLayout()
                cancelButtonTop.constant = 53
                loginButtonTop.constant = 53
                
            } else {
                newUserLayout()
                loginButtonTop.constant = 40
                cancelButtonTop.constant = 40
            }
            
            emailTextField.layer.borderWidth = 0.0
            passwordTextField.layer.borderWidth = 0.0
            confirmPasswordTextField.layer.borderWidth = 0.0
            firstNameTextField.layer.borderWidth = 1.0
            lastNameTextField.layer.borderWidth = 1.0
            phoneNumberTextField.layer.borderWidth = 1.0
            
            let attributes: [NSAttributedStringKey: Any] = [NSAttributedStringKey(rawValue: NSAttributedStringKey.font.rawValue): UIFont.systemFont(ofSize: 20), NSAttributedStringKey(rawValue: NSAttributedStringKey.underlineStyle.rawValue): NSUnderlineStyle.styleSingle.rawValue]
            let attributedString = NSMutableAttributedString(string: "Forgot Password?", attributes: attributes)
            forgotPasswordButton.setAttributedTitle(attributedString, for: .normal)
            forgotPasswordTop.constant = 2
            forgotPasswordLeading.constant = 735
            
            let stackContainerLeading = NSLayoutConstraint(item: stackContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 280)
            let stackContainerWidth = NSLayoutConstraint(item: stackContainer, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 640)
            
            //Stack View Constraints
            let stackViewLoginButtonWidth = NSLayoutConstraint(item: loginButtonStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
            let stackViewRegisterButtonWidth = NSLayoutConstraint(item: registerButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
            let stackViewLeading = NSLayoutConstraint(item: stackView, attribute: .leading, relatedBy: .equal, toItem: stackContainer, attribute: .leading, multiplier: 1, constant: 0)
            let stackViewTrailing = NSLayoutConstraint(item: stackView, attribute: .trailing, relatedBy: .equal, toItem: stackContainer, attribute: .trailing, multiplier: 1, constant: 0)
            let stackViewTop = NSLayoutConstraint(item: stackView, attribute: .top, relatedBy: .equal, toItem: stackContainer, attribute: .top, multiplier: 1, constant: 0)
            let stackViewBottom = NSLayoutConstraint(item: stackView, attribute: .bottom, relatedBy: .equal, toItem: stackContainer, attribute: .bottom, multiplier: 1, constant: 0)
            
            stackView.distribution = .fillEqually
            loginButtonStackView.layer.borderWidth = 1.0
            registerButton.layer.borderWidth = 1.0
            
            //Cancel Button Constraints
            let cancelButtonLeading = NSLayoutConstraint(item: cancelButton, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 340)
            let cancelButtonWidth = NSLayoutConstraint(item: cancelButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let cancelButtonHeight = NSLayoutConstraint(item: cancelButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)
            
            cancelButton.layer.cornerRadius = 7
            cancelButton.layer.borderWidth = 1.3
            
            //Login Button Constraints
            let loginButtonLeading = NSLayoutConstraint(item: loginButton, attribute: .leading, relatedBy: .equal, toItem: cancelButton, attribute: .trailing, multiplier: 1, constant: 80)
            let loginButtonWidth = NSLayoutConstraint(item: loginButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let loginButtonHeight = NSLayoutConstraint(item: loginButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)
            
            loginButton.layer.cornerRadius = 7
            loginButton.layer.borderWidth = 1.3
            
            //Title Label Constraints
            let titleLabelLeading = NSLayoutConstraint(item: titleLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 435)
            let titleLabelTop = NSLayoutConstraint(item: titleLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 130)
            
            //Activate Constraints
            NSLayoutConstraint.activate([stackViewLeading, stackContainerWidth, stackViewLoginButtonWidth, stackViewRegisterButtonWidth, stackViewTrailing, stackContainerLeading, stackViewTop, stackViewBottom, cancelButtonLeading, cancelButtonWidth, cancelButtonHeight, loginButtonLeading, loginButtonWidth, loginButtonHeight, titleLabelLeading, titleLabelTop])
            
        default:
            print("Unknown Device.")
        }
    }
}
