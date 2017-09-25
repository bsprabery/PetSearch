//
//  UIViewControllerExtension.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 9/14/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation


extension UIView {
    //This function adds the dog photo to the background on the launch screen:
    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "Torrey_Wiley_Cookie_Med")
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill
        
        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
    
    func detectResolution() -> (CGFloat, CGFloat) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let screenScale = UIScreen.main.scale
        let resolution = ((screenWidth * screenScale), (screenHeight * screenScale))
        return resolution
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
    
    func segueToManageScreen() {
        func segue() {
            self.performSegue(withIdentifier: "Segue To Manage", sender: nil)
        }
        
        Service.sharedSingleton.fetchPetsForUser(segue: segue)
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
