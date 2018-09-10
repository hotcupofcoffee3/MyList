//
//  CategoryAndItemModel.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit



// The Chosen VC that displays the TableView

enum ChosenVC: String {
    case home, errands, work, fun, ideas, items
}



// The Main Category and Item model for the TableViews

class CategoryAndItemModel {
    
    
    
    // The items that are loaded
    
    var category = String()
    
    var categoriesOrItems = [Any]()
    
    func reloadCategoriesOrItems() {
        categoriesOrItems = DataModel.shared.loadSpecificCategories(perType: viewDisplayed)
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
            
        case ChosenVC.fun.rawValue:
            viewDisplayed = .fun
            
        case ChosenVC.ideas.rawValue:
            viewDisplayed = .ideas
            
        default:
            viewDisplayed = .items
            
        }
        
        categoriesOrItems = (viewDisplayed == .items) ? DataModel.shared.loadSpecificItems(perCategory: viewDisplayed.rawValue) : DataModel.shared.loadSpecificCategories(perType: viewDisplayed)
        
    }
    
    var typeOfSegue: String {
        
        switch viewDisplayed {
            
        case .home:
            return Keywords.shared.homeToItemsSegue
            
        case .errands:
            return Keywords.shared.errandsToItemsSegue
            
        case .work:
            return Keywords.shared.workToItemsSegue
            
        case .fun:
            return Keywords.shared.funToItemsSegue
            
        case .ideas:
            return Keywords.shared.ideasToItemsSegue
            
        case .items: return "Type of Segue is Items"
            
        }
        
    }
    
    
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension CategoryAndItemModel: AddNewCategoryOrItemDelegate, ReloadTableListDelegate {
    
    
    func addNewCategoryOrItem(categoryOrItem: String) {
        
        if categoryOrItem == ChosenVC.items.rawValue {
            
            DataModel.shared.addNewItem(name: categoryOrItem, category: category, done: false, repeating: false)
            categoriesOrItems = DataModel.shared.loadSpecificItems(perCategory: category)
            reloadCategoriesOrItems()
            print("Items from model after adding: \(categoriesOrItems.count)")
            
        } else {
            
            DataModel.shared.addNewCategory(name: categoryOrItem, type: viewDisplayed.rawValue, date: Date(), repeating: false)
            categoriesOrItems = DataModel.shared.loadSpecificCategories(perType: viewDisplayed)
            reloadCategoriesOrItems()
            print("Categories from model after adding: \(categoriesOrItems.count)")
            
        }
        
    }
    
    func reloadTableData() {
        if let table = table {
            table.reloadData()
        } else {
            print("There was no table loaded from Model delegate.")
        }
    }
    
}








