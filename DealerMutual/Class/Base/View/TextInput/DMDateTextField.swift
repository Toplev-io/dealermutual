//
//  DMDateTextField.swift
//  DealerMutual
//
//  Created by sasha dovbnya on 9/17/18.
//  Copyright © 2018 sasha dovbnya. All rights reserved.
//

import UIKit

class DMDateTextField: DMItemTextField {

    // MARK: - Properties
    
    private let toolBar: UIToolbar = {
        let toolBar = UIToolbar()
        let doneBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneBarButtonItemPressed(sender:)))
        let cancelBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelBarButtonItemPressed(sender:)))
        let flexibleBarButtonItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        toolBar.items = [cancelBarButtonItem, flexibleBarButtonItem, doneBarButtonItem]
        return toolBar
    }()
    
    private let datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.setDate(Date(), animated: true)
        return datePicker
    }()
    
    private let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
    
    private var previousSelectedDate = Date()
    var onChangeDate: ((Date) -> Void)?
    
    // MARK: Public Methods
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUp()
    }
    
    public func set(date: Date) {
        previousSelectedDate = date
        text = dateFormatter.string(from: date)
        datePicker.setDate(date, animated: true)
    }
    
    public func get() -> Date {
        return previousSelectedDate
    }
    
    // MARK: - Actions
    
    @objc private func doneBarButtonItemPressed(sender: UIBarButtonItem) {
        resignFirstResponder()
        previousSelectedDate = datePicker.date
        text = dateFormatter.string(from: previousSelectedDate)
        onChangeDate?(previousSelectedDate)
    }
    
    @objc private func cancelBarButtonItemPressed(sender: UIBarButtonItem) {
        resignFirstResponder()
    }
    
    // MARK: - Initialization
    
    private func setUp() {
        inputView = datePicker
        toolBar.sizeToFit()
        inputAccessoryView = toolBar
        text = dateFormatter.string(from: previousSelectedDate)
        delegate = self
        tintColor = .clear
    }
    
    override func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}

extension DMDateTextField {
    
    public func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        datePicker.setDate(previousSelectedDate, animated: true)
        return true
    }
}
