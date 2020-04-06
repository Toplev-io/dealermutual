//
//  DMUserAccount.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import FirebaseAuth
import ObjectMapper

class DMUserAccount: Mappable {
    
    private(set) var email: String = ""
    private(set) var name: String = ""
    var avatarURL: URL?
    private(set) var phoneNumber: String?
    
    init(with firebaseUser: User) {
        email = firebaseUser.email ?? ""
        name = firebaseUser.displayName ?? ""
        avatarURL = firebaseUser.photoURL
        phoneNumber = firebaseUser.phoneNumber
    }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        name <- map["name"]
        avatarURL <- (map["avatarURL"], URLTransform())
        phoneNumber <- map["phoneNumber"]
    }
}
