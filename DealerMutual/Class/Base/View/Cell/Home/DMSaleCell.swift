//
//  DMSaleCell.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSaleCell: DMSolicitsCell {

    @IBOutlet weak var priceLabel: UILabel!
    
    override func updateCell(with info: DMBaseHomeItem) {
        super.updateCell(with: info)
        if let saleInfo = info as? DMSale {
            let numberFormater = NumberFormatter()
            numberFormater.numberStyle = .currency
            numberFormater.currencySymbol = "$"
            priceLabel.text = numberFormater.string(from: NSNumber(value: saleInfo.price))
            priceLabel.textColor = UIColor(red: 38/255, green: 143/255, blue: 22/255, alpha: 1)
        }
    }
}
