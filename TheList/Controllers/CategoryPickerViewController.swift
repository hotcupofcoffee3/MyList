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
        
    }
    
}
