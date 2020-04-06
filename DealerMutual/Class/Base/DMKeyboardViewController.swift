//
//  DMKeyboardViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMKeyboardViewController<T>: DMBaseViewController<T> where T: DMBaseModel {
    @IBOutlet weak var keyboardScroll: UIScrollView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification) {
        if let boundsKeyboard = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? CGRect {
            let height = boundsKeyboard.height
            updateContent(insert: UIEdgeInsetsMake(0, 0, height, 0))
        }
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification) {
        updateContent(insert: .zero)
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    func updateContent(insert: UIEdgeInsets) {
        keyboardScroll?.contentInset = insert
    }
}
