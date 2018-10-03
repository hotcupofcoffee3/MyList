//
//  CategoryPickerViewController.swift
//  MyList
//
//  Created by Adam Moore on 9/26/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class CategoryPickerViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBAction func cancel(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var categoryOrItemLabel: UILabel!
    
    @IBOutlet weak var picker: UIPickerView!
    
    @IBAction func submit(_ sender: UIButton) {
        
        let newCategory = categories[picker.selectedRow(inComponent: 0)]
        
        if let itemToUpdate = item {
            DataModel.shared.updateItem(forProperty: .category, forItem: itemToUpdate, category: newCategory.name!, name: itemToUpdate.name!)
        } else {
            print("There was no item set to Update.")
        }
        
        categoryOrItemHasBeenEditedDelegate?.categoryOrItemHasBeenEdited()
        
        dismiss(animated: true, completion: nil)
    }
    
    var item: Item?
    
    var categoryOrItemHasBeenEditedDelegate: CategoryOrItemEditedDelegate?
    
    var categories = [Category]()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        
        let title = NSAttributedString(string: categories[row].name!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let itemBeingEdited = item else { return print("No item selected in the viewDidLoad in the Edit Picker.") }
        for i in categories.indices {
            if categories[i].name! == itemBeingEdited.category {
                picker.selectRow(i, inComponent: 0, animated: true)
            }
        }
    }
    
}
