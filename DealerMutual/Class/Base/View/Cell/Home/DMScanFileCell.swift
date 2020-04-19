//
//  DMScanFileCell.swift
//  DealerMutual
//
//  Created by 222 on 4/7/20.
//  Copyright © 2020 sasha dovbnya. All rights reserved.
//

import UIKit

class DMScanFileCell: UICollectionViewCell {
    @IBOutlet weak var fileNameLbl: UILabel!
    @IBOutlet weak var scanImageView: UIImageView!
    @IBOutlet weak var pagesLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        pagesLbl.layer.cornerRadius = 15
        pagesLbl.layer.masksToBounds = true
    }
}
