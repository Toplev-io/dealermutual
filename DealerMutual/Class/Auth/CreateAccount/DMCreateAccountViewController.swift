//
//  DMCreateAccountViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMCreateAccountViewController: DMKeyboardViewController<DMCreateAccountModel> {
    @IBOutlet weak var emailTextField: DMBaseTextField!
    @IBOutlet weak var passwordTextField: DMBaseTextField!
    @IBOutlet weak var confirmPasswordTextField: DMBaseTextField!
    @IBOutlet weak var userNameTextField: DMBaseTextField!
    @IBOutlet weak var phoneNumberTextField: DMBaseTextField!
    
    @IBAction func onCreateNewAccount(_ sender: Any) {
        guard let email = emailTextField.text, DealerMutual.validate(email: email) else {
            self.showError("Please enter email")
            return
        }
        guard let phoneNumber = phoneNumberTextField.text, DealerMutual.validate(phoneNumber: phoneNumber) else {
            self.showError("Please enter phone number")
            return
        }
        guard let password = passwordTextField.text,
            let confirmPassword = confirmPasswordTextField.text,
            !password.isEmpty,
            password == confirmPassword else {
                self.showError("Please enter corect password")
                return
        }
        guard let userName = userNameTextField.text, !userName.isEmpty else {
            self.showError("Please enter user name")
            return
        }
        let info = DMCreateAccountInfo(email: email, password: password, name: userName, avatarURL: nil, phoneNumber: phoneNumber)
        model.createAccount(with: info) { [weak self] (error, account) in
            if let error = error {
                self?.showError(error.localizedDescription)
            }
            else {
                self?.performSegue(withIdentifier: "onLogin", sender: nil)
            }
        }
    }
    
}
