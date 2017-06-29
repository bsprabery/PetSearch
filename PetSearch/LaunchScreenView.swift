//
//  LaunchScreenView.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/11/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI

class LaunchScreenView: UIViewController {
    
    fileprivate var _authHandle: FIRAuthStateDidChangeListenerHandle!
    var user: FIRUser?
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
    }


}

extension UIView {
    func addBackground() {
        let width = UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        
        let imageViewBackground = UIImageView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        imageViewBackground.image = UIImage(named: "Torrey_Wiley_Cookie_Med")
        
        imageViewBackground.contentMode = UIViewContentMode.scaleAspectFill

        self.addSubview(imageViewBackground)
        self.sendSubview(toBack: imageViewBackground)
    }
}


/*
func configureAuth() {
    _authHandle = FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
        //Should reload table data to ensure that it is up to date
        
        if let activeUser = user {
            if self.user != activeUser {
                self.user = activeUser
                self.signedInStatus(isSignedIn: true)
            }
        } else {
            //user must sign in
            self.signedInStatus(isSignedIn: false)
        }
    })
}

func signedInStatus(isSignedIn: Bool) {
    //If true, display table
    //If false, bring to login screen
}
 */
