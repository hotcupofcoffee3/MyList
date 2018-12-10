//
//  ItemModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit



// The Main Item model for the TableViews

class ItemModel {
    
    // The items that are loaded
    
    var items = [Item]()
    
    var selectedParentID = Int()
    
    var selectedParentName = String()
    
    func reloadItems() {
        items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level, forParentID: selectedParentID, andParentName: selectedParentName, ascending: true)
    }
    
    
    
    // Called in viewDidLoad with VC's title to set the TableView & Type of Segue.
    
    // TableView is used for the reloading of the table data in the delegates.
    var table: UITableView?
    
    var selectedCategory = SelectedCategory.home
    
    var currentView = SelectedCategory.home
    
    var level = Int()
    
    var subItemsNumber = 0
    
    var selectedItem: Item?
    
    func setViewDisplayed(tableView: UITableView, selectedCategory category: String, level: Int) {
        
        if level == 1 {
            
            switch category {
                
            case SelectedCategory.home.rawValue: selectedParentID = 1
            case SelectedCategory.errands.rawValue: selectedParentID = 2
            case SelectedCategory.work.rawValue: selectedParentID = 3
            case SelectedCategory.other.rawValue: selectedParentID = 4
            default: break
                
            }
            
            selectedParentName = category
            
        }
        
        self.table = tableView
        
        self.level = level
        
        switch category {
            
        case SelectedCategory.home.rawValue:
            selectedCategory = .home
            currentView = .home
            
        case SelectedCategory.errands.rawValue:
            selectedCategory = .errands
            currentView = .errands
            
        case SelectedCategory.work.rawValue:
            selectedCategory = .work
            currentView = .work
            
        case SelectedCategory.other.rawValue:
            selectedCategory = .other
            currentView = .other
            
        case SelectedCategory.subItems1.rawValue:
            currentView = .subItems1
            
        case SelectedCategory.subItems2.rawValue:
            currentView = .subItems2
            
        default: print("There was no 'view' set that matched anything.")
            
        }
        
        reloadItems()
        
    }
    
    var typeOfSegue: String {
        
        switch currentView {
            
        case .home:
            return Keywords.shared.homeToSubItemsSegue
            
        case .errands:
            return Keywords.shared.errandsToSubItemsSegue
            
        case .work:
            return Keywords.shared.workToSubItemsSegue
            
        case .other:
            return Keywords.shared.otherToSubItemsSegue
         
        case .subItems1:
            return Keywords.shared.subItems1ToSubItems2Segue
            
        case .subItems2:
            return Keywords.shared.subItems2ToSubItems1Segue
            
        default: return "Type of Segue was not set because it was the 0 Category one."
            
        }
        
    }
    
    var editSegue: String {
        
        switch currentView {
            
        case .home:
            return Keywords.shared.homeToEditSegue
            
        case .errands:
            return Keywords.shared.errandsToEditSegue
            
        case .work:
            return Keywords.shared.workToEditSegue
            
        case .other:
            return Keywords.shared.otherToEditSegue
            
        case .subItems1:
            return Keywords.shared.subItems1ToEditSegue
                
        case .subItems2:
            return Keywords.shared.subItems2ToEditSegue
            
        default: return "Edit Segue was not set because it was the 0 Category one."
            
        }
        
    }
    
    var moveSegue: String {
        
        switch currentView {
            
        case .home:
            return Keywords.shared.homeToMoveSegue
            
        case .errands:
            return Keywords.shared.errandsToMoveSegue
            
        case .work:
            return Keywords.shared.workToMoveSegue
            
        case .other:
            return Keywords.shared.otherToMoveSegue
            
        case .subItems1:
            return Keywords.shared.subItems1ToMoveSegue
            
        case .subItems2:
            return Keywords.shared.subItems2ToMoveSegue
            
        default: return "Move Segue was not set because it was the 0 Category one."
            
        }
        
    }
    
    func numberOfSubItems(forParentID parentID: Int, andParentName parentName: String) -> Int {
        
//        var totalNumberOfSubItems = Int()
//
//        let subItems = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level + 1, forParentID: parentID, andParentName: parentName)
//
//        if subItems.count > 0 {
//
//            for subItem in subItems {
//
//                let furtherSubItems = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: Int(subItem.level + 1), forParentID: Int(subItem.id), andParentName: subItem.name!)
//
//                if furtherSubItems.count > 0 {
//
//                    totalNumberOfSubItems += numberOfItems(forParentID: Int(subItem.id), andParentName: subItem.name!)
//
//                } else {
//
//                    totalNumberOfSubItems += 1
//
//                }
//
//            }
//
//        }
//
//        return totalNumberOfSubItems
        
        return DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level + 1, forParentID: parentID, andParentName: parentName, ascending: true).count
        
    }
    
    func numberOfItemsDone(forParentID parentID: Int, andParentName parentName: String) -> Int {
        var numberDone = Int()
        let items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level + 1, forParentID: parentID, andParentName: parentName, ascending: true)
        for item in items {
            numberDone += item.done ? 1 : 0
        }
        return numberDone
    }
    
    func getItemType(item: Item) -> SelectedCategory {
        
        var itemType = SelectedCategory.home
        
        switch item.category! {
            
        case SelectedCategory.home.rawValue: itemType = .home
        case SelectedCategory.errands.rawValue: itemType = .errands
        case SelectedCategory.work.rawValue: itemType = .work
        case SelectedCategory.other.rawValue: itemType = .other
        default: break
            
        }
        
        return itemType
        
    }
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension ItemModel: IsValidNameDelegate, AddNewItemDelegate, ReloadTableListDelegate {
    
    func isValidName(forItemName itemName: String) -> ItemNameCheck {
        
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
    
    func addNewItem(itemName: String) {
        DataModel.shared.addNewItem(name: itemName, forCategory: selectedCategory, level: level, parentID: selectedParentID, parentName: selectedParentName)
        items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level, forParentID: selectedParentID, andParentName: selectedParentName, ascending: true)
        reloadItems()
    }
    
    func reloadTableData() {
        if let table = table {
            table.reloadData()
        } else {
            print("There was no table loaded from Model delegate.")
        }
    }
    
}








