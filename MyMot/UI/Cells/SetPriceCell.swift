//
//  SetPriceCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 16/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit

class SetPriceCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var propertyCaption: UILabel!
    @IBOutlet weak var propertyField: UITextField!
    @IBOutlet weak var propertySuffix: UILabel!
    private var eventListener: CellEventProtocol?
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        self.eventListener = eventListener
        if let content = content as? (String, String?) {
            propertyCaption.text = content.0
            propertyField.text = content.1
            //listener.listener = self
            propertySuffix.isHidden = content.1 == nil
        }
        contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setFocused)))
    }
    
    @objc func setFocused() {
        propertyField.becomeFirstResponder()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(false, animated: false)
    }
    
    @IBAction func valueChanged(_ sender: UITextField) {
        if let text = sender.text, let price = Int(text.replacingOccurrences(of: " ", with: "")) {
            propertySuffix.isHidden = price == 0
            sender.text = price.splitThousands()
            eventListener?.intValueChanged(price)
        } else {
            propertySuffix.isHidden = true
            eventListener?.intValueChanged(nil)
        }
    }
    
}

extension Cell {
    convenience init(setPriceTitle: String, value: String?) {
        self.init(cellType: .setPrice)
        self.content = (setPriceTitle, value)
    }
}
