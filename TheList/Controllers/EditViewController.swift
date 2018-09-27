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

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryPickerViewController
        if typeBeingEdited != .items {
            destinationVC.categories = DataModel.shared.loadSpecificCategories(perType: typeBeingEdited.rawValue)
        }
        
    }
    
}
