//
//  DMSettingViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 10/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import AlamofireImage
import Firebase
import FirebaseStorage
import UIKit
import MBProgressHUD

class DMSettingViewController: DMBaseViewController<DMSettingModel>, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: DMBaseTextField!
    @IBOutlet weak var emailTextField: DMBaseTextField!
    @IBOutlet weak var phoneNumberTextField: DMBaseTextField!
    @IBOutlet weak var avatarButton: UIButton!
    
    private let imageViewModel = ImageViewModel()
    private let cloudStorage = Storage.storage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.view = self
        if let account = DMUserManager.instance.curentAccount {
            nameTextField.text = account.name
            emailTextField.text = account.email
            phoneNumberTextField.text = account.phoneNumber
            if let url = account.avatarURL {
                avatarButton.af_setImage(for: .normal, url: url)
            }
        }
        navigationItem.title = "Settings"
        nameTextField.delegate = self
        emailTextField.delegate = self
        phoneNumberTextField.delegate = self
        let buttonColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.35)
        avatarButton.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.layer.borderWidth = 1
        avatarButton.layer.borderColor = buttonColor.cgColor
        avatarButton.setTitle("+\navatar", for: .normal)
        avatarButton.titleLabel?.numberOfLines = 0
        avatarButton.titleLabel?.textAlignment = .center
        avatarButton.setTitleColor(buttonColor, for: .normal)
        avatarButton.imageView?.contentMode = .scaleAspectFill
        avatarButton.imageView?.layer.cornerRadius = avatarButton.bounds.height / 2
        avatarButton.imageView?.layer.masksToBounds = true
        avatarButton.imageView?.tintColor = nil
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nameTextField {
            model.saveName()
        }
        if textField == emailTextField {
            model.saveEmail()
        }
        if textField == phoneNumberTextField {
            model.updatePhoneNumber()
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func updatePassword(_ sender: Any) {
        model.updatePasswrod()
    }
    
    @IBAction func onAvatarPress(_ sender: Any) {
        let imagePicker = ImageViewModel()
        imagePicker.showPickerSourceImage(self)
        imagePicker.didChooseImage = { [weak self] (controller, image) in
            self?.upload(image: image)
        }
    }
    
    func upload(image: UIImage) {
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        DispatchQueue.global().async {
            let fixedImage = normalized(image: image)
            guard let curentUser = Auth.auth().currentUser,
                let data = UIImagePNGRepresentation(fixedImage) else {
                    DispatchQueue.main.async { hud.hide(animated: true) }
                    return
            }
            let storageRef = self.cloudStorage.reference()
            let avatarRef = storageRef.child("user\\\(curentUser.uid)\\avatar.jpg")
            avatarRef.putData(data, metadata: nil) { [weak self] metadata, error in
                DispatchQueue.main.async {
                    print("uploaded")
                    if let error = error {
                        hud.hide(animated: true)
                        self?.showError(error.localizedDescription)
                    }
                    else {
                        avatarRef.downloadURL { url, error in
                            print("downloaded url")
                            hud.hide(animated: true)
                            if let error = error {
                                self?.showError(error.localizedDescription)
                                return
                            }
                            guard let downloadURL = url else { return }
                            DMUserManager.instance.updateUser(with: curentUser.uid, name: DMUserManager.instance.curentAccount?.name ?? "", avatarURL: downloadURL.absoluteString)
                            self?.avatarButton.setImage(image, for: .normal)
                        }
                    }
                }
            }
        }
    }
}
