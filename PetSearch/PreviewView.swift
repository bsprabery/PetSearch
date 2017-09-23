//
//  PreviewView.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 7/27/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

extension PreviewViewController {
    
    func detectResolution() -> (CGFloat, CGFloat) {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let screenScale = UIScreen.main.scale
        let resolution = ((screenWidth * screenScale), (screenHeight * screenScale))
        return resolution
    }

    func layoutView() {
        petImage.layer.cornerRadius = 5.0
        petImage.clipsToBounds = true
        
        let resolution = detectResolution()
        
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.petImage.translatesAutoresizingMaskIntoConstraints =  false
        self.petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.sexLabel.translatesAutoresizingMaskIntoConstraints = false
        self.breedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.descriptionView.translatesAutoresizingMaskIntoConstraints = false
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints  = false
        self.sexLabel.translatesAutoresizingMaskIntoConstraints = false
        
        switch resolution {
        case (640, 1136):
            print("iPhone SE, iPhone 5, iPhone 5s")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 15)
            sexLabel.font = UIFont.systemFont(ofSize: 13)
            breedLabel.font = UIFont.systemFont(ofSize: 13)
            userNameLabel.font = UIFont.systemFont(ofSize: 13)
            descriptionView.font = UIFont.systemFont(ofSize: 12)
            
            let activityIndicatorX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let activityIndicatorY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 73)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 92)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImage, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 6)
            let imageHeight = NSLayoutConstraint(item: petImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let imageWidth = NSLayoutConstraint(item: petImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let imageX = NSLayoutConstraint(item: petImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: sexLabel, attribute: .top, relatedBy: .equal, toItem: petImage, attribute: .bottom, multiplier: 1, constant: 6)
            let animalTypeX = NSLayoutConstraint(item: sexLabel, attribute: .leading, relatedBy: .equal, toItem: petImage, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: sexLabel, attribute: .bottom, multiplier: 1, constant: 4)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: sexLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 4)
            let petOwnerNameLeading = NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 6)
            let petDetailLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: userNameLabel, attribute: .leading, multiplier: 1, constant: -15)
            let petDetailWidth = NSLayoutConstraint(item: descriptionView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            let petDetailHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 85)
            
            NSLayoutConstraint.activate([activityIndicatorX, activityIndicatorY, nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailWidth, petDetailHeight])
            
        case (750, 1334):
            print("iPhone 6, iPhone 6s, and iPhone 7")
            
            
            petNameLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            sexLabel.font = UIFont.systemFont(ofSize: 14)
            breedLabel.font = UIFont.systemFont(ofSize: 14)
            userNameLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionView.font = UIFont.systemFont(ofSize: 13)
            
            let activityIndicatorX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let activityIndicatorY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 105)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImage, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 15)
            let imageHeight = NSLayoutConstraint(item: petImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 275)
            let imageWidth = NSLayoutConstraint(item: petImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 275)
            let imageX = NSLayoutConstraint(item: petImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: sexLabel, attribute: .top, relatedBy: .equal, toItem: petImage, attribute: .bottom, multiplier: 1, constant: 12)
            let animalTypeX = NSLayoutConstraint(item: sexLabel, attribute: .leading, relatedBy: .equal, toItem: petImage, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: sexLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: sexLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 25)
            let petDetailTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -25)
            let petDetailHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
            
            NSLayoutConstraint.activate([activityIndicatorX, activityIndicatorY, nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight])
            
        case (1242, 2208):
            print("iPhone 7 Plus, iPhone 6s Plus")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            sexLabel.font = UIFont.systemFont(ofSize: 14)
            breedLabel.font = UIFont.systemFont(ofSize: 14)
            userNameLabel.font = UIFont.systemFont(ofSize: 14)
            descriptionView.font = UIFont.systemFont(ofSize: 13)
            
            let activityIndicatorX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let activityIndicatorY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
                
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 105)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImage, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 15)
            let imageHeight = NSLayoutConstraint(item: petImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let imageWidth = NSLayoutConstraint(item: petImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let imageX = NSLayoutConstraint(item: petImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: sexLabel, attribute: .top, relatedBy: .equal, toItem: petImage, attribute: .bottom, multiplier: 1, constant: 12)
            let animalTypeX = NSLayoutConstraint(item: sexLabel, attribute: .leading, relatedBy: .equal, toItem: petImage, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: sexLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: sexLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 25)
            let petDetailTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -25)
            let petDetailHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            NSLayoutConstraint.activate([activityIndicatorX, activityIndicatorY, nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight])
            
            
        case (1536, 2048):
            print("iPad Mini, iPad Air, iPad Retina, iPad Pro 9.7")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 22)
            statusLabel.font = UIFont.systemFont(ofSize: 18)
            sexLabel.font = UIFont.systemFont(ofSize: 18)
            breedLabel.font = UIFont.systemFont(ofSize: 18)
            userNameLabel.font = UIFont.systemFont(ofSize: 18)
            descriptionView.font = UIFont.systemFont(ofSize: 17)
            
            let activityIndicatorX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let activityIndicatorY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 90)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 125)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImage, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 20)
            let imageHeight = NSLayoutConstraint(item: petImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375)
            let imageWidth = NSLayoutConstraint(item: petImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375)
            let imageX = NSLayoutConstraint(item: petImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: sexLabel, attribute: .top, relatedBy: .equal, toItem: petImage, attribute: .bottom, multiplier: 1, constant: 25)
            let animalTypeX = NSLayoutConstraint(item: sexLabel, attribute: .leading, relatedBy: .equal, toItem: petImage, attribute: .leading, multiplier: 1, constant: -30)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: sexLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: sexLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 50)
            let petDetailTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -50)
            let petDetailHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            NSLayoutConstraint.activate([activityIndicatorX, activityIndicatorY, nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight])
            
            
        case (2048, 2732):
            print("iPad Pro 12.9")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 32)
            statusLabel.font = UIFont.systemFont(ofSize: 26)
            sexLabel.font = UIFont.systemFont(ofSize: 26)
            breedLabel.font = UIFont.systemFont(ofSize: 26)
            userNameLabel.font = UIFont.systemFont(ofSize: 26)
            descriptionView.font = UIFont.systemFont(ofSize: 25)
            
            let activityIndicatorX = NSLayoutConstraint(item: activityIndicator, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
            let activityIndicatorY = NSLayoutConstraint(item: activityIndicator, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 155)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImage, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 30)
            let imageHeight = NSLayoutConstraint(item: petImage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
            let imageWidth = NSLayoutConstraint(item: petImage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
            let imageX = NSLayoutConstraint(item: petImage, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: sexLabel, attribute: .top, relatedBy: .equal, toItem: petImage, attribute: .bottom, multiplier: 1, constant: 25)
            let animalTypeX = NSLayoutConstraint(item: sexLabel, attribute: .leading, relatedBy: .equal, toItem: petImage, attribute: .leading, multiplier: 1, constant: -30)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: sexLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: sexLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: userNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let petOwnerNameLeading = NSLayoutConstraint(item: userNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: descriptionView, attribute: .top, relatedBy: .equal, toItem: userNameLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let petDetailLeading = NSLayoutConstraint(item: descriptionView, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 100)
            let petDetailTrailing = NSLayoutConstraint(item: descriptionView, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -100)
            let petDetailHeight = NSLayoutConstraint(item: descriptionView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            NSLayoutConstraint.activate([activityIndicatorX, activityIndicatorY, nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight])
                    
        default:
            print("Unknown Device")
        }
    
    }
    
}
