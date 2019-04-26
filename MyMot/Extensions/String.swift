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
    
}
