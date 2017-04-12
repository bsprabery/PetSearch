//
//  ViewController.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 4/11/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
