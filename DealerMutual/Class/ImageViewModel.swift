//
//  ImageViewModel.swift
//  TestApp
//
//  Created by sasha dovbnya on 7/1/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import Foundation
import UIKit
import Photos

class ImageViewModel: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var didChooseImage: ((UIViewController, UIImage) -> Void)?
    var didHidePickerContoller : ((UIViewController) -> Void)?
    
    func showPickerSourceImage(_ controller: UIViewController?) {
        let pickerController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        pickerController.addAction(UIAlertAction(title: "Camera", style: .default) { (sender) in
            self.createTakePhotoConroller(controller)
        })
        pickerController.addAction(UIAlertAction(title: "Photo Library", style: .default) { (sender) in
            self.createPhotoLibraryPicker(controller)
        })
        
        pickerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] (sender) in
            self?.didHidePickerContoller?(pickerController)
        }))
            
        controller?.present(pickerController, animated: true, completion: nil)
    }
    
    private func createPhotoLibraryPicker(_ controller: UIViewController?) {
        let status = PHPhotoLibrary.authorizationStatus()
        if status == .authorized {
            showPhotoLibrary(controller)
        } else {
            PHPhotoLibrary.requestAuthorization { [weak self] (status) in
                if status == .authorized {
                    self?.showPhotoLibrary(controller)
                }
            }
        }
    }
    
    private func showPhotoLibrary(_ controller: UIViewController?) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary)
        {
            let imagePiker = UIImagePickerController()
            imagePiker.delegate = self
            imagePiker.sourceType = .photoLibrary
            imagePiker.allowsEditing = false
            controller?.present(imagePiker, animated: true, completion: nil)
        }
    }
    
    private func createTakePhotoConroller(_ controller: UIViewController?) {
        if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { [weak self] status in
                if AVCaptureDevice.authorizationStatus(for: AVMediaType.video) != .authorized {
                    self?.showCameraController(controller)
                }
            }
        }
        else {
            showCameraController(controller)
        }
    }
    
    private func showCameraController(_ controller: UIViewController?) {
        let imagePiker = UIImagePickerController()
        imagePiker.delegate = self
        imagePiker.allowsEditing = false
        imagePiker.sourceType = .camera
        controller?.present(imagePiker, animated: true, completion: nil)
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var sendImage = UIImage()
        if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            sendImage = originalImage
        }
        hide(picker: picker, complition: { [weak self] in
            self?.didChooseImage?(picker, sendImage)
        })
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        hide(picker: picker)
    }
    
    private func hide(picker: UIViewController, complition: (() -> Swift.Void)? = nil) {
        picker.dismiss(animated: true) { [weak self] in
            complition?()
            self?.didHidePickerContoller?(picker)
        }
    }
    
    private func confirm(croper: UIViewController, image: UIImage) {
        didChooseImage?(croper, image)
        if let viewController = croper.presentingViewController?.presentingViewController {
            hide(picker: viewController)
        }
        else {
            hide(picker: croper)
        }
    }
    
    private func hide(croper: UIViewController) {
        croper.dismiss(animated: true, completion: nil)
    }
}
