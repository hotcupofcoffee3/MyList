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
    
    func reloadItems() {
        items = DataModel.shared.loadSpecificItems(forParentID: selectedParentID, ascending: false)
    }
    
    
    
    // Called in viewDidLoad with VC's title to set the TableView & Type of Segue.
    
    // TableView is used for the reloading of the table data in the delegates.
    var table: UITableView?
    
    var selectedView = SelectedView.home
    
    var subItemsNumber = 0
    
    var selectedItem: Item?
    
    func setViewDisplayed(tableView: UITableView, selectedView view: String) {
        
        self.table = tableView
        
        switch view {
            
        case SelectedView.home.rawValue:
            selectedView = .home
            selectedParentID = 1
            
        case SelectedView.errands.rawValue:
            selectedView = .errands
            selectedParentID = 2
            
        case SelectedView.work.rawValue:
            selectedView = .work
            selectedParentID = 3
            
        case SelectedView.other.rawValue:
            selectedView = .other
            selectedParentID = 4
            
        case SelectedView.subItems1.rawValue:
            selectedView = .subItems1
            
        case SelectedView.subItems2.rawValue:
            selectedView = .subItems2
            
        case SelectedView.move1.rawValue:
            selectedView = .move1
            
        case SelectedView.move2.rawValue:
            selectedView = .move2
            
        default:
            print("There was some other String sent to the 'setViewDisplayed()' function in the ItemModel.")
            
        }
        
        reloadItems()
        
    }
    
    var typeOfSegue: String {
        
        switch selectedView {
            
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
            
        case .move1:
            return Keywords.shared.move1ToMove2Segue
            
        case .move2:
            return Keywords.shared.move2ToMove1Segue
            
        }
        
    }
    
    var editSegue: String {
        
        switch selectedView {
            
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
        
        switch selectedView {
            
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
    
    func numberOfSubItems(forParentID parentID: Int) -> Int {
        return DataModel.shared.loadSpecificItems(forParentID: parentID, ascending: true).count
    }
    
    func numberOfItemsDone(forParentID parentID: Int) -> Int {
        var numberDone = Int()
        let items = DataModel.shared.loadSpecificItems(forParentID: parentID, ascending: true)
        for item in items {
            numberDone += item.done ? 1 : 0
        }
        return numberDone
    }
    
    // func sortItemsByOrderNumber
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension ItemModel: IsValidNameDelegate, AddNewItemDelegate, ReloadTableListDelegate {
    
    // All of these three are header-specific delegates, set in the CategoryAndItemVC.
    
    func isValidName(forItemName itemName: String) -> ItemNameCheck {
        // As the HeaderView does not have any 'items' in it, since it is only used for adding new items to the existing displayed table, this delegate is used so only the 'itemName' is supplied and is checked against the 'items' already loaded in the 'ItemModel'
        return ValidationModel.shared.isValid(itemName: itemName)
    }
    
    func addNewItem(itemName: String) {
        DataModel.shared.addNewItem(name: itemName, parentID: selectedParentID)
        items = DataModel.shared.loadSpecificItems(forParentID: selectedParentID, ascending: true)
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








