//
//  DMDealerInfoModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMDealerInfoModel: DMBaseMainModel {
    var saleItems = [DMSale]()
    var demoItems = [DMDemo]()
    var solicitItems = [DMSolicit]()
    private var curentData = [DMBaseHomeItem]()
    var dealerInfo: DMDealer?
    
    override func updateData() {
        if let dealerID = dealerInfo?.userID {
            curentData.removeAll()
            getItems(type: DMSale.self, authorID: dealerID)
            getItems(type: DMDemo.self, authorID: dealerID)
            getItems(type: DMSolicit.self, authorID: dealerID)
        }
    }
    
    override func didUpdate(with data: [DMBaseHomeItem]) {
        if data.count > 0 {
            if let sales = data as? [DMSale] {
                saleItems = sales
            }
            if let demos = data as? [DMDemo] {
                demoItems = demos
            }
            if let solicits = data as? [DMSolicit] {
                solicitItems = solicits
            }
        }

        curentData.append(contentsOf: data)
        curentData.sort(by: { $0.date > $1.date })
        super.didUpdate(with: curentData)
        if let controller = view as? DMDealerInfoViewController {
            controller.updateHeader()
        }
    }
}
