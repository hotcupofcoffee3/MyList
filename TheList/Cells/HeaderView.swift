//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    // Delegates called by the ItemModel, set in the CategoryAndItemVC.
    var isValidNameDelegate: IsValidNameDelegate?
    var addNewItemDelegate: AddNewItemDelegate?
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    // General invalid name alert, which should probably be in the 'itemModel'. Is currently set in the CategoryAndItemVC
    var presentInvalidNameAlertDelegate: PresentInvalidNameAlertDelegate?
    
    // Delegates called by the CategoryAndItemVC, set in the same.
    var textFieldIsActiveDelegate: TextFieldIsActiveDelegate?
    var textFieldIsSubmittedDelegate: TextFieldIsSubmittedDelegate?
    var setEditingModeForDismissingKeyboardDelegate: SetEditingModeForDismissingKeyboardDelegate?
    
    var hapticDelegate: HapticDelegate?
    
    var selectedParentID = Int()
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        toggleAddButtonEnabled()
    }
    
    @IBAction func headerTextFieldBecameActive(_ sender: UITextField) {
        textFieldIsActiveDelegate?.textFieldIsActive()
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addNewItem()
    }
    
    func addNewItem() {
        
        let newItemName = String(headerTextField.text!)
        
        guard let checkNewItemName = isValidNameDelegate?.isValidName(forItemName: newItemName) else { return }
        
        if checkNewItemName == .success {
            
            textFieldIsSubmittedDelegate?.textFieldIsSubmitted()
            
            setEditingModeForDismissingKeyboardDelegate?.setEditingModeForDismissingKeyboard()
            
            addNewItemDelegate?.addNewItem(itemName: newItemName)
            
            hapticDelegate?.hapticExecuted(as: .success)
            
            headerTextField.text = ""
            
            toggleAddButtonEnabled()
            
            reloadTableListDelegate?.reloadTableData()
            
        } else {
            
            hapticDelegate?.hapticExecuted(as: .warning)
            
            presentInvalidNameAlertDelegate?.presentInvalidNameAlert(withErrorMessage: checkNewItemName)
            
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
        setEditingModeForDismissingKeyboardDelegate?.setEditingModeForDismissingKeyboard()
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

extension HeaderView: TouchedAwayFromTextFieldDelegate, DismissKeyboardFromMainViewControllerDelegate {
    
    // Delegates used by the CategoryAndItemVC
    func touchedAwayFromTextField() {
        headerTextField.resignFirstResponder()
        setEditingModeForDismissingKeyboardDelegate?.setEditingModeForDismissingKeyboard()
    }
    func dismissKeyboardFromMainViewController() {
        headerTextField.resignFirstResponder()
    }
    
}












