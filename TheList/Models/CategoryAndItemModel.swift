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
    
    var categories = [Category]()
    
    var items = [Item]()
    
    func reloadCategories() {
        
        categories = DataModel.shared.loadSpecificCategories(perType: viewDisplayed)
        
    }
    
    
    
    // Called in viewDidLoad with VC's title to set the TableView & Type of Segue.
    
    var table: UITableView?
    
    var viewDisplayed = ChosenVC.home
    
    func setViewDisplayed(tableView: UITableView, viewTitle: String) {
        
        self.table = tableView
        
        switch viewTitle {
            
        case ChosenVC.home.rawValue: viewDisplayed = .home
        case ChosenVC.errands.rawValue: viewDisplayed = .errands
        case ChosenVC.work.rawValue: viewDisplayed = .work
        case ChosenVC.fun.rawValue: viewDisplayed = .fun
        case ChosenVC.ideas.rawValue: viewDisplayed = .ideas
            
        default: viewDisplayed = .items
            
        }
        
    }
    
    var typeOfSegue: String {
        
        switch viewDisplayed {
            
        case .home: return Keywords.shared.homeToItemsSegue
        case .errands: return Keywords.shared.errandsToItemsSegue
        case .work: return Keywords.shared.workToItemsSegue
        case .fun: return Keywords.shared.funToItemsSegue
        case .ideas: return Keywords.shared.ideasToItemsSegue
            
        case .items: return "Type of Segue is Items"
            
        }
        
    }
    
    
    
}



// MARK: - Delegate functions from the Header View, with the tableView set in the viewDidLoad


extension CategoryAndItemModel: AddNewCategoryDelegate, AddNewItemDelegate, ReloadTableListDelegate {
    
    
    
    func addNewCategory(category: String) {
        DataModel.shared.addNewCategory(name: category, type: viewDisplayed.rawValue, date: Date(), repeating: false)
        categories = DataModel.shared.loadSpecificCategories(perType: viewDisplayed)
        reloadCategories()
        print("Categories from model after adding: \(categories.count)")
    }
    
    func addNewItem(item: String) {
        
        
        
    }
    
    func reloadTableData() {
        if let table = table {
            table.reloadData()
        } else {
            print("There was no table loaded from Model delegate.")
        }
    }
    
}








