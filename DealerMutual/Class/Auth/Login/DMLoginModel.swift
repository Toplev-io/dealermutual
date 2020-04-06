//
//  DMLoginModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMLoginModel: DMBaseModel {
    
    var isUserLogined: Bool {
        return DMUserManager.instance.curentAccount != nil
    }
    
    func login(email: String, password: String, callback: ((_ errror: Error?, _ user: DMUserAccount?) -> Void)? = nil) {
        DMUserManager.instance.login(email: email, password: password, callback: callback)
    }
}
