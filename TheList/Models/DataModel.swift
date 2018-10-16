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
    
    private init() { loadAllData() }
    
    
    
    // MARK: - CREATE
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
    }
    
    func addNewItem(name: String, forCategory category: SelectedCategory, level: Int, parentID: Int, isFirst: Bool) {
        
        var newParentID = Int()
        
        if level == 1 {
            
            switch category {
                
            case .home:     newParentID = 1
            case .errands:  newParentID = 2
            case .work:     newParentID = 3
            case .other:    newParentID = 4
            case .subItems: print("SubItems category was selected for adding a new Item.")
                
            }
        } else {
            newParentID = parentID
        }
        
        
        let calculatedID = Int64(loadNextID(isFirst: isFirst, forParentID: parentID))
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.done = false
        newItem.id = calculatedID
        newItem.parentID = Int64(newParentID)
        newItem.category = category.rawValue
        newItem.level = Int64(level)
        
        saveData()
        
    }
    
    
    
    // MARK: - READ
    
    func loadAllData() {
        loadAllItems()
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
    
    func loadSpecificItems(forParentID parentID: Int) -> [Item] {

        var items = [Item]()

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let predicate = NSPredicate(format: Keywords.shared.parentIDMatch, String(parentID))

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
    
    func loadNextID(isFirst: Bool, forParentID parentID: Int) -> Int {
        
        let items = loadSpecificItems(forParentID: parentID)
        
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
        
        let isDone = updateAllItemsAreDone(forParentID: parentID)
        updateDone(forParentID: parentID, doneStatus: isDone)
        
    }
    
    func updateAllItemsAreDone(forParentID parentID: Int) -> Bool {
        
        let items = loadSpecificItems(forParentID: parentID)
        
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
        
        return allItemsAreDone
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
    
    func updateIDs(forItems items: [Item]?) {
        
        var startingID = 1
        
        if items != nil {
            
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
        deleteAllItems()
    }
    
    func deleteAllItems() {
        loadAllItems()
        for item in allItems {
            context.delete(item)
        }
        saveData()
    }
    
    
    func deleteAllItems(forParentID parentID: Int) {
        let allItemsToDelete = loadSpecificItems(forParentID: parentID)
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















