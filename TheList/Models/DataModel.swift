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
    static var shared = DataModel()
    var allCategories = [Category]()
    var allItems = [Item]()
    
    private init() { loadAllData() }
    
    
    
    // MARK: - CREATE
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
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
    
    
    
    // MARK: - READ
    
    func loadAllData() {
        loadAllCategories()
        loadAllItems()
    }
    
    func loadAllCategories() {
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            allCategories = try context.fetch(request)
        } catch {
//            print("Error loading All Categories in the Data model: \(error)")
        }
        
        if allCategories.count == 0 {
//            print("There are no Categories loaded from the Data model")
        }
        
    }
    
    func loadAllItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            allItems = try context.fetch(request)
        } catch {
//            print("Error loading All Items in the Data model: \(error)")
        }
        
        if allItems.count == 0 {
//            print("There are no Items loaded from the Data model")
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
//            print("Error loading All Items in the Data model: \(error)")
        }
        
        if items.count == 0 {
//            print("There are no Items loaded from the Data model")
        }
        
        return items
        
    }
    
    func loadSpecificCategories(perType: String) -> [Category] {
        
        var categories = [Category]()
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "type MATCHES %@", perType)
        
        request.predicate = predicate
        
        do {
            categories = try context.fetch(request)
        } catch {
//            print("Error loading All Items in the Data model: \(error)")
        }
        
        if categories.count == 0 {
//            print("There are no Items loaded from the Data model")
        }
        
        return categories
        
    }
    
    
    
    // MARK: - UPDATE
    
    enum ItemProperty {
        case category, name, done, repeating, id
    }
    enum CategoryProperty {
        case name, type, repeating, date, id
    }
    
    func updateItem(forProperty property: ItemProperty, forItem item: Item, category: String?, name: String?) {
        
        let itemToUpdate = item
        
        switch property {
            
        case .category :
            itemToUpdate.category = (category != nil && category != "") ? category : itemToUpdate.category!
            
        case .name :
            itemToUpdate.name = (name != nil && name != "") ? name : itemToUpdate.name!
            
        case .done :
            itemToUpdate.done = !itemToUpdate.done
            
        case .repeating :
            itemToUpdate.repeating = !itemToUpdate.repeating
            
        default:
            break
            
        }
        
        saveData()
        
    }
    
    func updateID(forCategory category: Category, andID id: Int) {
        category.id = Int64(id)
        saveData()
    }
    
    func updateID(forItem item: Item, andID id: Int) {
        item.id = Int64(id)
        saveData()
    }
    
    
    
    
    // MARK: - DELETE
    
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
    
    func deleteAllCategories(ofType type: String) {
        let allCategoriesToDelete = loadSpecificCategories(perType: type)
        for category in allCategoriesToDelete {
            context.delete(category)
        }
        saveData()
    }
    
    func deleteAllItems(fromCategory category: String) {
        let allItemsToDelete = loadSpecificItems(perCategory: category)
        for item in allItemsToDelete {
            context.delete(item)
        }
        saveData()
    }
    
    func deleteSpecificCategory(forCategory category: Category) {
        deleteAllItems(fromCategory: category.name!)
        context.delete(category)
        saveData()
    }
    
    func deleteSpecificItem(forItem item: Item) {
        context.delete(item)
        saveData()
    }
    
}















