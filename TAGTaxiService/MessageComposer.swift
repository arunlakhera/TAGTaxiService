//
//  MessageComposer.swift
//  TAGTaxiService
//
//  Created by Arun Lakhera on 3/25/17.
//  Copyright © 2017 Arun Lakhera. All rights reserved.
//

import Foundation
import MessageUI

let textMessageRecipients = ["9886136629","8979743264"] // for pre-populating the recipients list

class MessageComposer: NSObject, MFMessageComposeViewControllerDelegate{
    // A wrapper function to indicate whether or not a text message can be sent from the user's device
    func canSendText() -> Bool {
        return MFMessageComposeViewController.canSendText()
    }
    
    // Configures and returns a MFMessageComposeViewController instance
    func configuredMessageComposeViewController(textMessage: String) -> MFMessageComposeViewController {
        let messageComposeVC = MFMessageComposeViewController()
        messageComposeVC.messageComposeDelegate = self  //  Make sure to set this property to self, so that the controller can be dismissed!
        messageComposeVC.recipients = textMessageRecipients
        messageComposeVC.body =  textMessage
        return messageComposeVC
    }
    
    // MFMessageComposeViewControllerDelegate callback - dismisses the view controller when the user is finished with it
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        controller.dismiss(animated: true, completion: nil)
    }
}
