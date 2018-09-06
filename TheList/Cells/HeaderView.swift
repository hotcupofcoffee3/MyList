//
//  HeaderView.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class HeaderView: UITableViewHeaderFooterView, UITextFieldDelegate {
    
    var addItemDelegate: AddNewItemDelegate?
    
    var reloadTableListDelegate: ReloadTableListDelegate?
    
    @IBOutlet weak var mainView: UIView!
    
    @IBOutlet weak var headerTextField: UITextField!
    
    @IBAction func headerTextChanged(_ sender: UITextField) {
        
        toggleAddButtonEnabled()
        
    }
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func addButtonPressed(_ sender: UIButton) {
        
        doSomething()
        
    }
    
    func doSomething() {
        
        addItemDelegate?.addNewItem(item: headerTextField.text!)
        
        headerTextField.text = ""
        
        headerTextField.endEditing(true)
        
        toggleAddButtonEnabled()
        
        reloadTableListDelegate?.reloadTableData()
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        doSomething()
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
