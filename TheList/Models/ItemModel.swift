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
    
    var table: UITableView?
    
    var viewDisplayed = ChosenVC.home
    
    func setViewDisplayed(tableView: UITableView, viewTitle: String) {
        
        self.table = tableView
        
        switch viewTitle {
            
        case ChosenVC.home.rawValue:
            viewDisplayed = .home
            
        case ChosenVC.errands.rawValue:
            viewDisplayed = .errands
            
        case ChosenVC.work.rawValue:
            viewDisplayed = .work
            
        case ChosenVC.other.rawValue:
            viewDisplayed = .other
         
        default:
            viewDisplayed = .subItems
            
        }
        
        if viewDisplayed == .subItems {
            reloadItems()
        }
        
    }
    
    var typeOfSegue: String {
        
        switch viewDisplayed {
            
        case .home:
            return Keywords.shared.homeToItemsSegue
            
        case .errands:
            return Keywords.shared.errandsToItemsSegue
            
        case .work:
            return Keywords.shared.workToItemsSegue
            
        case .other:
            return Keywords.shared.otherToItemsSegue
         
        case .subItems:
            return "Type of Segue is Items"
            
        }
        
    }
    
    var editSegue: String {
        
        switch viewDisplayed {
            
        case .home:
            return Keywords.shared.homeToEditSegue
            
        case .errands:
            return Keywords.shared.errandsToEditSegue
            
        case .work:
            return Keywords.shared.workToEditSegue
            
        case .other:
            return Keywords.shared.otherToEditSegue
            
        case .subItems:
            return Keywords.shared.itemsToEditSegue
            
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
    
    func getItemType(item: Item) -> ChosenVC {
        
        var itemType = ChosenVC.home
        
        switch item.type! {
            
        case ChosenVC.home.rawValue: itemType = .home
        case ChosenVC.errands.rawValue: itemType = .errands
        case ChosenVC.work.rawValue: itemType = .work
        case ChosenVC.other.rawValue: itemType = .other
        default: break
            
        }
        
        return itemType
        
    }
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension ItemModel: AddNewItemDelegate, ReloadTableListDelegate {
    
    func addNewItem(itemName: String, forParentID parentID: Int) -> Bool {
        
        var canAdd = true
        
        let parent = DataModel.shared.loadParentItem(forParentID: parentID)
        
        if viewDisplayed == .subItems {
            
            for item in items {
                if itemName == item.name || itemName == "" {
                    canAdd = false
                }
            }
            
            if canAdd && itemName != "" {
                let isFirst = (items.count == 0)
                DataModel.shared.addNewItem(name: itemName, forViewDisplayed: .subItems, parentID: parentID, isFirst: isFirst)
                items = DataModel.shared.loadSpecificItems(forParentID: parentID)
                reloadItems()
            } else {
                canAdd = false
            }
            
        } else {
            
            if canAdd && itemName != "" {
                let isFirst = (items.count == 0)
                DataModel.shared.addNewItem(name: itemName, forViewDisplayed: viewDisplayed, parentID: parentID, isFirst: isFirst)
                items = DataModel.shared.loadSpecificItems(forParentID: parentID)
                reloadItems()
            } else {
                canAdd = false
            }
            
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








