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
    
    // MARK: - SETUP AND INIT
    
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
    
    func addNewCategory(name: String, type: String, date: Date, forViewDisplayed view: ChosenVC, isFirst: Bool) {
        
        let calculatedID = Int64(loadNextID(forViewDisplayed: view, isFirst: isFirst, forSelectedCategory: nil))
        
        let newCategory = Category(context: context)
        newCategory.name = name
        newCategory.type = type
        newCategory.date = date
        newCategory.repeating = false
        newCategory.done = false
        newCategory.id = calculatedID
        
        saveData()
        
    }
    
    func addNewItem(name: String, category: String, forViewDisplayed view: ChosenVC, isFirst: Bool) {
        
        let calculatedID = Int64(loadNextID(forViewDisplayed: view, isFirst: isFirst, forSelectedCategory: loadSpecificCategory(named: category)))
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.category = category
        newItem.done = false
        newItem.repeating = false
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
    
    func loadSpecificCategoriesByID(perType: String) -> [Category] {
        
        var categories = [Category]()
        
        let request: NSFetchRequest<Category> = Category.fetchRequest()
        
        let predicate = NSPredicate(format: "type MATCHES %@", perType)
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
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
    
    func loadSpecificItemsByID(perCategory: String) -> [Item] {
        
        var items = [Item]()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: "category MATCHES %@", perCategory)
        
        request.sortDescriptors = [NSSortDescriptor(key: "id", ascending: true)]
        
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
            
        case .home, .errands, .work, .other:
            categoriesForType = loadSpecificCategoriesByID(perType: view.rawValue)
            
        case .items :
            guard let category = category else {
                print("There was no Category selected to populate the array in the .items part of the loadNextID function in the DataModel.")
                return 0
            }
            itemsForCategory = loadSpecificItemsByID(perCategory: category.name!)
            
        }
        
        // Assigning an ID based on the particular case.
        switch view {
            
        case .home:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 10001
//            print("\(categoriesForType.count)")
//            print("Created id from home: \(id)")
            
        case .errands:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 20001
//            print("\(categoriesForType.count)")
//            print("Created id from errands: \(id)")
            
        case .work:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 30001
            
        case .other:
            id = (categoriesForType.count > 0 && !isFirst) ? Int(categoriesForType[categoriesForType.count - 1].id + 1) : 40001
           
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
        
        let isDone = updateAllItemsAreDone(forCategory: itemToUpdate.category!)
        updateDone(forCategory: itemToUpdate.category!, doneStatus: isDone)
        
    }
    
    func updateAllItemsAreDone(forCategory categoryName: String) -> Bool {
        
        let itemsForCategory = loadSpecificItemsByID(perCategory: categoryName)
        
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
        
        
        updateDone(forCategory: categoryName, doneStatus: allItemsAreDone)
        
        return allItemsAreDone
    }
    
    func updateDone(forCategory categoryName: String, doneStatus: Bool) {
        let category = loadSpecificCategory(named: categoryName)
        category.done = doneStatus
        saveData()
    }
    
    func toggleDone(forCategory categoryName: String) {
        let category = loadSpecificCategory(named: categoryName)
        category.done = !category.done
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
    
    func updateIDs(forViewDisplayed view: ChosenVC, forCategories categories: [Category]?, orForItems items: [Item]?, forSelectedCategory category: Category?) {
        
        var startingID = Int()
        
        // Assigning an ID based on the particular case.
        switch view {
            
        case .home:
            startingID = 10001
            
        case .errands:
            startingID = 20001
            
        case .work:
            startingID = 30001
            
        case .other:
            startingID = 40001
         
        case .items:
            guard let category = category else {
                return print("There was no Category selected to assign an ID in the .items part of the loadNextID function in the DataModel.")
            }
            startingID = (Int(category.id) * 10000) + 1
            
        }
        
        if categories != nil && items == nil {
            
            guard let categories = categories else { return print("There were no Categories loaded in the updateIDs function in DataModel.") }
            
            for category in categories {
                
                category.id = Int64(startingID)
                startingID += 1
                
            }
            
        } else if items != nil && categories == nil {
            
            guard let items = items else { return print("There were no Items loaded in the updateIDs function in DataModel.") }
            
            for item in items {
                
                item.id = Int64(startingID)
                startingID += 1
                
            }
            
        } else {
            
            print("There was no array passed to the updateIDs() function in the DataModel.")
            
        }
        
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
        let allCategoriesToDelete = loadSpecificCategoriesByID(perType: type)
        for category in allCategoriesToDelete {
            context.delete(category)
        }
        saveData()
    }
    
    func deleteAllItems(fromCategory category: String) {
        let allItemsToDelete = loadSpecificItemsByID(perCategory: category)
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















