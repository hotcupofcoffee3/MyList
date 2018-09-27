//
//  CategoryAndItemModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit



// The Main Category and Item model for the TableViews

class CategoryAndItemModel {
    
    // The items that are loaded
    
    var categories = [Category]()
    
    var items = [Item]()
    
    var selectedCategory = "Category And Item Model selectedCategory: Type view, no Category Selected."
    
    func reloadCategoriesOrItems() {
        if viewDisplayed == .items {
            items = DataModel.shared.loadSpecificItemsByID(perCategory: selectedCategory)
        } else {
            categories = DataModel.shared.loadSpecificCategoriesByID(perType: viewDisplayed.rawValue)
        }
        
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
            viewDisplayed = .items
            
        }
        
        if viewDisplayed == .items {
            items = DataModel.shared.loadSpecificItemsByID(perCategory: selectedCategory)
        } else {
            categories = DataModel.shared.loadSpecificCategoriesByID(perType: viewDisplayed.rawValue)
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
         
        case .items:
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
            
        case .items:
            return Keywords.shared.itemsToEditSegue
            
        }
        
    }
    
    func numberOfItems(forCategory categoryName: String) -> Int {
        return DataModel.shared.loadSpecificItemsByID(perCategory: categoryName).count
    }
    
    func numberOfItemsDone(forCategory categoryName: String) -> Int {
        var numberLeft = Int()
        let items = DataModel.shared.loadSpecificItemsByID(perCategory: categoryName)
        for item in items {
            numberLeft += item.done ? 1 : 0
        }
        return numberLeft
    }
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension CategoryAndItemModel: AddNewCategoryOrItemDelegate, ReloadTableListDelegate {
    
    func addNewCategoryOrItem(categoryOrItem: String) -> Bool {
        
        var canAdd = true
        
        if viewDisplayed == .items {
            
            for item in items {
                if categoryOrItem == item.name || categoryOrItem == "" {
                    canAdd = false
                }
            }
            
            if canAdd && categoryOrItem != "" {
                let isFirst = (items.count == 0)
                DataModel.shared.addNewItem(name: categoryOrItem, category: selectedCategory, forViewDisplayed: .items, isFirst: isFirst)
                items = DataModel.shared.loadSpecificItemsByID(perCategory: selectedCategory)
                reloadCategoriesOrItems()
            } else {
                canAdd = false
            }
            
        } else {
            
            for category in categories {
                if categoryOrItem == category.name || categoryOrItem == "" {
                    canAdd = false
                }
            }
            
            if canAdd && categoryOrItem != "" {
                let isFirst = (categories.count == 0)
                DataModel.shared.addNewCategory(name: categoryOrItem, type: viewDisplayed.rawValue, date: Date(), forViewDisplayed: viewDisplayed, isFirst: isFirst)
                categories = DataModel.shared.loadSpecificCategoriesByID(perType: viewDisplayed.rawValue)
                reloadCategoriesOrItems()
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








