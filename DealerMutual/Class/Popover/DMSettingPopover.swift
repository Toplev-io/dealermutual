//
//  DMSettingPopover.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/16/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import AVFoundation
import WeScan

class DMSettingPopover: DMBaseViewController<DMSettingPopoverModel> {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    @IBAction func onLogout(_ sender: Any) {
        if let panrentController = navigationController?.presentingViewController as? UINavigationController {
            model.logout()
            dismiss(animated: true) {
                panrentController.popToRootViewController(animated: true)
            }
        }
    }

}
