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
    var itemsToDeleteQueue = [Item]()
    
    private init() { }
    
    
    
    // MARK: - CREATE
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
    }
    
    func addNewItem(name: String, forCategory category: SelectedCategory, level: Int, parentID: Int, parentName: String) {
        
        var newParentID = Int()
        var newParentName = String()
        
        if level == 1 {
            
            switch category {
                
            case .home:     newParentID = 1
            case .errands:  newParentID = 2
            case .work:     newParentID = 3
            case .other:    newParentID = 4
            case .subItems1, .subItems2: print("SubItems category was selected for adding a new Item.")
                
            }
            
            if category != .subItems1 && category != .subItems2 {
                newParentName = category.rawValue
            }
            
        } else {
            newParentID = parentID
            newParentName = parentName
        }
        
        
        let calculatedID = loadSpecificItems(forCategory: category.rawValue, forLevel: level, forParentID: parentID, andParentName: parentName).count + 1
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.done = false
        newItem.id = Int64(calculatedID)
        newItem.parentID = Int64(newParentID)
        newItem.parentName = newParentName
        newItem.category = category.rawValue
        newItem.level = Int64(level)
        newItem.numOfSubItems = 0
        
        saveData()
        
    }
    
    func group(items: [Item], intoNewItemName newItemName: String, forCategory category: SelectedCategory, atLevel newItemLevel: Int, withNewItemParentID newItemParentID: Int, andNewItemParentName newItemParentName: String) {
        
        
        
        // 1:
        // --- Update all of the items to be grouped with a new level FIRST, so that all other information stays the same.
        // --- Use the 'updateLevels()' function.
        updateLevels(forItems: items)
        
        
        
        // 2:
        // --- Load all of the Newly Grouped Items with the new level.
        // --- Update the parentName.
        let newlyLeveledItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: newItemParentID, andParentName: newItemParentName)
        
        for leveledItem in newlyLeveledItems {
            leveledItem.parentName = newItemName
        }
        
        saveData()
        
        
        
        // 3:
        // --- Add new Item that will be the parent of the selected Items to be grouped.
        addNewItem(name: newItemName, forCategory: category, level: newItemLevel, parentID: newItemParentID, parentName: newItemParentName)
        
        
        
        // 4:
        // --- Get new Item's ID from the count of the items, at this is will be the last item that was added, and therefore the 'count' would be the item's ID.
        // --- Load all of the Newly Grouped Items
        // --- Update the parentID based on the 'newItemID'
        let newItemID = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel, forParentID: newItemParentID, andParentName: newItemParentName).count
        
        // 'newItemParentID' is used initially because the 'newItemID' has not been set for this group of items.
        let oldParentID = newItemParentID
        let subItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: oldParentID, andParentName: newItemName)
        
        for subItem in subItems {
            subItem.parentID = Int64(newItemID)
        }
        saveData()
        
        
        // 5:
        // --- Update the IDs of the grouped items, as they will now be different, since they are in their own group, and are therefore ordered differently.
        let newlyGroupedItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: newItemID, andParentName: newItemName)
        updateIDs(forItems: newlyGroupedItems)
        
    }
    
    
    
    // MARK: - READ
    
    func loadAllItems() -> [Item] {
        
        var allItems = [Item]()
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        do {
            allItems = try context.fetch(request)
        } catch {
//            print("Error loading All Items in the Data model: \(error)")
        }
        
        return allItems
        
    }
    
    func loadSpecificItems(forCategory category: String, forLevel level: Int, forParentID parentID: Int, andParentName parentName: String) -> [Item] {

        var items = [Item]()

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let parentIDPredicate = NSPredicate(format: Keywords.shared.parentIDMatch, String(parentID))
        let parentNamePredicate = NSPredicate(format: Keywords.shared.parentNameMatch, String(parentName))
        let categoryPredicate = NSPredicate(format: Keywords.shared.categoryMatch, category)
        let levelPredicate = NSPredicate(format: Keywords.shared.levelMatch, String(level))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIDPredicate, parentNamePredicate, categoryPredicate, levelPredicate])

        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: Keywords.shared.idKey, ascending: true)]

        do {
            items = try context.fetch(request)
        } catch {
//                        print("Error loading All Items in the Data model: \(error)")
        }

        if items.count == 0 {
//                        print("There are no Items loaded from the Data model")
        }
        
