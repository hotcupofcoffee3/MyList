//
//  DataModel.swift
//  TheList
//
//  Created by Adam Moore on 9/6/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class DataModel {
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    private init() {
//        deleteAllData()
        loadAllData()
        print("Categories: \(allCategories.count)")
        print("Items: \(allItems.count)")
    }
    
    static var shared = DataModel()
    
    var allCategories = [Category]()
    
    var allItems = [Item]()
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
    }
    
    func loadAllData() {
        loadAllCategories()
        loadAllItems()
    }
    
    func loadAllCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            allCategories = try context.fetch(request)
        } catch {
            print("Error loading All Categories in the Data model: \(error)")
        }
        
        if allCategories.count == 0 {
            print("There are no Categories loaded from the Data model")
        }
        
    }
    
    func loadAllItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            allItems = try context.fetch(request)
        } catch {
            print("Error loading All Items in the Data model: \(error)")
        }
        
        if allItems.count == 0 {
            print("There are no Items loaded from the Data model")
        }
        
    }
    
    func loadSpecificItems(perCategory: String) -> [Item] {
        
        var items = [Item]()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "category MATCHES %@", perCategory)
        
        request.predicate = predicate
        
        do {
            items = try context.fetch(request)
        } catch {
            print("Error loading All Items in the Data model: \(error)")
        }
        
        if items.count == 0 {
            print("There are no Items loaded from the Data model")
        }
        
        return items
        
    }
    
    func loadSpecificCategories(perType: ChosenVC) -> [Category] {
        
        var categories = [Category]()
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "type MATCHES %@", perType.rawValue)
        
        request.predicate = predicate
        
        do {
            categories = try context.fetch(request)
        } catch {
            print("Error loading All Items in the Data model: \(error)")
        }
        
        if categories.count == 0 {
            print("There are no Items loaded from the Data model")
        }
        
        return categories
        
    }
    
    func deleteAllData() {
        deleteAllCategories()
        deleteAllItems()
    }
    
    func deleteAllCategories() {
        loadAllCategories()
        for category in allCategories {
            context.delete(category)
        }
        saveData()
    }
    
    func deleteAllItems() {
        loadAllItems()
        for item in allItems {
            context.delete(item)
        }
        saveData()
    }
    
    
    
    // TODO: - Fill in these functions
    func deleteAllCategories(ofType: String) {
        
    }
    
    func deleteAllItems(fromCategory: String) {
        
    }
    
    
    
    func addNewCategory(name: String, type: String, date: Date, repeating: Bool) {
        
        let newCategory = Category(context: context)
        newCategory.name = name
        newCategory.type = type
        newCategory.date = date
        newCategory.repeating = repeating
        
        saveData()
        
    }
    
    func addNewItem(name: String, category: String, done: Bool, repeating: Bool) {
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.category = category
        newItem.done = done
        newItem.repeating = repeating
        
        saveData()
        
    }
    
}
