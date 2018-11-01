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
    
    @IBOutlet weak var categoryTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var parentLabel: UILabel!
    
    @IBOutlet weak var parentView: UIView!
    
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
        parentLabel.text = ""
        
        categoryTopConstraint.constant = 30
        categoryHeightConstraint.constant = 60
        
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryPicker))
        parentView.addGestureRecognizer(categoryTap)
    }
    
    @objc func categoryPicker() {
        performSegue(withIdentifier: Keywords.shared.editToCategoryPickerSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryPickerViewController
        
        if let currentItem = item {
            
            destinationVC.item = currentItem
            destinationVC.itemHasBeenEditedDelegate = self
            
        } else {
            print("There was no item set in the Edit VC.")
        }
        
    }
    
}

extension EditViewController: ItemEditedDelegate {
    
    func itemHasBeenEdited() {
        
        if let currentItem = item {
            
            parentLabel.text = String(currentItem.parentID)
            
        }
       
    }
    
}
