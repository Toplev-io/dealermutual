//
//  DMSettingPopoverModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/16/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSettingPopoverModel: DMBaseModel {
    
    func logout() {
        DMUserManager.instance.logout()
    }
}
