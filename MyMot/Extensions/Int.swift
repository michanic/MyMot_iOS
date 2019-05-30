//
//  Int.swift
//  MyMot
//
//  Created by Michail Solyanic on 26/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = " "
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension Int {
    
    func splitThousands() -> String {
        return (Formatter.withSeparator.string(for: self) ?? "")
    }
    
}

extension Int32 {
    
    func splitThousands() -> String {
        return (Formatter.withSeparator.string(for: self) ?? "")
    }
    
    func toStringPrice() -> String {
        return self.splitThousands() + " р."
    }
    
}
