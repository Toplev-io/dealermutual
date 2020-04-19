//
//  DMSelectItemViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 12/27/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

enum DMSelectItemType: Int {
    case dealer = 0
    case solicit = 1
    case sale = 2
    case demo = 3
    
    var type: DMHomeModelTypeItem {
        switch self {
        case .dealer:
            return .dealer(isOnline: true)
        case .solicit:
            return .solicit
        case .sale:
            return .sale
        case .demo:
            return .demo
        }
    }
    
    var icon: UIImage {
        switch self {
        case .dealer:
            return #imageLiteral(resourceName: "dealer")
        case .demo:
            return #imageLiteral(resourceName: "demo")
        case .sale:
            return #imageLiteral(resourceName: "sale")
        case .solicit:
            return #imageLiteral(resourceName: "solicit")
        }
    }
    
    var title: String {
        switch self {
        case .dealer:
            return "Dealer"
        case .solicit:
            return "Solicit"
        case .sale:
            return "Sale"
        case .demo:
            return "Demo"
        }
    }
}

@objc protocol DMSettingInterface {
    @objc func showSetting(_ sender: UIBarButtonItem)
    @objc func showScanning(_ sender: UIBarButtonItem)
}

extension DMSettingInterface where Self: UIViewController {
    
    func createSettingBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "settings"), style: .plain, target: self, action: #selector(Self.showSetting(_:)))
        
    }
    
    func createScanningBarButton() -> UIBarButtonItem {
        return UIBarButtonItem(image: #imageLiteral(resourceName: "pdf_scan_icon"), style: .plain, target: self, action: #selector(Self.showScanning(_:)))
        
    }

    func wrapShowSetting(_ sender: UIBarButtonItem) {
        guard let popController = self.storyboard?.instantiateViewController(withIdentifier: "DMSettingPopover") else { return }
        let navigationController = createNavigationPopover(with: popController)
        navigationController.popoverPresentationController?.barButtonItem = sender
        // present the popover
        self.present(navigationController, animated: true, completion: nil)
    }
    
    func wrapShowScaning(_ vc: UIViewController) {
        let showListVC = ShowListViewController()
        showListVC.getPDFScan = { image, pdfUrl, pages in
            print("got image")
            
            guard let bucketImageKey  = shareImageBucketKey() else {
                return
            }
            let hud = showHUD()
            DMUploadManager.shared.uploadImage(image, usingKey: bucketImageKey) { [weak self] (metadata, error) in
                guard let strongSelf = self else {
                    hud.hide(animated: true)
                    return
                }
                if let error = error {
                    hud.hide(animated: true)
                    strongSelf.showAlert(error.localizedDescription)
                    return
                }
                
                guard let metadata = metadata else {
                    hud.hide(animated: true)
                    strongSelf.showAlert("No photo upload metadata available")
                    return
                }

                guard let photoURL = metadata.path else {
                    hud.hide(animated: true)
                    strongSelf.showAlert("Could not upload photo")
                    return
                }
                
                guard let bucketKey  = sharePDFBucketKey() else {
                    return
                }
                DMUploadManager.shared.uploadPDF(pdfUrl, usingKey: bucketKey) { [weak self] (pdfURL, error) in
                    
                    guard let strongSelf = self else {
                        hud.hide(animated: true)
                        return }
                    if let error = error {
                        hud.hide(animated: true)
                      strongSelf.showAlert(error.localizedDescription)
                        return
                    }
                    let pdfFile = DMPDFScanningFile.init(JSON: ["pdfURL": pdfURL ?? "", "imageUrl": photoURL, "pages": pages ])
                    DMDatabaseManager.shared.addPDFScanningFile (pdfFile!) { [weak self] (share, error) in
                        hud.hide(animated: true)
                        guard self != nil else { return }
                        if let error = error {
                            print(error.localizedDescription)
                            return
                        }
                        print("uploaded successfully")
                    }
                }
            }
        }
        vc.navigationController?.pushViewController(showListVC, animated: true)
    }
    func showAlert(_ title: String, message: String? = nil, actionTitle: String = "OK", completionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: actionTitle, style: .default) { (action) in
            completionHandler?()
        }
        alert.addAction(defaultAction)
        present(alert, animated: true, completion: nil)
    }
    
    func createNavigationPopover(with rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.barTintColor = .white
        navigationController.navigationBar.tintColor = #colorLiteral(red: 0.1882352941, green: 0.1882352941, blue: 0.1882352941, alpha: 1)
        navigationController.navigationBar.titleTextAttributes = [.font : UIFont.systemFont(ofSize: 20, weight: .semibold)]
        // set the presentation style
        navigationController.modalPresentationStyle = .popover
        // set up the popover presentation controller
        navigationController.popoverPresentationController?.backgroundColor = rootViewController.view.backgroundColor
        navigationController.popoverPresentationController?.permittedArrowDirections = .up
        navigationController.popoverPresentationController?.delegate = self as? UIPopoverPresentationControllerDelegate
        return navigationController
    }
}



class DMSelectItemViewController: DMBaseViewController<DMSelectItemModel>, DMSettingInterface, UIPopoverPresentationControllerDelegate {
    @IBOutlet var itemViews: [DMSelectItemView]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = createLogo()
        for (index, view) in itemViews.enumerated() {
            let gesture = UITapGestureRecognizer(target: self, action: #selector(self.onTapSelect(gesture:)))
            view.addGestureRecognizer(gesture)
            let type = DMSelectItemType(rawValue: index)
            view.labelView.text = type?.title
            view.iconView.image = type?.icon
            view.tag = index
        }
        self.model = DMSelectItemModel()
        model.selectViewController = self
        model.getUsers()
        model.getItems(type: DMSale.self)
        model.getItems(type: DMDemo.self)
        model.getItems(type: DMSolicit.self)
        
        let settingButton = createSettingBarButton()
        let scaningButton = createScanningBarButton()
        navigationItem.rightBarButtonItems = [settingButton, scaningButton]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc func onTapSelect(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view,
            let type = DMSelectItemType(rawValue: view.tag)?.type else { return }
        showHomeScreen(with: type)
    }
    
    func showSetting(_ sender: UIBarButtonItem) {
        wrapShowSetting(sender)
    }
    
    func showScanning(_ sender: UIBarButtonItem) {
        wrapShowScaning(self)
    }
    
    func showHomeScreen(with type: DMHomeModelTypeItem) {
        guard let contoller = storyboard?.instantiateViewController(withIdentifier: "DMHomeViewController") as? DMHomeViewController else { return }
        contoller.model.didChangeSearch(status: type)
        navigationController?.pushViewController(contoller, animated: true)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
}
