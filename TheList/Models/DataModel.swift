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
    var allItems = [Item]()
    var nextItemID = Int()
    
    private init() { loadAllItems() }
    
    
    
    // MARK: - CREATE
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
    }
    
    func addNewItem(name: String, forCategory category: SelectedCategory, level: Int, parentID: Int) {
        
        var newParentID = Int()
        
        if level == 1 {
            
            switch category {
                
            case .home:     newParentID = 1
            case .errands:  newParentID = 2
            case .work:     newParentID = 3
            case .other:    newParentID = 4
            case .subItems1, .subItems2: print("SubItems category was selected for adding a new Item.")
                
            }
        } else {
            newParentID = parentID
        }
        
        
//        let calculatedID = loadNextID(isFirst: isFirst, forCategory: category.rawValue, forLevel: level, forParentID: parentID)
        loadAllItems()
        let calculatedID = nextItemID + 1
        
        let siblingItems = loadSpecificItems(forCategory: category.rawValue, forLevel: level, forParentID: parentID)
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.done = false
        newItem.id = Int64(calculatedID)
        newItem.parentID = Int64(newParentID)
        newItem.category = category.rawValue
        newItem.level = Int64(level)
        newItem.orderNumber = Int64(siblingItems.count + 1)
        
        saveData()
        
    }
    
    
    
    // MARK: - READ
    
    func loadAllItems() {
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            allItems = try context.fetch(request)
        } catch {
//            print("Error loading All Items in the Data model: \(error)")
        }
        
        
        // TODO: - Make this a function in itself that saves the number in UserDefaults and returns the next number, instead of requiring all of the items to be loaded first.
        nextItemID = allItems.count + 5
        
    }
    
    func loadSpecificItems(forCategory category: String, forLevel level: Int, forParentID parentID: Int) -> [Item] {

        var items = [Item]()

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let parentIDPredicate = NSPredicate(format: Keywords.shared.parentIDMatch, String(parentID))
        let categoryPredicate = NSPredicate(format: Keywords.shared.categoryMatch, category)
        let levelPredicate = NSPredicate(format: Keywords.shared.levelMatch, String(level))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIDPredicate, categoryPredicate, levelPredicate])

        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: Keywords.shared.orderNumberKey, ascending: true)]

        do {
            items = try context.fetch(request)
        } catch {
//                        print("Error loading All Items in the Data model: \(error)")
        }

        if items.count == 0 {
//                        print("There are no Items loaded from the Data model")
        }
        
        return items

    }
    
    func loadParentItem(forParentID parentID: Int) -> Item {
        
        var items = [Item]()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let predicate = NSPredicate(format: Keywords.shared.idMatch, String(parentID))
        
        request.predicate = predicate
        
        do {
            items = try context.fetch(request)
        } catch {
            //            print("Error loading All Items in the Data model: \(error)")
        }
        
        if items.count == 0 {
            //            print("There are no Items loaded from the Data model")
        } else if items.count > 1 {
            //            print("There is more than 1 Item loaded for the ID from the Data model")
        }
        
        return items[0]
        
    }
    
    // Not a load from Core Data, but still loading a particular number to set as the ID.
    
    func loadNextID(isFirst: Bool, forCategory category: String, forLevel level: Int, forParentID parentID: Int) -> Int {

        let items = loadSpecificItems(forCategory: category, forLevel: level, forParentID: parentID)

        return (items.count > 0 && !isFirst) ? Int(items[items.count - 1].id + 1) : 1

    }
    
    
    
    // MARK: - UPDATE
    
    func updateItem(forProperty property: ItemProperty, forItem item: Item, parentID: Int, name: String?) {
        
        let itemToUpdate = item
        
        switch property {
            
        case .parentID :
            itemToUpdate.parentID = Int64(parentID)
            
        case .name :
            itemToUpdate.name = (name != nil && name != "") ? name : itemToUpdate.name!
            
        case .done :
            itemToUpdate.done = !itemToUpdate.done
          
        default:
            break
            
        }
        
        saveData()
        
        if itemToUpdate.level > 1 {
            
            updateAllItemsAreDone(forCategory: itemToUpdate.category!, forLevel: Int(itemToUpdate.level), forParentID: parentID)
            
        }
        
    }
    
    func updateAllItemsAreDone(forCategory category: String, forLevel level: Int, forParentID parentID: Int) {
        
        let items = loadSpecificItems(forCategory: category, forLevel: level, forParentID: parentID)
        
        var allItemsAreDone = true
        
        if !items.isEmpty {
            
            for item in items {
                
                if item.done == false {
                    allItemsAreDone = false
                }
                
            }
            
        } else {
            
            allItemsAreDone = false
            
        }
        
        
        updateDone(forParentID: parentID, doneStatus: allItemsAreDone)
        
    }
    
    func updateDone(forParentID parentID: Int, doneStatus: Bool) {
        let parent = loadParentItem(forParentID: parentID)
        parent.done = doneStatus
        saveData()
    }
    
    func updateID(forItem item: Item, andID id: Int) {
        item.id = Int64(id)
        saveData()
    }
    
    func updateOrderNumber(forItems items: [Item]?) {
        
        var orderNumber = 1
        
        if items != nil {
            
            guard let items = items else { return print("There were no Items loaded in the updateIDs function in DataModel.") }
            
            for item in items {
                
                item.orderNumber = Int64(orderNumber)
                orderNumber += 1
                
            }
            
        } else {
            
            print("There was no array passed to the updateIDs() function in the DataModel.")
            
        }
        
        saveData()
        
    }
    
    
    
    
    // MARK: - DELETE
    
    func deleteAllData() {
        deleteAllItems()
    }
    
    func deleteAllItems() {
        loadAllItems()
        for item in allItems {
            context.delete(item)
        }
        saveData()
    }
    
    
    func deleteAllItems(forCategory category: String, forLevel level: Int, forParentID parentID: Int) {
        let allItemsToDelete = loadSpecificItems(forCategory: category, forLevel: level, forParentID: parentID)
        for item in allItemsToDelete {
            context.delete(item)
        }
        saveData()
    }
    
    func deleteSpecificItem(forItem item: Item) {
        context.delete(item)
        saveData()
    }
    
}















