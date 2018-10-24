//
//  Keywords.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

class Keywords {
    
    private init() {}
    
    static var shared = Keywords()
    
    let parentIDMatch = "parentID MATCHES %@"
    let idMatch = "id MATCHES %@"
    let categoryMatch = "category MATCHES %@"
    let levelMatch = "level MATCHES %@"
    let orderNumberKey = "orderNumber"
    
    let homeToSubItemsSegue = "homeToSubItemsSegue"
    let errandsToSubItemsSegue = "errandsToSubItemsSegue"
    let workToSubItemsSegue = "workToSubItemsSegue"
    let otherToSubItemsSegue = "otherToSubItemsSegue"
    let subItems1ToSubItems2Segue = "subItems1ToSubItems2Segue"
    let subItems2ToSubItems1Segue = "subItems2ToSubItems1Segue"
    let editToCategoryPickerSegue = "editToCategoryPickerSegue"
    let homeToEditSegue = "homeToEditSegue"
    let errandsToEditSegue = "errandsToEditSegue"
    let workToEditSegue = "workToEditSegue"
    let otherToEditSegue = "otherToEditSegue"
    let subItemsToEditSegue = "subItemsToEditSegue"
    let settingsToFontPickerSegue = "settingsToFontPickerSegue"
    
    let categoryAndItemCellIdentifier = "categoryAndItemCell"
    let headerIdentifier = "headerView"
    
    let cellNibName = "CategoryAndItemTableViewCell"
    let headerNibName = "HeaderView"
    
    let checkboxChecked = UIImage(named: "checkboxChecked")
    let checkboxEmpty = UIImage(named: "checkboxEmpty")
    
    let lightGreenBackground33 = UIColor(red: 193/255, green: 255/255, blue: 171/255, alpha: 1.0)
    let lightGreenBackground18 = UIColor(red: 220/255, green: 255/255, blue: 208/255, alpha: 1.0)
    let lightGreenBackground12 = UIColor(red: 233/255, green: 255/255, blue: 225/255, alpha: 1.0)
    
}
