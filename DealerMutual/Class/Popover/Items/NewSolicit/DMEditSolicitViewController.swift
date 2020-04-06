//
//  DMEditSolicitViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMEditSolicitViewController: DMNewItemViewController<DMNewSolicitModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  displayItem != nil ? "" : "Create new solicit"
        if displayItem != nil {
            var leftButtons = [UIBarButtonItem]()
            leftButtons.append(createLabelBarButton(with: "Solicit detail", fontSize: 20))
            navigationItem.leftBarButtonItems = leftButtons
        }
    }
    
    @IBAction func createItem(_ sender: UIButton) {
        save(item: displayItem ?? DMSolicit())
    }
    
    override func onSaveItem(_ sender: UIButton) {
        save(item: displayItem ?? DMSolicit())
        view.endEditing(true)
    }
}
