//
//  DMSolicit.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/23/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSolicit: DMItem {
    
    override class var itemKey: String  { return "solicit" }
    override var cellInditifier: String { return "solicits" }
    
    override var databaseKey: String {
        return DMSolicit.itemKey
    }
}
