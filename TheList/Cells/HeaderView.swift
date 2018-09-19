//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var addCategoryOrItemDelegate: AddNewCategoryOrItemDelegate?
    
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    var checkForNameDuplicateDelegate: CheckForNameDuplicationDelegate?
    
    var hapticDelegate: HapticDelegate?
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        
        toggleAddButtonEnabled()
        
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        addCategoryOrItem()
        
    }
    
    func addCategoryOrItem() {
        
        if (addCategoryOrItemDelegate?.addNewCategoryOrItem(categoryOrItem: headerTextField.text!))! {
            
            hapticDelegate?.hapticExecuted(as: .success)
            
            headerTextField.text = ""
            
//            headerTextField.endEditing(true)
            
            toggleAddButtonEnabled()
            
            reloadTableListDelegate?.reloadTableData()
            
        } else {
            
            hapticDelegate?.hapticExecuted(as: .warning)
            
            checkForNameDuplicateDelegate?.presentDuplicateNameAlert()
            
//            headerTextField.text = ""
//            
//            headerTextField.endEditing(true)
//            
//            toggleAddButtonEnabled()
//            
//            reloadTableListDelegate?.reloadTableData()
            
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.resignFirstResponder()
        } else {
            addCategoryOrItem()
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
            addCategoryOrItem()
            headerTextField.resignFirstResponder()
        }
    }
    
    func addToolBarToKeyboard(textField: UITextField) {
        
        let toolbar = UIToolbar()
        //        toolbar.barTintColor = UIColor.black
        
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.done, target: self, action: #selector(self.dismissKeyboard))
        
        //        doneButton.tintColor = UIColor.white
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexibleSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        
    }
    
}














