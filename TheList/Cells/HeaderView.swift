//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    // MARK: - DELEGATES
    
    // Delegates called by the ItemModel, set in the CategoryAndItemVC.
    var isValidNameDelegate: IsValidNameDelegate?
    var addNewItemDelegate: AddNewItemDelegate?
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    // General invalid name alert, which should probably be in the 'itemModel'. Is currently set in the CategoryAndItemVC
    var presentInvalidNameAlertDelegate: PresentInvalidNameAlertDelegate?
    
    // Delegate called by the CategoryAndItemVC, set in the same.
    var setEditingModeFromHeaderDelegate: SetEditingModeFromHeaderDelegate?
    
    
    
    var selectedParentID = Int()
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        toggleAddButtonEnabled()
    }
    
    @IBAction func headerTextFieldBecameActive(_ sender: UITextField) {
        setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .adding)
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        addNewItem()
    }
    
    func addNewItem() {
        
        let newItemName = String(headerTextField.text!)
        
        guard let checkNewItemName = isValidNameDelegate?.isValidName(forItemName: newItemName) else { return }
        
        if checkNewItemName == .success {
            
//            setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .adding)
            
            addNewItemDelegate?.addNewItem(itemName: newItemName)
            
            HapticsModel.shared.hapticExecuted(as: .success)
            
            headerTextField.text = ""
            
            toggleAddButtonEnabled()
            
            reloadTableListDelegate?.reloadTableData()
            
        } else {
            
            HapticsModel.shared.hapticExecuted(as: .warning)
            
            presentInvalidNameAlertDelegate?.presentInvalidNameAlert()
            
        }
        
    }
    
    func toggleAddButtonEnabled() {
        addButton.isEnabled = (self.headerTextField.text != "")
    }
    
    
    
    // MARK: - SDK FUNCTIONS
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTextField.delegate = self
        
        toggleAddButtonEnabled()
        
        addToolBarToKeyboard(textField: headerTextField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text == "" {
            textField.resignFirstResponder()
            setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .none)
        } else {
            addNewItem()
        }
        return true
    }
    
}



// MARK: - Toolbar with 'Done' button

extension HeaderView {
    
    @objc func dismissKeyboard() {
        if headerTextField.text == "" {
            headerTextField.resignFirstResponder()
        } else {
            addNewItem()
            headerTextField.resignFirstResponder()
        }
        setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .none)
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
        setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .none)
    }
    func dismissKeyboardFromMainViewController() {
        headerTextField.resignFirstResponder()
        setEditingModeFromHeaderDelegate?.setEditingModeFromHeader(forEditingMode: .none)
    }
    
}












