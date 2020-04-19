//
//  Share.swift
//  HeartMyWorkOut
//
//  Created by 222 on 1/12/20.
//  Copyright © 2020 HeartMyWorkout. All rights reserved.
//

import UIKit
import ObjectMapper

class DMPDFScanningFile: Mappable {
    static func == (lhs: DMPDFScanningFile, rhs: DMPDFScanningFile) -> Bool {
        return lhs.scanID == rhs.scanID
    }
    
    var scanID: String = ""
    var ownerID: String = ""
    var imageUrl: String?
    var pdfURL: String?
    var pages: Int = 0
    
    
    required init?(map: Map) {
    }
    
    func mapping(map: Map) {
        scanID <- map["scanID"]
        ownerID <- map["ownerID"]
        imageUrl <- map["imageUrl"]
        pdfURL <- map["pdfURL"]
        pages <- map["pages"]
    }
}
