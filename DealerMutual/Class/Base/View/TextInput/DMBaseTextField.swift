//
//  DMBaseTextField.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

private let textFont = UIFont.systemFont(ofSize: 22, weight: .regular)
private let placeholderTextColor: UIColor = #colorLiteral(red: 0.1294117647, green: 0.3019607843, blue: 0.4745098039, alpha: 1)

class DMBaseTextField: UITextField {
    
    var dmTextColor: UIColor = placeholderTextColor {
        didSet {
            commonUpdate()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dmTextColor = placeholderTextColor
    }
    
    func commonUpdate() {
        if let placeholder = placeholder {
            let attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor : dmTextColor,
                                                                                             .font : textFont])
            self.attributedPlaceholder = attributedPlaceholder
        }
        font = textFont
        textColor = placeholderTextColor
    }
}
