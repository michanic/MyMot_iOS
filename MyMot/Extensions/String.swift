//
//  String.swift
//  MyMot
//
//  Created by Michail Solyanic on 12/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

extension String {
    
    func checkForExteption() -> Bool {
        for word in ConfigStorage.shared.exteptedWords {
            if self.lowercased().contains(word.lowercased()) {
                //print(self)
                return false
            }
        }
        return true
    }
    
    func getHeightFor(width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [NSStringDrawingOptions.usesLineFragmentOrigin, NSStringDrawingOptions.usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return ceil(boundingBox.height)
    }
    
    
    func makeCall() {
        let cleanPhoneNumber = self.components(separatedBy: CharacterSet.decimalDigits.inverted).joined(separator: "")
        let urlString:String = "telprompt://\(cleanPhoneNumber)"
        if let phoneCallURL = URL(string: urlString) {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                if #available(iOS 10.0, *) {
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(phoneCallURL as URL)
                }
            }
        }
    }
    
    func sendEmail() {
        let urlString:String = "mailto://\(self)"
        if let emailURL = URL(string: urlString) {
            let application: UIApplication = UIApplication.shared
            if (application.canOpenURL(emailURL)) {
                if #available(iOS 10.0, *) {
                    application.open(emailURL, options: [:], completionHandler: nil)
                } else {
                    application.openURL(emailURL as URL)
                }
            }
        }
    }
    
}
