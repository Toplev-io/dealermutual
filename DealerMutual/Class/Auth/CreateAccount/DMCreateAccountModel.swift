//
//  DMCreateAccountModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

protocol DMUpdateUserInfo {
    var name: String { get }
    var avatarURL: String? { get }
}

struct DMUpdateAccountInfo: DMUpdateUserInfo {
    let name: String
    let avatarURL: String?
}

struct DMCreateAccountInfo: DMUpdateUserInfo {
    let email: String
    let password: String
    let name: String
    let avatarURL: String?
    let phoneNumber: String?
}


class DMCreateAccountModel: DMBaseModel {
    
    func createAccount(with info: DMCreateAccountInfo, callback: ((_ errror: Error?, _ user: DMUserAccount?) -> Void)? = nil) {
        DMUserManager.instance.createNewAccount(with: info, callback: callback)
    }
}
