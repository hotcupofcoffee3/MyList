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
        items = DataModel.shared.loadSpecificItems(forParentID: selectedParentID)
    }
    
    
    
    // Called in viewDidLoad with VC's title to set the TableView & Type of Segue.
    
    // TableView is used for the reloading of the table data in the delegates.
    var table: UITableView?
    
    var selectedCategory = SelectedCategory.home
    
    var level = Int()
    
    func setViewDisplayed(tableView: UITableView, viewTitle: String, level: Int, withParentID: Int?) {
        
        self.table = tableView
        
        switch viewTitle {
            
        case SelectedCategory.home.rawValue:
            selectedCategory = .home
            selectedParentID = withParentID ?? 1
            
        case SelectedCategory.errands.rawValue:
            selectedCategory = .errands
            selectedParentID = withParentID ?? 2
            
        case SelectedCategory.work.rawValue:
            selectedCategory = .work
            selectedParentID = withParentID ?? 3
            
        case SelectedCategory.other.rawValue:
            selectedCategory = .other
            selectedParentID = withParentID ?? 4
         
        default:
            print("Selected Category was set in the 'subItems' view")
            
        }
        
        if selectedCategory == .subItems {
            reloadItems()
        }
        
    }
    
    var typeOfSegue: String {
        
        switch selectedCategory {
            
        case .home:
            return Keywords.shared.homeToItemsSegue
            
        case .errands:
            return Keywords.shared.errandsToItemsSegue
            
        case .work:
            return Keywords.shared.workToItemsSegue
            
        case .other:
            return Keywords.shared.otherToItemsSegue
         
        case .subItems:
            // TODO: - GOING TO NEED TO MAKE ANOTHER VC TO MOVE DOWN LEVELS.
            return Keywords.shared.subItemsToMoreSubItemsSegue
            
        }
        
    }
    
    var editSegue: String {
        
        switch selectedCategory {
            
        case .home:
            return Keywords.shared.homeToEditSegue
            
        case .errands:
            return Keywords.shared.errandsToEditSegue
            
        case .work:
            return Keywords.shared.workToEditSegue
            
        case .other:
            return Keywords.shared.otherToEditSegue
            
        case .subItems:
            return "The 'selectedCategory' for 'editSegue' was set to the 'subItems' VC."
            
        }
        
    }
    
    func numberOfItems(forParentID parentID: Int) -> Int {
        return DataModel.shared.loadSpecificItems(forParentID: parentID).count
    }
    
    func numberOfItemsDone(forParentID parentID: Int) -> Int {
        var numberLeft = Int()
        let items = DataModel.shared.loadSpecificItems(forParentID: parentID)
        for item in items {
            numberLeft += item.done ? 1 : 0
        }
        return numberLeft
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


extension ItemModel: AddNewItemDelegate, ReloadTableListDelegate {
    
    func addNewItem(itemName: String, forParentID parentID: Int) -> Bool {
        
        var canAdd = true
        
        for item in items {
            if itemName == item.name || itemName == "" {
                canAdd = false
            }
        }
        
        if canAdd && itemName != "" {
            let isFirst = (items.count == 0)
            DataModel.shared.addNewItem(name: itemName, forCategory: .subItems, level: level, parentID: parentID, isFirst: isFirst)
            items = DataModel.shared.loadSpecificItems(forParentID: parentID)
            reloadItems()
        } else {
            canAdd = false
        }
        
        return canAdd
        
    }
    
    func reloadTableData() {
        if let table = table {
            table.reloadData()
        } else {
            print("There was no table loaded from Model delegate.")
        }
    }
    
}