//        if level > 1 && !items.isEmpty {
//            updateAllItemsAreDone(forItems: items, onLevel: level, withParentID: parentID, andParentName: parentName)
//        }
        
        return items

    }
    
    func loadParentItem(forID id: Int, andName name: String) -> Item {
        
        var items = [Item]()
        
        let request: NSFetchRequest<Item> = Item.fetchRequest()
        
        let idPredicate = NSPredicate(format: Keywords.shared.idMatch, String(id))
        
        let namePredicate = NSPredicate(format: Keywords.shared.nameMatch, String(name))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, namePredicate])
        
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
    
    
    
    // MARK: - UPDATE
    
    func updateItem(forProperty property: ItemProperty, forItem item: Item, parentID: Int, parentName: String, name: String?) {
        
        let itemToUpdate = item
        
        switch property {
            
        case .parentID :
            itemToUpdate.parentID = Int64(parentID)
            
        case .name :
            
            if name != nil && name != "" {
                
                let subItems = loadSpecificItems(forCategory: itemToUpdate.category!, forLevel: Int(itemToUpdate.level + 1), forParentID: Int(itemToUpdate.id), andParentName: itemToUpdate.name!)
                
                for subItem in subItems {
                    subItem.parentName = name!
                }
                
                itemToUpdate.name = name
                
            }
            
        case .done :
            itemToUpdate.done = !itemToUpdate.done
            
        default:
            break
            
        }
        
        saveData()
        
    }
    
    func updateAllItemsAreDone(forItems items: [Item], onLevel level:Int, withParentID parentID: Int, andParentName parentName: String) {
        
        var allItemsAreDone = true
        
        for item in items {
            
            if item.done == false {
                allItemsAreDone = false
            }
            
        }
        
        if level > 1 {
            
            let parent = loadParentItem(forID: parentID, andName: parentName)
            
            parent.done = allItemsAreDone
            
            saveData()
            
        }
        
    }
    
    func updateIDs(forItems items: [Item]?) {
        
        var id = 1
        
        var subItems = [Item]()
        
        if items != nil {
            
            guard let items = items else { return print("There were no Items loaded in the updateIDs function in DataModel.") }
            
            for item in items {
                
                // ID and Level before new IDs are set
                let oldID = Int(item.id)
                let subItemLevel = Int(item.level + 1)
                
                // Reset array and load subitems based on item info before it is changed.
                subItems = []
                subItems = loadSpecificItems(forCategory: item.category!, forLevel: subItemLevel, forParentID: oldID, andParentName: item.name!)
                
                // If the old id AND name match, then the subItem's parentID is updated.
                // Matching the name AND old id makes sure that when the new IDs are set for the parents, even if they match some of the other subItems' parentID, they won't match the name, as well, so this filters them out.
                if subItems.count > 0 {
                    for subItem in subItems {
                        subItem.parentID = Int64(id)
                    }
                }
                
                // After subItems taken care of, the current item's ID is updated.
                item.id = Int64(id)
                id += 1
                
                saveData()
                
            }
            
        } else {
            
            print("There was no array passed to the updateIDs() function in the DataModel.")
            
        }
        
    }
    
    func updateLevels(forItems items: [Item]?) {
        
        var subItems = [Item]()
        
        if items != nil {
            
            guard let items = items else { return print("There were no Items loaded in the updateIDs function in DataModel.") }
            
            for item in items {
                
                // ID and Level before new IDs are set
                let itemID = Int(item.id)
                let subItemLevel = Int(item.level + 1)
                
                // Reset array and load subitems based on item info before it is changed.
                subItems = []
                subItems = loadSpecificItems(forCategory: item.category!, forLevel: subItemLevel, forParentID: itemID, andParentName: item.name!)
                
                // If the old id AND name match, then the subItem's parentID is updated.
                // Matching the name AND old id makes sure that when the new IDs are set for the parents, even if they match some of the other subItems' parentID, they won't match the name, as well, so this filters them out.
                if subItems.count > 0 {
                    updateLevels(forItems: subItems)
                }
                
                // After subItems taken care of, the current item's level is updated.
                item.level = item.level + 1
                
                saveData()
                
            }
            
        } else {
            
            print("There was no array passed to the updateIDs() function in the DataModel.")
            
        }
        
    }
    
    func toggleDoneForAllItems(doneStatus: Bool, forCategory category: String, forLevel level: Int, forParentID parentID: Int, andParentName parentName: String) {
        
        let itemsToToggle = loadSpecificItems(forCategory: category, forLevel: level, forParentID: parentID, andParentName: parentName)
        
        for item in itemsToToggle {
            
            item.done = doneStatus
            
        }
        
        saveData()
        
    }
    
    
    
    
    // MARK: - DELETE
    
    func deleteAllItems() {
        itemsToDeleteQueue = loadAllItems()
        deleteItemsInItemsToDeleteArray()
    }
    
    func deleteItemsInItemsToDeleteArray() {
        
        for item in itemsToDeleteQueue {
            context.delete(item)
        }
        
        itemsToDeleteQueue = []
        
        saveData()
        
    }
    
    
    func addSubItemsToDeleteQueue(forCategory category: String, forLevel level: Int, forID id: Int, andName name: String) {
        
        let subItemLevel = level + 1
        
        let subItems = loadSpecificItems(forCategory: category, forLevel: subItemLevel, forParentID: id, andParentName: name)
        
        for subItem in subItems {
            
            let subItemID = Int(subItem.id)
            let subItemName = subItem.name!
            let subItemLevel = Int(subItem.level)
            let furtherSubItemLevel = Int(subItem.level + 1)
            
            let furtherSubItems = loadSpecificItems(forCategory: category, forLevel: furtherSubItemLevel, forParentID: subItemID, andParentName: subItemName)
            
            if !furtherSubItems.isEmpty {
            
                addSubItemsToDeleteQueue(forCategory: category, forLevel: subItemLevel, forID: subItemID, andName: subItemName)
                
            }
            
            itemsToDeleteQueue.append(subItem)
            
        }
        
    }
    
    func deleteSpecificItem(forItem item: Item) {
        
        let itemCategory = item.category!
        let itemLevel = Int(item.level)
        let itemParentID = Int(item.parentID)
        let itemParentName = item.parentName!
        let itemName = item.name!
        let itemID = Int(item.id)
        
        context.delete(item)
        saveData()
        
        let currentItemGroup = loadSpecificItems(forCategory: itemCategory, forLevel: itemLevel, forParentID: itemParentID, andParentName: itemParentName)
        
        updateIDs(forItems: currentItemGroup)
        
        addSubItemsToDeleteQueue(forCategory: itemCategory, forLevel: itemLevel, forID: itemID, andName: itemName)
        
        deleteItemsInItemsToDeleteArray()
        
    }
    
}















