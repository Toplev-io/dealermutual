//
//  DMDealerCell.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMDealerCell: DMBaseHomeCell {

    @IBOutlet weak var userStatusView: UIView!
    @IBOutlet weak var businessIconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        userStatusView.layer.borderWidth = 2
        userStatusView.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        userStatusView.layer.cornerRadius = userStatusView.bounds.midX
        businessIconView.layer.cornerRadius = 5
        businessIconView.layer.masksToBounds = true
    }
    
    override func updateCell(with info: DMBaseHomeItem) {
        if let user = info as? DMDealer {
            setUserStatus(isOnline: user.isOnline)
            userNameLabel.text = user.name
            businessIconView.image = UIImage(named:"dealer")
            if let url = user.avatarURL {
                businessIconView.af_setImage(withURL: url)
            }
        }
    }
    
    func setUserStatus(isOnline: Bool) {
        userStatusView.backgroundColor = isOnline ? #colorLiteral(red: 0.3098039216, green: 0.8039215686, blue: 0.3333333333, alpha: 1) : #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
    }
}
