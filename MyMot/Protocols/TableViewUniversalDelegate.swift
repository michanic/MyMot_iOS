//
//  TableViewUniversalDelegate.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import Foundation

protocol TableViewUniversalDelegate: class {
    var dataSource: [Section] { get }
}
