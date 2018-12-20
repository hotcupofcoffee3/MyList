//
//  AlertModel.swift
//  MyList
//
//  Created by Adam Moore on 12/20/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

class AlertModel {
    
    // rename
    let renameAlertAction = UIAlertAction(title: "Rename", style: .default) { (action) in
        
        // Rename
        
    }
    
    let renameItemSwipeAction = UITableViewRowAction(style: .default, title: "Rename") { (action, indexPath) in
        
        // Rename Item Swipe Action
        
    }
    
    // move
    let moveSingleItemAlertAction = UIAlertAction(title: "Move", style: .default) { (action) in
        
        // Move Single Item
        
    }
    
    let moveMultipleItemsAlertAction = UIAlertAction(title: "Move Items", style: .default) { (action) in
        
        // Move Single Item
        
    }
    
    
    // group
    let groupAlertAction = UIAlertAction(title: "Group Items", style: .default) { (action) in
        
        // Group
        
    }
    
    // delete
    let deleteSingleItemAlertAction = UIAlertAction(title: "Delete Item", style: .destructive) { (action) in
        
        // Delete Single Item Action Sheet
        
    }
    
    let deleteSingleItemSwipeAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
        
        // Delete Single Item Swipe Action
        
    }
    
    
    
    
    
    // deleteSubItems
    func deleteSubItemsCaution() {
        
    }
    
    func deleteSubItemsAlert() {
        //
    }
    
    
}
