//
//  DMDemo.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/30/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMDemo: DMItem {
    override class var itemKey: String  { return "demo" }
    override var cellInditifier: String { return "demo" }
    
    override var databaseKey: String {
        return DMDemo.itemKey
    }
}
