//
//  DMEditSaleViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMEditSaleViewController: DMNewItemViewController<DMNewSaleModel> {
    
    @IBOutlet weak var priceField: DMItemTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  displayItem != nil ? "" : "Add new sale"
        if let item = displayItem as? DMSale {
            var leftButtons = [UIBarButtonItem]()
            leftButtons.append(createLabelBarButton(with: "Sale detail", fontSize: 20))
            navigationItem.leftBarButtonItems = leftButtons
            let numberFormater = NumberFormatter()
            numberFormater.numberStyle = .currency
            numberFormater.currencySymbol = ""
            priceField.text = numberFormater.string(from: NSNumber(value: item.price))
        }
    }
    
    @IBAction func createItem(_ sender: UIButton) {
        let item = DMSale()
        saveSale(item: item)
    }
    
    override func onSaveItem(_ sender: UIButton) {
        saveSale(item: (displayItem as? DMSale) ?? DMSale())
    }
    
    override func changeEditState(_ isEditing: Bool) {
        super.changeEditState(isEditing)
        priceField.isUserInteractionEnabled = false
    }
    
    func saveSale(item: DMSale) {
        guard let price = Float(priceField.text ?? "") else {
            showError("Please enter correct price")
            return
        }
        item.price = price
        save(item: item)
        view.endEditing(true)
    }
}
