//
//  DMBaseViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/15/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMBaseViewController<T>: UIViewController where T: DMBaseModel {
    var model = T()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func createLabelBarButton(with text: String, subtitle: String? = nil, fontSize: CGFloat = 25) -> UIBarButtonItem {
        let logoView = UILabel()
        logoView.font = UIFont.systemFont(ofSize: fontSize)
        logoView.textColor = .white
        logoView.text = text
        return UIBarButtonItem(customView: logoView)
    }
}

extension UIViewController {
    func showError(_ errorText: String) {
        let controller = UIAlertController(title: "Error", message: errorText, preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { (sender) in
            controller.dismiss(animated: true, completion: nil)
        }))
        self.present(controller, animated: true, completion: nil)
    }
    
}
