//
//  DMItem.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import ObjectMapper
import FirebaseAuth

class DMItem: Mappable, DMBaseHomeItem {
    
    class var itemKey: String  { return "" }
    
    var databaseKey: String {
        return ""
    }
    
    var cellInditifier: String { return "" }
    
    var nameOfProspect: String?
    var phoneNumber: String?
    var date: Date = Date()
    var comment: String?
    var itemID: String?
    private(set) var author: String = Auth.auth().currentUser?.uid ?? ""
    private(set) var authorName: String = Auth.auth().currentUser?.displayName ?? ""
    
    required init?(map: Map) {
    }
    
    init() {
    }
    
    func mapping(map: Map) {
        nameOfProspect <- map["nameOfProspect"]
        phoneNumber <- map["phoneNumber"]
        date <- (map["date"], ISO8601DateTransform())
        comment <- map["comment"]
        author <- map["author"]
        authorName <- map["authorName"]
    }
}
