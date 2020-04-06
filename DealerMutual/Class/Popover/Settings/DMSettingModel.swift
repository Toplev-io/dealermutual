//
//  DMSettingModel.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class DMSettingModel: DMBaseModel {
    
    weak var view: DMSettingViewController?
    
    func saveEmail() {
        guard let account = DMUserManager.instance.curentAccount else { return }
        if let email = view?.emailTextField.text, validate(email: email) {
            if email != account.email {
                saveAlert(nameOfUpdate: "email") { [weak self] in
                    _ = self?.reautUser(callback: {
                        Auth.auth().currentUser?.updateEmail(to: email) { (error) in
                            if let error = error {
                                self?.view?.showError(error.localizedDescription)
                            }
                            let uiid = Auth.auth().currentUser?.uid ?? ""
                            Database.database().reference().child("users/\(uiid)/email").setValue(email)
                            DMUserManager.instance.updateUpdateFireUser()
                        }
                    })
                }
            }
        }
    }
    
    func updatePasswrod() {
        var newTextField: UITextField?
        var confirmTextField: UITextField?
        let controller = self.reautUser { [weak self] in
            if let newPassword = newTextField?.text,
                newPassword.count > 0,
                let confirmPassword = confirmTextField?.text,
                newPassword == confirmPassword {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    if let error = error {
                        self?.view?.showError(error.localizedDescription)
                    }
                })
            }
            else {
                self?.view?.showError("New password must be the same as confirm password")
            }
        }
        controller.addTextField { (alertNewPassword) in
            alertNewPassword.placeholder = "New password"
            alertNewPassword.isSecureTextEntry = true
            newTextField = alertNewPassword
        }
        controller.addTextField { (alertConfirmPassword) in
            alertConfirmPassword.placeholder = "Confirm password"
            alertConfirmPassword.isSecureTextEntry = true
            confirmTextField = alertConfirmPassword
        }
    }
    
    func updatePhoneNumber() {
        guard let phoneNumber = view?.phoneNumberTextField.text,
            validate(phoneNumber: phoneNumber),
            let account = DMUserManager.instance.curentAccount,
            phoneNumber != account.phoneNumber else { return }
        _ = reautUser { [weak self] in
            DMUserManager.instance.getLoginCredentianal(with: phoneNumber, callback: { (error, credentianal) in
                guard let credentianal = credentianal else {
                    self?.view?.showError(error?.localizedDescription ?? "")
                    return
                }
                Auth.auth().currentUser?.updatePhoneNumber(credentianal, completion: { (error) in
                    if let error = error {
                        self?.view?.showError(error.localizedDescription)
                    }
                })
            })
        }
    }
    
    func saveName() {
        guard let account = DMUserManager.instance.curentAccount else { return }
        if let name = view?.nameTextField.text, name.count > 0 {
            if name != account.name {
                saveAlert(nameOfUpdate: "username") {
                    let uiid = Auth.auth().currentUser?.uid ?? ""
                    DMUserManager.instance.updateUser(with: uiid, name: name, avatarURL: Auth.auth().currentUser?.photoURL?.absoluteString)
                }
            }
        }
    }
    
    func saveAlert(nameOfUpdate: String, saveAction: (() -> Void)? = nil)  {
        let controller = UIAlertController(title: nil, message: "Do you want to update \(nameOfUpdate)?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Save", style: .default, handler: { (sender) in
            saveAction?()
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view?.present(controller, animated: true, completion: nil)
    }
    
    func reautUser(callback: (() -> Void)? = nil) -> UIAlertController {
        let controller = UIAlertController(title: nil, message: "Please, re-authenticate", preferredStyle: .alert)

        controller.addTextField { (password) in
            password.placeholder = "Password"
            password.isSecureTextEntry = true
        }
        controller.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (sender) in
            let user = Auth.auth().currentUser
            let email = user?.email ?? ""
            let password = controller.textFields?.first?.text ?? ""
            let credential = EmailAuthProvider.credential(withEmail: email, password: password)
            user?.reauthenticateAndRetrieveData(with: credential, completion: { [weak self] (result, error) in
                if let error = error {
                    self?.view?.showError(error.localizedDescription)
                } else {
                    callback?()
                }
            })
        }))
        controller.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        view?.present(controller, animated: true, completion: nil)
        return controller
    }
}
