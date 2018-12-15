//
//  EditViewController.swift
//  MyList
//
//  Created by Adam Moore on 9/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UITextFieldDelegate {
    
    var selectedView = SelectedView.home
    
    var nameToEdit = String()
    
    var item: Item?
    
    var editingCompleteDelegate: EditingCompleteDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func changeName() {
        
        if nameTextField.text != "" {
            
            if let item = item {
                DataModel.shared.updateItem(forProperties: [.name], forItem: item, withNewParentID: nil, withNewName: nameTextField.text!, withNewOrderNumber: nil)
            }
            
            editingCompleteDelegate?.editingComplete()
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }

    @IBAction func submit(_ sender: UIButton) {
        
        changeName()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = nameToEdit
        nameTextField.delegate = self
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        changeName()
        
        return true
        
    }
    
}
