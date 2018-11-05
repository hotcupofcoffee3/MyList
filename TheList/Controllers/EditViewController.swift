//
//  EditViewController.swift
//  MyList
//
//  Created by Adam Moore on 9/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var selectedCategory = SelectedCategory.home
    
    var nameToEdit = String()
    
    var item: Item?
    
    var level = Int()
    
    var editingCompleteDelegate: EditingCompleteDelegate?
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func submit(_ sender: UIButton) {
        
        if nameTextField.text != "" {
            
            if let item = item {
                DataModel.shared.updateItem(forProperty: .name, forItem: item, parentID: Int(item.parentID), parentName: item.parentName!, name: nameTextField.text!)
            }
            
            editingCompleteDelegate?.editingComplete()
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = nameToEdit
        
    }
    
    
}
