//
//  Section.swift
//  MyMot
//
//  Created by Michail Solyanic on 08/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

struct SectionHeader {
    
    var title: String?
    
    lazy var height: CGFloat = {
        if let title = title, title.count > 0 {
            return 25
        } else {
            return CGFloat.leastNormalMagnitude
        }
    } ()
    
    lazy var view: UIView? = {
        if let title = title, title.count > 0 {
            return UIView.titleForHeaderInSection(title)
        } else {
            return nil
        }
    }()
}

class Section {

    var headerProperties: SectionHeader = SectionHeader()
    var cells: [Cell] = []
    
}
