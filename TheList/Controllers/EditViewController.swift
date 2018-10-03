//
//  EditViewController.swift
//  MyList
//
//  Created by Adam Moore on 9/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class EditViewController: UIViewController {
    
    var typeBeingEdited = ChosenVC.home
    
    var nameToEdit = String()
    
    var categoryToEdit = String()
    
    var categoryType = ChosenVC.home
    
    var item: Item?
    
    var category: Category?
    
    @IBOutlet weak var categoryTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var categoryHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var categoryView: UIView!
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func submit(_ sender: UIButton) {
        
        if nameTextField.text != "" {
            
            if typeBeingEdited != .items {
                
                if let category = category {
                    DataModel.shared.updateCategory(forProperty: .name, forCategory: category, name: nameTextField.text!, type: typeBeingEdited)
                }
                
            } else {
                
                if let item = item {
                    DataModel.shared.updateItem(forProperty: .name, forItem: item, category: nil, name: nameTextField.text!)
                }
                
            }
            
            dismiss(animated: true, completion: nil)
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.text = nameToEdit
        categoryLabel.text = categoryToEdit
        if typeBeingEdited == .items {
            categoryTopConstraint.constant = 30
            categoryHeightConstraint.constant = 60
        } else {
            categoryTopConstraint.constant = 0
            categoryHeightConstraint.constant = 0
        }
        
        let categoryTap = UITapGestureRecognizer(target: self, action: #selector(categoryPicker))
        categoryView.addGestureRecognizer(categoryTap)
    }
    
    @objc func categoryPicker() {
        performSegue(withIdentifier: Keywords.shared.editToCategoryPickerSegue, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryPickerViewController
        if typeBeingEdited == .items {
            
            if let currentItem = item {
                destinationVC.categories = DataModel.shared.loadSpecificCategories(perType: currentItem.type!)
                destinationVC.item = currentItem
            } else {
                print("There was no item set in the Edit VC.")
            }
            
        }
        
    }
    
}
