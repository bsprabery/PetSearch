//
//  MailComposer.swift
//  PetSearch
//
//  Created by Brittany Sprabery on 8/30/17.
//  Copyright © 2017 Brittany Sprabery. All rights reserved.
//

import Foundation
import MessageUI

class MailComposer: NSObject, MFMailComposeViewControllerDelegate {
    
    func canSendEmail() -> Bool {
        return MFMailComposeViewController.canSendMail()
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func configuredMailComposeViewController(recipient: [String], subject: String, messageBody: String) -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(recipient)
        mailComposerVC.setSubject(subject)
        mailComposerVC.setMessageBody(messageBody, isHTML: false)
        return mailComposerVC
    }
    
}
