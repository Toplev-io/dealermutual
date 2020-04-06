//
//  DMLoginViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import MBProgressHUD

class DMLoginViewController: DMKeyboardViewController<DMLoginModel> {
    
    @IBOutlet weak var emailTextField: DMBaseTextField!
    @IBOutlet weak var passwordTextField: DMBaseTextField!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        keyboardScroll?.isHidden = model.isUserLogined
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if model.isUserLogined {
            self.performSegue(withIdentifier: "onLogin", sender: nil)
        }
    }
    
    @IBAction func onLogin(_ sender: Any) {
        guard let email = emailTextField.text, DealerMutual.validate(email: email) else {
            self.showError("Please enter email")
            return
        }
        guard let password = passwordTextField.text,
            !password.isEmpty else {
                self.showError("Please enter corect password")
                return
        }

        let hud = MBProgressHUD.showAdded(to: view?.window ?? UIView(), animated: true)
        model.login(email: email, password: password) {[weak self] (error, account) in
            hud.hide(animated: true)
            if let error = error {
                self?.showError(error.localizedDescription)
            }
            else {
                self?.performSegue(withIdentifier: "onLogin", sender: nil)
            }
        }
    }
}
