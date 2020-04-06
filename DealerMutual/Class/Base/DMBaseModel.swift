//
//  DMBaseModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

protocol DMBaseModelInterface {
    init()
}

class DMBaseModel: NSObject, DMBaseModelInterface {
    required override init() {
        super.init()
    }
}
