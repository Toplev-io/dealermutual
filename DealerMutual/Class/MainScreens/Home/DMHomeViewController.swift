//
//  DMHomeViewController.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/16/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit
import Firebase

class DMHomeViewController: DMBaseMainViewController<DMHomeModel>, DMSettingInterface, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var headerView: DMHomeSearchHeader!
    @IBOutlet weak var segmentView: UISegmentedControl!
    @IBOutlet weak var topLayout: NSLayoutConstraint!
    
    @IBOutlet weak var customDateContainer: UIView!
    @IBOutlet weak var fromDateTextField: DMDateTextField!
    @IBOutlet weak var toTextField: DMDateTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let settingButton = createSettingBarButton()
        //let filterButton = UIBarButtonItem(image: #imageLiteral(resourceName: "filterIcon"), style: .plain, target: self, action: #selector(self.onFilterPress))
        navigationItem.rightBarButtonItems = [settingButton]
        headerView.delegete = model
        customDateContainer.isHidden = true
        switch model.type {
        case .dealer(_):
            print("t")
            topLayout.constant = -48
        default: break
        }
        fromDateTextField.onChangeDate = onChange(date:)
        toTextField.onChangeDate = onChange(date:)
        
        
    }

    
    func showSetting(_ sender: UIBarButtonItem) {
        wrapShowSetting(sender)
    }
    
    @IBAction func didChangeDateFilter(_ sender: UISegmentedControl) {
        updateFilter()
    }
    
    @objc func onFilterPress() {
        self.headerView.setVisible(state: !self.headerView.isShow)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return .none
    }
    
    func onChange(date: Date) {
        updateFilter()
    }
    
    private func updateFilter() {
        let custom: DMDateFilter = DMDateFilter.customDate(from: fromDateTextField.get(), to:toTextField.get())
        customDateContainer.isHidden = custom.intValue != segmentView.selectedSegmentIndex
        switch segmentView.selectedSegmentIndex {
        case DMDateFilter.all.intValue: model.selectedDateFilter = .all
        case DMDateFilter.week.intValue: model.selectedDateFilter = .week
        case DMDateFilter.day.intValue: model.selectedDateFilter = .day
        case DMDateFilter.month.intValue: model.selectedDateFilter = .month
        case custom.intValue:
            model.selectedDateFilter = custom
        default: break
        }
    }
}
