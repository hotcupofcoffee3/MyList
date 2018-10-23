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
        items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level, forParentID: selectedParentID)
    }
    
    
    
    // Called in viewDidLoad with VC's title to set the TableView & Type of Segue.
    
    // TableView is used for the reloading of the table data in the delegates.
    var table: UITableView?
    
    var selectedCategory = SelectedCategory.home
    
    var currentView = SelectedCategory.home
    
    var level = Int()
    
    var subItemsNumber = 0
    
    func setViewDisplayed(tableView: UITableView, view: String, level: Int, withParentID parentID: Int) {
        
        self.table = tableView
        
        self.selectedParentID = parentID
        
        self.level = level
        
        switch view {
            
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
            
        case .subItems1, .subItems2:
            return "The 'selectedCategory' for 'editSegue' was set to the 'subItems' VCs."
            
        }
        
    }
    
    func numberOfItems(forParentID parentID: Int) -> Int {
        return DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level + 1, forParentID: parentID).count
    }
    
    func numberOfItemsDone(forParentID parentID: Int) -> Int {
        var numberLeft = Int()
        let items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level + 1, forParentID: parentID)
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
    
    func addNewItem(itemName: String) -> Bool {
        
        var canAdd = true
        
        for item in items {
            if itemName == item.name || itemName == "" {
                canAdd = false
            }
        }
        
        if canAdd && itemName != "" {
            let isFirst = (items.count == 0)
            DataModel.shared.addNewItem(name: itemName, forCategory: selectedCategory, level: level, parentID: selectedParentID, isFirst: isFirst)
            items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory.rawValue, forLevel: level, forParentID: selectedParentID)
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








