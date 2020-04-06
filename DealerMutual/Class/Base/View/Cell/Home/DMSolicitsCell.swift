//
//  DMSolicitsCell.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSolicitsCell: DMBaseHomeCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func updateCell(with info: DMBaseHomeItem) {
        super.updateCell(with: info)
        if let solicitsInfo = info as? DMItem {
            let dateFormater = DateFormatter()
            dateFormater.dateStyle = .short
            dateFormater.timeStyle = .none
            var dateText = dateFormater.string(from: solicitsInfo.date) + "\n"
            dateFormater.dateStyle = .none
            dateFormater.timeStyle = .short
            dateText += "At " + dateFormater.string(from: solicitsInfo.date)
            dateLabel.text = dateText
            nameLabel.text = solicitsInfo.authorName
            
           //set blue for solicit
            nameLabel.textColor = UIColor(red: 33/255, green: 77/255, blue: 121/255, alpha: 1)
            dateLabel.textColor = UIColor(red: 33/255, green: 77/255, blue: 121/255, alpha: 1)
            
            if let demoInfo = info as? DMDemo {
               dateLabel.textColor = UIColor.orange
               nameLabel.textColor = UIColor.orange
            }
            //green
            if let saleInfo = info as? DMSale {
                nameLabel.textColor = UIColor(red: 38/255, green: 143/255, blue: 22/255, alpha: 1)
                dateLabel.textColor = UIColor(red: 38/255, green: 143/255, blue: 22/255, alpha: 1)
            }
        }
    }
}
