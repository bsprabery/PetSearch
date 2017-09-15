//
//  ProfileView.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 7/19/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import UIKit

extension PetProfileView {
        
    func layoutView() {
        petImageView.layer.cornerRadius = 5.0
        petImageView.clipsToBounds = true
        contactButton.layer.cornerRadius = 5.0

        let resolution = self.view.detectResolution()
        
        self.statusLabel.translatesAutoresizingMaskIntoConstraints = false
        self.petImageView.translatesAutoresizingMaskIntoConstraints =  false
        self.petNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.animalTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        self.breedLabel.translatesAutoresizingMaskIntoConstraints = false
        self.petOwnerNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.petDetailsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.contactButton.translatesAutoresizingMaskIntoConstraints = false
        
        switch resolution {
        case (640, 1136):
            print("iPhone SE, iPhone 5, iPhone 5s")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 15)
            animalTypeLabel.font = UIFont.systemFont(ofSize: 13)
            breedLabel.font = UIFont.systemFont(ofSize: 13)
            petOwnerNameLabel.font = UIFont.systemFont(ofSize: 13)
            petDetailsLabel.font = UIFont.systemFont(ofSize: 12)
            contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 13)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 73)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 92)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImageView, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 6)
            let imageHeight = NSLayoutConstraint(item: petImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let imageWidth = NSLayoutConstraint(item: petImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 220)
            let imageX = NSLayoutConstraint(item: petImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: animalTypeLabel, attribute: .top, relatedBy: .equal, toItem: petImageView, attribute: .bottom, multiplier: 1, constant: 6)
            let animalTypeX = NSLayoutConstraint(item: animalTypeLabel, attribute: .leading, relatedBy: .equal, toItem: petImageView, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: animalTypeLabel, attribute: .bottom, multiplier: 1, constant: 4)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: animalTypeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 4)
            let petOwnerNameLeading = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: petDetailsLabel, attribute: .top, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .bottom, multiplier: 1, constant: 6)
            let petDetailLeading = NSLayoutConstraint(item: petDetailsLabel, attribute: .leading, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .leading, multiplier: 1, constant: -15)
            let petDetailWidth = NSLayoutConstraint(item: petDetailsLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            let petDetailHeight = NSLayoutConstraint(item: petDetailsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 85)
            
            let contactButtonTop = NSLayoutConstraint(item: contactButton, attribute: .top, relatedBy: .equal, toItem: petDetailsLabel, attribute: .bottom, multiplier: 1, constant: 15)
            let contactButtonLeading = NSLayoutConstraint(item: contactButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let contactButtonWidth = NSLayoutConstraint(item: contactButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            let contactButtonHeight = NSLayoutConstraint(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 22)
            
            NSLayoutConstraint.activate([nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailWidth, petDetailHeight, contactButtonTop, contactButtonLeading, contactButtonWidth, contactButtonHeight])
            
        case (750, 1334):
            print("iPhone 6, iPhone 6s, and iPhone 7")
            
            
            petNameLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            animalTypeLabel.font = UIFont.systemFont(ofSize: 14)
            breedLabel.font = UIFont.systemFont(ofSize: 14)
            petOwnerNameLabel.font = UIFont.systemFont(ofSize: 14)
            petDetailsLabel.font = UIFont.systemFont(ofSize: 13)
            contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 65)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 105)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImageView, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 15)
            let imageHeight = NSLayoutConstraint(item: petImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 275)
            let imageWidth = NSLayoutConstraint(item: petImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 275)
            let imageX = NSLayoutConstraint(item: petImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: animalTypeLabel, attribute: .top, relatedBy: .equal, toItem: petImageView, attribute: .bottom, multiplier: 1, constant: 12)
            let animalTypeX = NSLayoutConstraint(item: animalTypeLabel, attribute: .leading, relatedBy: .equal, toItem: petImageView, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: animalTypeLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: animalTypeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: petDetailsLabel, attribute: .top, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: petDetailsLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 25)
            let petDetailTrailing = NSLayoutConstraint(item: petDetailsLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -25)
            let petDetailHeight = NSLayoutConstraint(item: petDetailsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 90)
            
            let contactButtonTop = NSLayoutConstraint(item: contactButton, attribute: .top, relatedBy: .equal, toItem: petDetailsLabel, attribute: .bottom, multiplier: 1, constant: 10)
            let contactButtonLeading = NSLayoutConstraint(item: contactButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let contactButtonWidth = NSLayoutConstraint(item: contactButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            let contactButtonHeight = NSLayoutConstraint(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 28)
            
            NSLayoutConstraint.activate([nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight, contactButtonTop, contactButtonLeading, contactButtonWidth, contactButtonHeight])

                case (1242, 2208):
            print("iPhone 7 Plus, iPhone 6s Plus")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 16)
            statusLabel.font = UIFont.systemFont(ofSize: 14)
            animalTypeLabel.font = UIFont.systemFont(ofSize: 14)
            breedLabel.font = UIFont.systemFont(ofSize: 14)
            petOwnerNameLabel.font = UIFont.systemFont(ofSize: 14)
            petDetailsLabel.font = UIFont.systemFont(ofSize: 13)
            contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 15)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 80)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 105)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImageView, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 15)
            let imageHeight = NSLayoutConstraint(item: petImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let imageWidth = NSLayoutConstraint(item: petImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let imageX = NSLayoutConstraint(item: petImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: animalTypeLabel, attribute: .top, relatedBy: .equal, toItem: petImageView, attribute: .bottom, multiplier: 1, constant: 12)
            let animalTypeX = NSLayoutConstraint(item: animalTypeLabel, attribute: .leading, relatedBy: .equal, toItem: petImageView, attribute: .leading, multiplier: 1, constant: -5)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: animalTypeLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: animalTypeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: petDetailsLabel, attribute: .top, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: petDetailsLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 25)
            let petDetailTrailing = NSLayoutConstraint(item: petDetailsLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -25)
            let petDetailHeight = NSLayoutConstraint(item: petDetailsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 100)
            
            let contactButtonTop = NSLayoutConstraint(item: contactButton, attribute: .top, relatedBy: .equal, toItem: petDetailsLabel, attribute: .bottom, multiplier: 1, constant: 10)
            let contactButtonLeading = NSLayoutConstraint(item: contactButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let contactButtonWidth = NSLayoutConstraint(item: contactButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 175)
            let contactButtonHeight = NSLayoutConstraint(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 30)
            
            NSLayoutConstraint.activate([nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight, contactButtonTop, contactButtonLeading, contactButtonWidth, contactButtonHeight])
           
            
        case (1536, 2048):
            print("iPad Mini, iPad Air, iPad Retina, iPad Pro 9.7")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 22)
            statusLabel.font = UIFont.systemFont(ofSize: 18)
            animalTypeLabel.font = UIFont.systemFont(ofSize: 18)
            breedLabel.font = UIFont.systemFont(ofSize: 18)
            petOwnerNameLabel.font = UIFont.systemFont(ofSize: 18)
            petDetailsLabel.font = UIFont.systemFont(ofSize: 17)
            contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 90)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 200)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 125)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImageView, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 20)
            let imageHeight = NSLayoutConstraint(item: petImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375)
            let imageWidth = NSLayoutConstraint(item: petImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 375)
            let imageX = NSLayoutConstraint(item: petImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: animalTypeLabel, attribute: .top, relatedBy: .equal, toItem: petImageView, attribute: .bottom, multiplier: 1, constant: 25)
            let animalTypeX = NSLayoutConstraint(item: animalTypeLabel, attribute: .leading, relatedBy: .equal, toItem: petImageView, attribute: .leading, multiplier: 1, constant: -30)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: animalTypeLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: animalTypeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petOwnerNameLeading = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: petDetailsLabel, attribute: .top, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .bottom, multiplier: 1, constant: 8)
            let petDetailLeading = NSLayoutConstraint(item: petDetailsLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 50)
            let petDetailTrailing = NSLayoutConstraint(item: petDetailsLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -50)
            let petDetailHeight = NSLayoutConstraint(item: petDetailsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            let contactButtonTop = NSLayoutConstraint(item: contactButton, attribute: .top, relatedBy: .equal, toItem: petDetailsLabel, attribute: .bottom, multiplier: 1, constant: 10)
            let contactButtonLeading = NSLayoutConstraint(item: contactButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let contactButtonWidth = NSLayoutConstraint(item: contactButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 225)
            let contactButtonHeight = NSLayoutConstraint(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 35)
            
            NSLayoutConstraint.activate([nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight, contactButtonTop, contactButtonLeading, contactButtonWidth, contactButtonHeight])
            NSLayoutConstraint.activate([contactButtonHeight, contactButtonWidth])
            
        case (2048, 2732):
            print("iPad Pro 12.9")
            
            petNameLabel.font = UIFont.systemFont(ofSize: 32)
            statusLabel.font = UIFont.systemFont(ofSize: 26)
            animalTypeLabel.font = UIFont.systemFont(ofSize: 26)
            breedLabel.font = UIFont.systemFont(ofSize: 26)
            petOwnerNameLabel.font = UIFont.systemFont(ofSize: 26)
            petDetailsLabel.font = UIFont.systemFont(ofSize: 25)
            contactButton.titleLabel?.font = UIFont.systemFont(ofSize: 30)
            
            let nameX = NSLayoutConstraint(item: petNameLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let nameTop = NSLayoutConstraint(item: petNameLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 100)
            let nameWidth = NSLayoutConstraint(item: petNameLabel, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            
            let statusTop = NSLayoutConstraint(item: statusLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 155)
            let statusX = NSLayoutConstraint(item: statusLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let imageTop = NSLayoutConstraint(item: petImageView, attribute: .top, relatedBy: .equal, toItem: statusLabel, attribute: .bottom, multiplier: 1, constant: 30)
            let imageHeight = NSLayoutConstraint(item: petImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
            let imageWidth = NSLayoutConstraint(item: petImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 500)
            let imageX = NSLayoutConstraint(item: petImageView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            
            let animalTypeTop = NSLayoutConstraint(item: animalTypeLabel, attribute: .top, relatedBy: .equal, toItem: petImageView, attribute: .bottom, multiplier: 1, constant: 25)
            let animalTypeX = NSLayoutConstraint(item: animalTypeLabel, attribute: .leading, relatedBy: .equal, toItem: petImageView, attribute: .leading, multiplier: 1, constant: -30)
            
            let breedTop = NSLayoutConstraint(item: breedLabel, attribute: .top, relatedBy: .equal, toItem: animalTypeLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let breedX = NSLayoutConstraint(item: breedLabel, attribute: .leading, relatedBy: .equal, toItem: animalTypeLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petOwnerNameTop = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .top, relatedBy: .equal, toItem: breedLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let petOwnerNameLeading = NSLayoutConstraint(item: petOwnerNameLabel, attribute: .leading, relatedBy: .equal, toItem: breedLabel, attribute: .leading, multiplier: 1, constant: 0)
            
            let petDetailTop = NSLayoutConstraint(item: petDetailsLabel, attribute: .top, relatedBy: .equal, toItem: petOwnerNameLabel, attribute: .bottom, multiplier: 1, constant: 12)
            let petDetailLeading = NSLayoutConstraint(item: petDetailsLabel, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 100)
            let petDetailTrailing = NSLayoutConstraint(item: petDetailsLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -100)
            let petDetailHeight = NSLayoutConstraint(item: petDetailsLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 150)
            
            let contactButtonTop = NSLayoutConstraint(item: contactButton, attribute: .top, relatedBy: .equal, toItem: petDetailsLabel, attribute: .bottom, multiplier: 1, constant: 20)
            let contactButtonLeading = NSLayoutConstraint(item: contactButton, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerXWithinMargins, multiplier: 1, constant: 0)
            let contactButtonWidth = NSLayoutConstraint(item: contactButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
            let contactButtonHeight = NSLayoutConstraint(item: contactButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 45)
            
            NSLayoutConstraint.activate([nameX, nameTop, nameWidth, statusTop, statusX, imageTop, imageX, imageHeight, imageWidth, animalTypeTop, animalTypeX, breedTop, breedX, petOwnerNameTop, petOwnerNameLeading, petDetailTop, petDetailLeading, petDetailTrailing, petDetailHeight, contactButtonTop, contactButtonLeading, contactButtonWidth, contactButtonHeight])
            NSLayoutConstraint.activate([contactButtonHeight, contactButtonWidth])

            
        default:
            print("Unknown Device")
        }
    }
}
