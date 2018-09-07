//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var addCategoryDelegate: AddNewCategoryDelegate?
    
    var addItemDelegate: AddNewItemDelegate?
    
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        
        toggleAddButtonEnabled()
        
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        addCategory()
        
    }
    
    func addCategory() {
        
        addCategoryDelegate?.addNewCategory(category: headerTextField.text!)
        
        headerTextField.text = ""
        
        headerTextField.endEditing(true)
        
        toggleAddButtonEnabled()
        
        reloadTableListDelegate?.reloadTableData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        addCategory()
        return true
    }
    
    func toggleAddButtonEnabled() {
        addButton.isEnabled = (self.headerTextField.text != "")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.headerTextField.delegate = self
        
        toggleAddButtonEnabled()
        
    }
    
}
