//
//  DMHomeSearchHeader.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/21/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import DLRadioButton

protocol DMHomeSearchHeaderDelegate: class {
    func didChangeSearch(status: DMHomeModelTypeItem)
}

class DMHomeSearchHeader: UIView {

    @IBOutlet weak var showOnlineButton: UIButton!
    @IBOutlet weak var solisticButton: DLRadioButton!
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    weak var delegete: DMHomeSearchHeaderDelegate?
    
    var isShow: Bool = false {
        didSet {
            updateVisibleState()
        }
    }
    
    func setVisible(state: Bool) {
        isShow = state
        UIView.animate(withDuration: 0.3) {
             self.superview?.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateVisibleState()
        layoutIfNeeded()
    }
    
    private func updateVisibleState() {
        let newConstant = isShow ? 0 : -bounds.height
        if topContraint.constant != newConstant {
            topContraint.constant = newConstant
        }
    }

    @IBAction func onTypeButtonPressed(_ sender: DLRadioButton) {
        showOnlineButton.isHidden = sender.tag != 3
        UIView.animate(withDuration: 0.3) {
            self.superview?.layoutIfNeeded()
        }
        didChangeType()
    }
    
    @IBAction func onOnlineButtonPressed(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        didChangeType()
    }
    
    private func didChangeType() {
        guard let selectButton = solisticButton.selected() else { return }
        switch selectButton.tag {
        case 0:
            delegete?.didChangeSearch(status: .solicit)
        case 1:
            delegete?.didChangeSearch(status: .sale)
        case 2:
            delegete?.didChangeSearch(status: .demo)
        case 3:
            delegete?.didChangeSearch(status: .dealer(isOnline: showOnlineButton.isSelected))
        default:
            break
        }
    }
}
