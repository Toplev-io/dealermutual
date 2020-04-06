//
//  DMSelectItemModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 12/27/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMSelectItemModel: DMDealerItemsModel {
    
    weak var selectViewController: DMSelectItemViewController?
    
    override func didUpdate(with data: [DMBaseHomeItem]) {
        super.didUpdate(with: data)
        if let array = data as? [DMSale] {
            updateContetntView(with: .sale, count: array.count)
        }
        else if let array = data as? [DMDemo] {
            updateContetntView(with: .demo, count: array.count)
        }
        else if let array = data as? [DMSolicit] {
            updateContetntView(with: .solicit, count: array.count)
        }
        else if let array = data as? [DMDealer] {
            updateContetntView(with: .dealer, count: array.count)
        }
    }
    
    override func sortDealer(array: [DMDealer]) -> [DMDealer] {
        let tempArray = array.filter({ $0.isOnline == true })
        return tempArray.sorted(by: { $0 < $1 })
    }
    
    private func updateContetntView(with type: DMSelectItemType, count: Int) {
        guard let view = selectViewController else { return }
        let contentView = view.itemViews[type.rawValue]
        contentView.labelView.text = type.title + "\n" + "(\(count))"
    }
}

