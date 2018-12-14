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
    
    // Unique ID
    let lastUsedID = "lastUsedID"
    
    // CoreData
    let parentIDMatch = "parentID MATCHES %@"
    let parentNameMatch = "parentName MATCHES %@"
    let idMatch = "id MATCHES %@"
    let nameMatch = "name MATCHES %@"
    let categoryMatch = "category MATCHES %@"
    let levelMatch = "level MATCHES %@"
    let idKey = "id"
    
    // To SubItems Segues
    let homeToSubItemsSegue = "homeToSubItemsSegue"
    let errandsToSubItemsSegue = "errandsToSubItemsSegue"
    let workToSubItemsSegue = "workToSubItemsSegue"
    let otherToSubItemsSegue = "otherToSubItemsSegue"
    let subItems1ToSubItems2Segue = "subItems1ToSubItems2Segue"
    let subItems2ToSubItems1Segue = "subItems2ToSubItems1Segue"
    
    // To Edit Name Segues
    let homeToEditSegue = "homeToEditSegue"
    let errandsToEditSegue = "errandsToEditSegue"
    let workToEditSegue = "workToEditSegue"
    let otherToEditSegue = "otherToEditSegue"
    let subItems1ToEditSegue = "subItems1ToEditSegue"
    let subItems2ToEditSegue = "subItems2ToEditSegue"
    
    // To Move Segues
    let homeToMoveSegue = "homeToMoveSegue"
    let errandsToMoveSegue = "errandsToMoveSegue"
    let workToMoveSegue = "workToMoveSegue"
    let otherToMoveSegue = "otherToMoveSegue"
    let subItems1ToMoveSegue = "subItems1ToMoveSegue"
    let subItems2ToMoveSegue = "subItems2ToMoveSegue"
    let moveItem1ToMoveItem2Segue = "moveItem1ToMoveItem2Segue"
    let moveItem2ToMoveItem1Segue = "moveItem2ToMoveItem1Segue"
    let settingsToFontPickerSegue = "settingsToFontPickerSegue"
    
    // Table Cell Identifiers
    let categoryAndItemCellIdentifier = "categoryAndItemCell"
    let headerIdentifier = "headerView"
    
    // Table Cell Nibs
    let categoryAndItemNibName = "CategoryAndItemTableViewCell"
    let headerNibName = "HeaderView"
    
    // Checkbox Images for Table Cells
    let checkboxChecked = UIImage(named: "checkboxChecked")
    let checkboxEmpty = UIImage(named: "checkboxEmpty")
    let blueCheck = UIImage(named: "blueCheck")
    let blueEmptyCheckbox = UIImage(named: "blueEmptyCheckbox")
//    let noCheckBox = UIImage(named: "")
    
    // UIColors for Table Cells
    let lightGreenBackground33 = UIColor(red: 193/255, green: 255/255, blue: 171/255, alpha: 1.0)
    let lightGreenBackground18 = UIColor(red: 220/255, green: 255/255, blue: 208/255, alpha: 1.0)
    let lightGreenBackground12 = UIColor(red: 233/255, green: 255/255, blue: 225/255, alpha: 1.0)
    let lightBlueBackground = UIColor(red: 190/255, green: 219/255, blue: 255/255, alpha: 1.0)
    
}
