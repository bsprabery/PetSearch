//
//  AdoptViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/12/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

class AdoptViewController: PSBaseViewController {
    
    override func getStatusForViewController() -> String {
        return "adopt"
    }
}

extension UIViewController {
    func segueToLoginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Login Screen")
        present(destination, animated: true, completion: nil)
    }
    
    func segueToInputView() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let destination = storyboard.instantiateViewController(withIdentifier: "Nav Controller Two")
        self.present(destination, animated: true, completion: nil)
    }
    
    func unwindSegue() {
        self.performSegue(withIdentifier: "unwindSegue", sender: self)
        
        //Reset signInButtonTapped to false:
        Service.sharedSingleton.signInButtonTapped = false
    }
    
    func segueToManageScreen() {
        self.performSegue(withIdentifier: "Segue To Manage", sender: nil)
        
        //Reset manageButtonPressed to false:
        Service.sharedSingleton.manageButtonPressed = false
    }
    
    func hasConnectivity() -> Bool {
        let reachability: Reachability = Reachability.forInternetConnection()
        let networkStatus: Int = reachability.currentReachabilityStatus().rawValue
        print(networkStatus)
        if networkStatus != 0 {
            return true
        } else {
            return false
        }
    }
    
    func presentWarningToUser(title: String?, message: String) {
        
        var topController = UIApplication.shared.keyWindow!.rootViewController
        while ((topController?.presentedViewController) != nil) {
            topController = topController?.presentedViewController
        }
        
        if let title = title {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alertController.addAction(okayAction)
            topController?.present(alertController, animated: true)
        } else {
            let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
            
            let okayAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alertController.addAction(okayAction)
            topController?.present(alertController, animated: true)
        }
    }
    
}
