//
//  DispatchQueue.swift
//  MyMot
//
//  Created by Michail Solyanic on 03/07/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

extension DispatchQueue {
    
    static func background(delay: Double = 0.0, background: (()->Void)? = nil, completion: (() -> Void)? = nil) {
        DispatchQueue.global(qos: .background).async {
            background?()
            if let completion = completion {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: {
                    completion()
                })
            }
        }
    }
    
}
