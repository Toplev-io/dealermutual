//
//  DMUserManager.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import MBProgressHUD

struct DMError: Error {
    var errorText: String = ""
}

class DMUserManager {
    static let instance = DMUserManager()
    
    private init() {
        updateUpdateFireUser()
    }
    
    private(set) var curentAccount: DMUserAccount? {
        didSet {
            saveUserInDatabase(isOnline: curentAccount != nil)
        }
    }
    
    func login(email: String, password: String, callback: ((_ errror: Error?, _ user: DMUserAccount?) -> Void)? = nil) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] (result, error) in
            if let firebaseUser = Auth.auth().currentUser {
                let user = DMUserAccount(with: firebaseUser)
                self?.curentAccount = user
                self!.saveToken(uid: firebaseUser.uid)
                callback?(nil, user)
            }
            else {
                callback?(error, nil)
            }
        }
    }
    
    
    func saveToken(uid:String){
              let ref = Database.database().reference()
              
              let info:NSDictionary = ["token":UserDefaults.standard.value(forKey: "token") ?? ""]
        ref.child("tokens").child(uid).setValue(info)
          }
    
    
    
    
    func createNewAccount(with info: DMCreateAccountInfo, callback: ((_ errror: Error?, _ user: DMUserAccount?) -> Void)? = nil) {
        if let phone = info.phoneNumber {
            getLoginCredentianal(with: phone) { [weak self] (error, phoneCredential) in
                if let phoneCredential = phoneCredential {
                    let hud = showHUD()
                    Auth.auth().signInAndRetrieveData(with: phoneCredential, completion: { (result, error) in
                        if let error = error {
                            hud.hide(animated: true)
                            callback?(error, nil)
                            return
                        }
                        // Add password and email credentianal
                        Auth.auth().currentUser?.updatePassword(to: info.password, completion: nil)
                        let emailcredential = EmailAuthProvider.credential(withEmail: info.email, password: info.password)
                        Auth.auth().currentUser?.linkAndRetrieveData(with: emailcredential, completion: { (result, error) in
                            hud.hide(animated: true)
                            if let error = error {
                                callback?(error, nil)
                                return
                            }
                            if let firebaseUser = Auth.auth().currentUser {
                                self?.updateCurentUser(with: info)
                                let user = DMUserAccount(with: firebaseUser)
                                self?.curentAccount = user
                                self!.saveToken(uid: firebaseUser.uid)

                                callback?(nil, user)
                            }
                        })
                    })
                }
                else {
                    callback?(error, nil)
                }
            }
        }
        else {
            Auth.auth().createUser(withEmail: info.email, password: info.password) { [weak self] (result, error) in
                self?.updateCurentUser(with: info)
            }
        }
    }
    
    func getLoginCredentianal(with phone: String, callback: ((_ errror: Error?, _ phoneCredentianal: PhoneAuthCredential?) -> Void)? = nil) {
//        let hud = showHUD()
        PhoneAuthProvider.provider().verifyPhoneNumber(phone, uiDelegate: nil) { (verificationID, error) in
//            hud.hide(animated: true)
            if let error = error {
                callback?(error, nil)
                return
            }
            if let topController = getTopViewController(UIApplication.shared.delegate?.window??.rootViewController) {
                let alertController = UIAlertController(title: nil, message: "Enter phone code", preferredStyle: .alert)
                alertController.addTextField(configurationHandler: { (textField) in
                    textField.placeholder = "Phone code"
                })
                alertController.addAction(UIAlertAction(title: "Verify", style: .default, handler: { (sender) in
                    guard let verificationCode = alertController.textFields?.first?.text,
                        let verificationID = verificationID else {
                            callback?(DMError(errorText: "Please try later"), nil)
                            return
                    }
                    let phoneCredential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
                    callback?(nil, phoneCredential)
                }))
                alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (sender) in
                    alertController.dismiss(animated: true, completion: nil)
                }))
                topController.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func logout() {
        do {
            try Auth.auth().signOut()
            curentAccount = nil
        }
        catch {
            
        }
    }
    
    private func updateCurentUser(with info: DMUpdateUserInfo, callback: ((_ errror: Error?) -> Void)? = nil) {
        if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
            changeRequest.displayName = info.name
            if let url = info.avatarURL {
                changeRequest.photoURL = URL(string: url)
            }
            changeRequest.commitChanges { (error) in
                callback?(error)
            }
        }
    }
    
    private func saveUserInDatabase(isOnline: Bool) {
        let keyOnlineStatusKey =  "isOnline"
        guard var jsonObject = curentAccount?.toJSON() else { return }
        let userID = Auth.auth().currentUser?.uid ?? ""
        jsonObject[keyOnlineStatusKey] = isOnline
        Database.database().reference().child("users/\(userID)/\(keyOnlineStatusKey)").onDisconnectSetValue(false)
        Database.database().reference().child("users/\(userID)").setValue(jsonObject)
    }
    
    func updateUser(with userID: String, name: String, avatarURL: String?, callback: ((_ errror: Error?) -> Void)? = nil) {
        let newData = DMUpdateAccountInfo(name: name, avatarURL: avatarURL)
        updateCurentUser(with: newData) { [weak self] (error) in
            callback?(error)
            if  error == nil {
                Database.database().reference().child("users/\(userID)/name").setValue(name)
                if let urlStr = avatarURL {
                    Database.database().reference().child("users/\(userID)/avatarURL").setValue(urlStr)
                }
                self?.updateUpdateFireUser()
            }
        }
    }
    
    func update(with userID: String, avatar: URL) {
        curentAccount?.avatarURL = avatar
        Database.database().reference().child("users/\(userID)/name").setValue(avatar.absoluteString)
    }
    
    func updateUpdateFireUser() {
        if let firebaseUser = Auth.auth().currentUser {
            self.curentAccount = DMUserAccount(with: firebaseUser)
            saveUserInDatabase(isOnline: true)
        }
    }
    
  
}
