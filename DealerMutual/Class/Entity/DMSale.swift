//
//  DMSale.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import ObjectMapper

class DMSale: DMItem {
    
    override class var itemKey: String  { return "sale" }
    
    override var cellInditifier: String { return "sale" }
    
    override var databaseKey: String {
        return DMSale.itemKey
    }
    
    var price: Float = 0
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        price <- map["price"]
    }
}
