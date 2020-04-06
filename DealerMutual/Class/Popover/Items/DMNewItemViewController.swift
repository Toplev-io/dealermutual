//
//  DMNewItemViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import FirebaseAuth

class DMNewItemViewController<T>: DMKeyboardViewController<T> where T: DMNewItemModel {
    
    @IBOutlet weak var nameTextField: DMItemTextField!
    @IBOutlet weak var phoneNumberField: DMItemTextField!
    @IBOutlet weak var dateField: DMDateTextField!
    @IBOutlet weak var commentTextView: DMBaseTextView!
    @IBOutlet weak var actionButton: UIButton!
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var displayItem: DMItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = displayItem?.nameOfProspect
        phoneNumberField.text = displayItem?.phoneNumber
        dateField.set(date: displayItem?.date ?? Date())
        commentTextView.text = displayItem?.comment
        phoneNumberField.setupPhoneLogic()
        
        if let item = displayItem {
            actionButton.isHidden = true
            navigationItem.leftItemsSupplementBackButton = true
            if item.author == Auth.auth().currentUser?.uid {
                let saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.onSaveItem(_:)))
                navigationItem.rightBarButtonItem = saveButton
            }
            else {
                setup(label: nameLabel, text: "Name of prospect")
                setup(label: numberLabel, text: "Number")
                setup(label: commentLabel, text: "Comment")
                changeEditState(false)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setup(label: UILabel, text: String) {
        label.text = text
        label.font = UIFont.systemFont(ofSize: 18, weight: .light)
        label.textColor = #colorLiteral(red: 0.662745098, green: 0.662745098, blue: 0.662745098, alpha: 1)
    }
    
    func changeEditState(_ isEditing: Bool) {
        nameTextField.isUserInteractionEnabled = isEditing
        phoneNumberField.isUserInteractionEnabled = isEditing
        dateField.isUserInteractionEnabled = isEditing
        commentTextView.isEditable = isEditing
    }
    
    func save(item: DMItem) {
        item.nameOfProspect = nameTextField.text
        let phoneNumCount = phoneNumberField.text?.count ?? 0
        if phoneNumCount > 0,
            let phoneNumber = phoneNumberField.text,
            !DealerMutual.validate(phoneNumber: "+1" + phoneNumber) {
            showError("Please enter corect phone number")
            return
        }
        else {
            item.phoneNumber = phoneNumberField.text ?? ""
        }
        item.date = dateField.get()
        item.comment = commentTextView.text
        model.create(item: item, controller: self)
    }
    
    @objc func onSaveItem(_ sender: UIButton) {
        
    }
}
