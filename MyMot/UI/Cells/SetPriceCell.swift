//
//  SetPriceCell.swift
//  MyMot
//
//  Created by Michail Solyanic on 16/04/2019.
//  Copyright © 2019 Michail Solyanic. All rights reserved.
//

import UIKit
import InputMask

class SetPriceCell: UITableViewCell, CellContentProtocol {
    
    @IBOutlet weak var propertyCaption: UILabel!
    @IBOutlet weak var propertyField: UITextField!
    @IBOutlet weak var propertySuffix: UILabel!
    private var eventListener: CellEventProtocol?
    
    var listener: MaskedTextFieldDelegate = MaskedTextFieldDelegate(primaryFormat: "[000][000][000]")
    
    func fillWithContent(content: Any?, eventListener: CellEventProtocol?) {
        self.eventListener = eventListener
        if let content = content as? (String, String?) {
            propertyCaption.text = content.0
            propertyField.text = content.1
            listener.listener = self
            propertyField.delegate = listener
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
}

extension SetPriceCell: MaskedTextFieldDelegateListener {
    @objc func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {

        if let text = textField.text {
            propertySuffix.isHidden = text.count == 0
        } else {
            propertySuffix.isHidden = true
        }
        
        if let text = textField.text, let textInt = Int(text.replacingOccurrences(of: " ", with: "")), textInt > 0{
            eventListener?.intValueChanged(textInt)
        } else {
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
