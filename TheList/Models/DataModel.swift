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
    
    func addNewCategory(name: String, type: String, date: Date, repeating: Bool, forViewDisplayed view: ChosenVC, isFirst: Bool) {
        
        let calculatedID = Int64(loadNextID(forViewDisplayed: view, isFirst: isFirst, forSelectedCategory: nil))
        
        let newCategory = Category(context: context)
        newCategory.name = name
        newCategory.type = type
        newCategory.date = date
        newCategory.repeating = repeating
        newCategory.id = calculatedID
        
        saveData()
        
    }
    
    func addNewItem(name: String, category: String, done: Bool, repeating: Bool, forViewDisplayed view: ChosenVC, isFirst: Bool) {
        
        let calculatedID = Int64(loadNextID(forViewDisplayed: view, isFirst: isFirst, forSelectedCategory: loadSpecificCategory(named: category)))
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.category = category
        newItem.done = done
        newItem.repeating = repeating
        newItem.id = calculatedID
        
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
    
    func loadSpecificCategory(named: String) -> Category {
        
        var categories = [Category]()
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "name MATCHES %@", named)
        
        request.predicate = predicate
        
        do {
            categories = try context.fetch(request)
        } catch {
            //            print("Error loading All Items in the Data model: \(error)")
        }
        
        if categories.count == 0 {
            //            print("There are no Items loaded from the Data model")
        } else if categories.count > 1 {
            print("More than one category was loaded in the loadSpecificCategory function in the DataModel")
        }
        
        return categories[0]
        
    }
    
    // Not a load from Core Data, but still loading a particular number to set as the ID.
    
    func loadNextID(forViewDisplayed view: ChosenVC, isFirst: Bool, forSelectedCategory category: Category?) -> Int {
        
        var id = Int()
        
        var categoriesForType = [Category]()
        
        var itemsForCategory = [Item]()
        
        // Populating the arrays based on the View selected.
        switch view {
            
        case .home, .errands, .work, .fun, .ideas:
            categoriesForType = loadSpecificCategories(perType: view.rawValue)
            
        case .items :
            guard let category = category else {
                print("There was no Category selected to populate the array in the .items part of the loadNextID function in the DataModel.")
                return 0
            }
            itemsForCategory = loadSpecificItems(perCategory: category.name!)
            
        }
        
        // Assigning an ID based on the particular case.
        switch view {
            
        case .home:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 10001
            print("\(categoriesForType.count)")
            print("Created id from home: \(id)")
            
        case .errands:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 20001
            print("\(categoriesForType.count)")
            print("Created id from errands: \(id)")
            
        case .work:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 30001
            
        case .fun:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 40001
            
        case .ideas:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 50001
            
        case .items:
            guard let category = category else {
                print("There was no Category selected to assign an ID in the .items part of the loadNextID function in the DataModel.")
                return 0
            }
            id = (itemsForCategory.count > 0 && !isFirst) ? Int(itemsForCategory[itemsForCategory.count - 1].id + 1) : (Int(category.id) * 10000) + 1
            
        }
        
        return id
        
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
    
    func updateAllItemsAreDone(forCategory categoryName: String) -> Bool {
        let itemsForCategory = loadSpecificItems(perCategory: categoryName)
        
        var allItemsAreDone = true
        
        if !itemsForCategory.isEmpty {
            
            for item in itemsForCategory {
                
                if item.done == false {
                    allItemsAreDone = false
                }
                
            }
            
        } else {
            
            allItemsAreDone = false
            
        }
        
        return allItemsAreDone
    }
    
    func updateID(forCategory category: Category, andID id: Int) {
        category.id = Int64(id)
        saveData()
    }
    
    func updateID(forItem item: Item, andID id: Int) {
        item.id = Int64(id)
        saveData()
    }
    
    func updateIDs(forViewDisplayed view: ChosenVC, forCategories categories: [Category]?, orForItems items: [Item]?, forSelectedCategory category: Category?) {
        
        if categories != nil && items == nil {
            
            guard let categories = categories else { return print("There were no Categories loaded in the updateIDs function in DataModel.") }
            
            for index in categories.indices {
                
                if index == 0 {
                    updateID(forCategory: categories[index], andID: loadNextID(forViewDisplayed: view, isFirst: true, forSelectedCategory: category))
                } else {
                    updateID(forCategory: categories[index], andID: loadNextID(forViewDisplayed: view, isFirst: false, forSelectedCategory: category))
                }
                
            }
            
        } else if items != nil && categories == nil {
            
            guard let items = items else { return print("There were no Items loaded in the updateIDs function in DataModel.") }
            
            for index in items.indices {
                
                if index == 0 {
                    updateID(forItem: items[index], andID: loadNextID(forViewDisplayed: view, isFirst: true, forSelectedCategory: category))
                } else {
                    updateID(forItem: items[index], andID: loadNextID(forViewDisplayed: view, isFirst: false, forSelectedCategory: category))
                }
                
            }
            
        } else {
            
            print("There was no array passed to the updateIDs() function in the DataModel.")
            
        }
        
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















