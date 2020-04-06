//
//  DMBaseTextView.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

private let placeholderColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)

class DMBaseTextView: UITextView {
    override func awakeFromNib() {
        super.awakeFromNib()
        font = UIFont.systemFont(ofSize: 22, weight: .regular)
        textColor = #colorLiteral(red: 0.1490196078, green: 0.1490196078, blue: 0.1490196078, alpha: 1)
        
        backgroundColor = #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        layer.borderWidth = 1
        layer.cornerRadius = 5
        layer.borderColor =  #colorLiteral(red: 0.9098039216, green: 0.9098039216, blue: 0.9098039216, alpha: 1)
        
        textContainerInset = UIEdgeInsetsMake(14, 0, 14, 0)
    }
}
