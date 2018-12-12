//
//  ValidationModel.swift
//  MyList
//
//  Created by Adam Moore on 12/12/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit

class ValidationModel {
    
    static var shared = ValidationModel()
    private init() {}
    
    var itemNameBeingChecked = String()
    
    var validityStatus: ItemNameCheck = .success
    
    func isValid(itemName: String, forItems items: [Item], isGrouping: Bool, itemsToGroup: [Item]?) -> ItemNameCheck {
        
        var isValidName: ItemNameCheck = .success
        
        itemNameBeingChecked = itemName
        
        // Checks for duplicate name
        if isGrouping {
            
            if let itemsToGroup = itemsToGroup {
                for item in items {
                    if itemsToGroup.contains(item) {
                        continue
                    } else if item.name == itemName {
                        isValidName = .duplicate
                    }
                }
            }

        } else {
            
            for item in items {
                if itemName == item.name {
                    isValidName = .duplicate
                }
            }
            
        }
        
        // Cannot contain three "???"
        var numOfQsInARow = 0
        for a in itemName {
            if a == "?" {
                numOfQsInARow += 1
                if numOfQsInARow > 2 {
                    isValidName = .threeQuestionMarks
                }
            } else {
                numOfQsInARow = 0
            }
        }
        
        // Cannot be blank
        if itemName == "" {
            isValidName = .blank
        }
        
        validityStatus = isValidName
        
        return isValidName
        
    }
    
    func alertForInvalidItem(doSomethingElse: (() -> Void)?) -> UIAlertController {
        
        let invalidMessage = validityStatus.rawValue
        var invalidAlertStyle: UIAlertController.Style = .alert
        
        var invalidTitle: String {
            
            switch validityStatus {
                
            case .duplicate:
                return "Duplicate Item"
            case .blank:
                return "No Item Name"
            case .threeQuestionMarks:
                return "Three '???' were used."
            case .success:
                return "Great! The item name works."
            }
            
        }
        
        let alert = UIAlertController(title: invalidTitle, message: invalidMessage, preferredStyle: invalidAlertStyle)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            if let doSomethingElse = doSomethingElse {
                doSomethingElse()
            }
        }))
        
        return alert
        
    }
    
}
