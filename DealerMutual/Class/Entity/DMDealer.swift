//
//  DMDealer.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import ObjectMapper

class DMDealer: Mappable, DMBaseHomeItem, Comparable {

    static func == (lhs: DMDealer, rhs: DMDealer) -> Bool {
        return lhs.userID == rhs.userID
    }
    
    
    static func < (lhs: DMDealer, rhs: DMDealer) -> Bool {
        if lhs.isOnline {
            if rhs.isOnline {
                return lhs.name < rhs.name
            }
            return true
        }
        else {
            if rhs.isOnline {
                return false
            }
            return lhs.name < rhs.name
        }
    }
    
    var userID: String = ""
    private(set) var email: String = ""
    private(set) var name: String = ""
    private(set) var avatarURL: URL?
    private(set) var phoneNumber: String?
    private(set) var isOnline: Bool = false
    var date = Date()
    
    var cellInditifier: String { return "dealer" }
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        email <- map["email"]
        name <- map["name"]
        avatarURL <- (map["avatarURL"], URLTransform())
        phoneNumber <- map["phoneNumber"]
        isOnline <- map["isOnline"]
    }
}
