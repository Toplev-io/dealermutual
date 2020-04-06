//
//  DMItemTextField.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

private let placeholderColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
private let suffix = "(optional)"

class DMItemTextField: DMBaseTextField, UITextFieldDelegate {
    private let phoneCodeLabel = UILabel()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        textColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
        backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor =  #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        placeholder = nil
    }
    
    func setupPhoneLogic() {
        delegate = self
        phoneCodeLabel.textColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
        phoneCodeLabel.font = UIFont.systemFont(ofSize: 22, weight: .regular)
        phoneCodeLabel.text = "+1"
        phoneCodeLabel.textAlignment = .center
        phoneCodeLabel.sizeToFit()
        phoneCodeLabel.frame.size.width += 10
        leftView = phoneCodeLabel
        leftViewMode = .always
    }
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let textFieldStr = textField.text {
            let newString = (textFieldStr as NSString).replacingCharacters(in: range, with: string)
            return newString.count <= 10
        }

        return false
    }
}
