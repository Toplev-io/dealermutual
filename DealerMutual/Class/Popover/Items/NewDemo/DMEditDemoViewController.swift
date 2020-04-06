//
//  DMEditDemoViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/30/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMEditDemoViewController: DMNewItemViewController<DMNewDemoModel> {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =  displayItem != nil ? "" : "Create new Demo"
        if displayItem != nil {
            var leftButtons = [UIBarButtonItem]()
            leftButtons.append(createLabelBarButton(with: "Demo detail", fontSize: 20))
            navigationItem.leftBarButtonItems = leftButtons
        }
        else {
//            let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaveItem(_:)))
//            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @IBAction func createItem(_ sender: UIButton) {
        save(item: displayItem ?? DMDemo())
    }
    
    override func onSaveItem(_ sender: UIButton) {
        save(item: displayItem ?? DMDemo())
        view.endEditing(true)
    }
}
