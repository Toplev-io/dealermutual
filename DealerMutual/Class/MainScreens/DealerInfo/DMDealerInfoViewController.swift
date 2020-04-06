//
//  DMDealerInfoViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import AlamofireImage

class DMDealerInfoViewController: DMBaseMainViewController<DMDealerInfoModel> {

    @IBOutlet weak var statusIcon: UIView!
    @IBOutlet weak var dealerNameLabel: UILabel!
    @IBOutlet weak var solicticsCountLabel: UILabel!
    @IBOutlet weak var demosCountLabel: UILabel!
    @IBOutlet weak var salesCountLabel: UILabel!
    @IBOutlet weak var dealerLogo: UIImageView!
    
    @IBOutlet weak var callContact: UIImageView!
    var busPhone:String = ""

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if let url = NSURL(string: "tel://\(busPhone)"), UIApplication.shared.canOpenURL(url as URL) {
            UIApplication.shared.openURL(url as URL)
        }
        
        // Your action
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        statusIcon.layer.borderWidth = 2
        statusIcon.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        statusIcon.layer.cornerRadius = statusIcon.bounds.midX
        navigationItem.leftItemsSupplementBackButton = true
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action:#selector(imageTapped(tapGestureRecognizer:)))
        callContact.isUserInteractionEnabled = true
        callContact.addGestureRecognizer(tapGestureRecognizer)
        
        updateHeader()
    }
    
    func setUserStatus(isOnline: Bool) {
        statusIcon.backgroundColor = isOnline ? #colorLiteral(red: 0.3098039216, green: 0.8039215686, blue: 0.3333333333, alpha: 1) : #colorLiteral(red: 0.7921568627, green: 0.7921568627, blue: 0.7921568627, alpha: 1)
    }
    
    func updateHeader() {
        if let dealerInfo = model.dealerInfo {
            setUserStatus(isOnline: dealerInfo.isOnline)
            dealerNameLabel.text = dealerInfo.name
            busPhone = dealerInfo.phoneNumber!
        }
        
        if let url = model.dealerInfo?.avatarURL {
            dealerLogo.af_setImage(withURL: url)
        }
        solicticsCountLabel.text = "\(model.solicitItems.count)"
        demosCountLabel.text = "\(model.demoItems.count)"
        salesCountLabel.text = "\(model.saleItems.count)"
    }
}
