//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var addNewItemDelegate: AddNewItemDelegate?
    
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    var checkForInvalidNameDelegate: CheckForInvalidNameDelegate?
    
    var hapticDelegate: HapticDelegate?
    
    var selectedParentID = Int()
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        
        toggleAddButtonEnabled()
        
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        addNewItem()
        
    }
    
    func addNewItem() {
        
        if ((addNewItemDelegate?.addNewItem(itemName: String(headerTextField.text!)))!) {
            
            hapticDelegate?.hapticExecuted(as: .success)
            
            headerTextField.text = ""
            
            toggleAddButtonEnabled()
            
            reloadTableListDelegate?.reloadTableData()
            
        } else {
            
            hapticDelegate?.hapticExecuted(as: .warning)
            
            checkForInvalidNameDelegate?.presentInvalidNameAlert()
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.resignFirstResponder()
        } else {
            addNewItem()
        }
        return true
    }
    
    func toggleAddButtonEnabled() {
        addButton.isEnabled = (self.headerTextField.text != "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTextField.delegate = self
        
        toggleAddButtonEnabled()
        
        addToolBarToKeyboard(textField: headerTextField)
        
    }
    
    // MARK: - Toolbar with 'Done' button
    
    @objc func dismissKeyboard() {
        if headerTextField.text == "" {
            headerTextField.resignFirstResponder()
        } else {
            addNewItem()
            headerTextField.resignFirstResponder()
        }
    }
    
    func addToolBarToKeyboard(textField: UITextField) {
        
        let toolbar = UIToolbar()
        //        toolbar.barTintColor = UIColor.black
        
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(self.dismissKeyboard))
        
        //        doneButton.tintColor = UIColor.white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        
    }
    
}














