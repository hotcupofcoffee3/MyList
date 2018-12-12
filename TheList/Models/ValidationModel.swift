//
//  ValidationModel.swift
//  MyList
//
//  Created by Adam Moore on 12/12/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation

class ValidationModel {
    
    static var shared = ValidationModel()
    private init() {}
    
    func isValid(itemName: String, forItems items: [Item]) -> ItemNameCheck {
        
        var isValidName: ItemNameCheck = .success
        
        // Checks for duplicate name
        for item in items {
            if itemName == item.name {
                isValidName = .duplicate
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
        
        return isValidName
        
    }
    
}
