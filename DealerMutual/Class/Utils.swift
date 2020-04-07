//
//  Utils.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/24/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import Foundation
import PhoneNumberKit
import MBProgressHUD
import UIKit
import Firebase

private let phoneNumberKit = PhoneNumberKit()
private let emailRegEx = "^[_A-Za-z0-9-+]+(\\.[_A-Za-z0-9-+]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9-]+)*(\\.[A-Za-z‌​]{2,4})$"

func validate(phoneNumber: String) -> Bool {
    do {
        _ = try phoneNumberKit.parse(phoneNumber)
        return true
    }
    catch {
       return false
    }
}

func validate(email: String) -> Bool {
    let predicate = NSPredicate(format: "SELF MATCHES %@", emailRegEx)
    return predicate.evaluate(with: email)
}

func showHUD() -> MBProgressHUD {
    let showView = UIApplication.shared.keyWindow ?? UIView()
    let hud = MBProgressHUD.showAdded(to: showView, animated: true)
    return hud
}

func getTopViewController(_ controller: UIViewController?) -> UIViewController? {
    if (controller is UITabBarController) {
        let tabBarController = controller as! UITabBarController
        return getTopViewController(tabBarController.selectedViewController)
    }
    else if (controller is UINavigationController) {
        let navigationController = controller as! UINavigationController
        return getTopViewController(navigationController.visibleViewController)
    }
    else if ((controller!.presentedViewController != nil) && ((controller?.presentedViewController?.isBeingDismissed)! == false)) {
        return getTopViewController(controller?.presentedViewController)
    } else {
        return controller;
    }
}

func createLogo() -> UIBarButtonItem {
    let logoView = UILabel()
    logoView.textColor = .white
    logoView.numberOfLines = 0
    let attributedString = NSMutableAttributedString(string: "DM\n", attributes: [.font : UIFont.systemFont(ofSize: 26, weight: .regular)])
    attributedString.append(NSAttributedString(string: "DealerMutual", attributes: [.font : UIFont.systemFont(ofSize: 6, weight: .regular)]))
    logoView.attributedText = attributedString
    return UIBarButtonItem(customView: logoView)
}

func normalized(image: UIImage) -> UIImage {
    if image.imageOrientation == .up { return image }
    UIGraphicsBeginImageContextWithOptions(image.size, false, image.scale)
    defer {
        UIGraphicsEndImageContext()
    }
    image.draw(in: CGRect(origin: .zero, size: image.size))
    if let normalImage = UIGraphicsGetImageFromCurrentImageContext() {
        return normalImage
    }
    return image
}

func generateBucketKey() -> String? {
    var userID: String
    if let currentUserID = Auth.auth().currentUser?.uid, currentUserID.count > 0  {
        userID = currentUserID
    } else {
        // User might not be logged in
        userID = UUID().uuidString.replacingOccurrences(of: "-", with: "")
    }
    let jpegExtension = ".jpg"
    let placeDirectory = "photos"
    let uuidString = UUID().uuidString
    // guard let uuidString = UUID().uuidString.replacingCharacters(in: "-", with: "")
    return "\(placeDirectory)_\(userID)_\(uuidString)\(jpegExtension)"
}

func shareImageBucketKey() -> String? {
    let currentTimeStr: String = String(format: "%d", (Int)(Date().timeIntervalSince1970))
    let jpegExtension = ".jpg"
    let placeDirectory = "photos"
    // guard let uuidString = UUID().uuidString.replacingCharacters(in: "-", with: "")
    return "\(placeDirectory)_\(currentTimeStr)\(jpegExtension)"
}
