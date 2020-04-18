//
//  DMScanPDFProvider.swift
//  DealerMutual
//
//  Created by 222 on 4/6/20.
//  Copyright © 2020 sasha dovbnya. All rights reserved.
//

import UIKit

class DMScanPDFProvider:NSObject {
    static let shared = DMScanPDFProvider()
    var focusVC: UIViewController?
    var getPDFScan: ((_ image: UIImage, _ pdfURL: URL) -> ())?
    
    func getImagePDFScan(vc: UIViewController) -> DMScanPDFProvider {
        focusVC = vc
        let actionSheet = UIAlertController(title: "Would you like to scan an image or select one from your photo library?", message: nil, preferredStyle: .actionSheet)
        
        let scanAction = UIAlertAction(title: "Scan", style: .default) { (_) in
            self.scanImage()
        }
        
        let selectAction = UIAlertAction(title: "Select", style: .default) { (_) in
            self.selectImage()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        actionSheet.addAction(scanAction)
        actionSheet.addAction(selectAction)
        actionSheet.addAction(cancelAction)
        
        guard let vc = focusVC else { return self }
        vc.present(actionSheet, animated: true)
        
        return self
    }
    
    func scanImage() {
        let scannerViewController = ImageScannerController(delegate: self)
        scannerViewController.modalPresentationStyle = .fullScreen
        scannerViewController.navigationBar.tintColor = .white

        guard let vc = focusVC else { return }
        vc.present(scannerViewController, animated: true)
    }
    
    func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        guard let vc = focusVC else { return }
        vc.present(imagePicker, animated: true)
    }
}

extension DMScanPDFProvider: ImageScannerControllerDelegate {
    func imageScannerController(_ scanner: ImageScannerController, didFailWithError error: Error) {
        assertionFailure("Error occurred: \(error)")
    }
    
    func imageScannerController(_ scanner: ImageScannerController, didFinishScanningWithResults results: ImageScannerResults) {
        scanner.dismiss(animated: true) {
            if let getPDFScan = self.getPDFScan {
                getPDFScan(results.thumbImage, results.pdfURL)
            }
        }
    }
    
    func imageScannerControllerDidCancel(_ scanner: ImageScannerController) {
        scanner.dismiss(animated: true, completion: nil)
    }
    
}

extension DMScanPDFProvider: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            let scannerViewController = ImageScannerController(image: image, delegate: self)
            guard let vc = focusVC else { return }
            vc.present(scannerViewController, animated: true)
        }
    }
}
