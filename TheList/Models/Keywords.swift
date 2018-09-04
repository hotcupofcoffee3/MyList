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
    
    let homeToItemsSegue = "homeToItemsSegue"
    let errandsToItemsSegue = "errandsToItemsSegue"
    let workToItemsSegue = "workToItemsSegue"
    let funToItemsSegue = "funToItemsSegue"
    let ideasToItemsSegue = "ideasToItemsSegue"
    
    let categoryAndItemCellIdentifier = "categoryAndItemCell"
    
    let cellNibName = "CategoryAndItemTableViewCell"
    
}
