//
//  DMSelectItemView.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 12/27/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSelectItemView: UIView {
    @IBOutlet weak var labelView: UILabel!
    @IBOutlet weak var iconView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        layer.borderWidth = 1
        layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = .white
        labelView.textColor = .white
    }
}
