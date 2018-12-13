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
    
    private init() {
        
        let none = SelectedCategory.none.rawValue
        
        let defaultItems = loadSpecificItems(forCategory: none, forLevel: 0, forParentID: 0, andParentName: none, ascending: true)
        
        if defaultItems.count == 0 {
            
//            print("Default items starting items: \(defaultItems.count)")
            
            addNewItem(name: "Home", forCategory: .none, level: 0, parentID: 0, parentName: none)
            addNewItem(name: "Errands", forCategory: .none, level: 0, parentID: 0, parentName: none)
            addNewItem(name: "Work", forCategory: .none, level: 0, parentID: 0, parentName: none)
            addNewItem(name: "Other", forCategory: .none, level: 0, parentID: 0, parentName: none)
            
//            let newlyCreatedDefaultItems = loadSpecificItems(forCategory: none, forLevel: 0, forParentID: 0, andParentName: none)
            
//            print("Default items created: \(newlyCreatedDefaultItems.count)")
            
        } else {
            
//            print("Default items already created: \(defaultItems.count)")
            
        }
        
    }
    
    
    
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
            default: print("SubItems category was selected for adding a new Item.")
                
            }
            
            if category != .subItems1 && category != .subItems2 {
                newParentName = category.rawValue
            }
            
        } else {
            newParentID = parentID
            newParentName = parentName
        }
        
        
        let calculatedID = loadSpecificItems(forCategory: category.rawValue, forLevel: level, forParentID: parentID, andParentName: parentName, ascending: true).count + 1
        
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
        // --- Use the 'updateLevel()' function.
        for item in items {
            updateLevel(forItem: item)
        }
        
        
        
        
        // 2:
        // --- Load all of the Newly Grouped Items with the new level.
        // --- Update the parentName.
        let newlyLeveledItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: newItemParentID, andParentName: newItemParentName, ascending: true)
        
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
        let newItemID = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel, forParentID: newItemParentID, andParentName: newItemParentName, ascending: true).count
        
        // 'newItemParentID' is used initially because the 'newItemID' has not been set for this group of items.
        let oldParentID = newItemParentID
        let subItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: oldParentID, andParentName: newItemName, ascending: true)
        
        for subItem in subItems {
            subItem.parentID = Int64(newItemID)
        }
        saveData()
        
        
        // 5:
        // --- Update the IDs of the grouped items, as they will now be different, since they are in their own group, and are therefore ordered differently.
        let newlyGroupedItems = loadSpecificItems(forCategory: category.rawValue, forLevel: newItemLevel + 1, forParentID: newItemID, andParentName: newItemName, ascending: true)
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
    
    // This one is strictly for readability in the MoveItemVC
    func loadDefaultItems() -> [Item] {
        return loadSpecificItems(forCategory: SelectedCategory.none.rawValue, forLevel: 0, forParentID: 0, andParentName: SelectedCategory.none.rawValue, ascending: true)
    }
    
    
    // *** MAKE ASCENDING TO BE A PARAMETER
    
    func loadSpecificItems(forCategory category: String, forLevel level: Int, forParentID parentID: Int, andParentName parentName: String, ascending: Bool) -> [Item] {

        var items = [Item]()

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        let parentIDPredicate = NSPredicate(format: Keywords.shared.parentIDMatch, String(parentID))
        let parentNamePredicate = NSPredicate(format: Keywords.shared.parentNameMatch, String(parentName))
        let categoryPredicate = NSPredicate(format: Keywords.shared.categoryMatch, category)
        let levelPredicate = NSPredicate(format: Keywords.shared.levelMatch, String(level))
        
        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [parentIDPredicate, parentNamePredicate, categoryPredicate, levelPredicate])

        request.predicate = predicate
        
        request.sortDescriptors = [NSSortDescriptor(key: Keywords.shared.idKey, ascending: ascending)]

        do {
            items = try context.fetch(request)
        } catch {
//                        print("Error loading All Items in the Data model: \(error)")
        }

        if items.count == 0 {
//                        print("There are no Items loaded from the Data model")
        }
        
        if !items.isEmpty {
            for item in items {
                updateAllItemsAreDone(forItem: item)
            }
        }
        
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
    
    func updateItem(forProperties itemProperties: [ItemProperty], forItem item: Item, atNewLevel newLevel: Int?, inNewCategory newCategory: String?, withNewParentID newParentID: Int?, andNewParentName newParentName: String?, withNewName newName: String?, withNewID newID: Int?) {
        
        let itemToUpdate = item
        
        for property in itemProperties {
            
            switch property {
                
            case .done :
                itemToUpdate.done = !itemToUpdate.done
                
            case .level :
                itemToUpdate.level = Int64(newLevel!)
                
            case .category :
                itemToUpdate.category = newCategory!
                
            case .parentID :
                itemToUpdate.parentID = Int64(newParentID!)
                
            case .parentName :
                itemToUpdate.parentName = newParentName!
                
            case .name :
                updateName(forItem: itemToUpdate, withNewName: newName!)
                
            case .id :
                itemToUpdate.id = Int64(newID!)
                
            }
            
            saveData()
                
        }
        
    }
    
    func updateAllItemsAreDone(forItem: Item) {
        
        var allItemsAreDone = true
        
        let itemToUpdate = forItem
        
        let subItemCategory = forItem.category!
        let subItemLevel = Int(forItem.level + 1)
        let subItemParentID = Int(forItem.id)
        let subItemParentName = forItem.name!
        
        let subItems = loadSpecificItems(forCategory: subItemCategory, forLevel: subItemLevel, forParentID: subItemParentID, andParentName: subItemParentName, ascending: true)
        
        if !subItems.isEmpty {
            
            for subItem in subItems {
                
                if subItem.done == false {
                    allItemsAreDone = false
                }
                
            }
            
            itemToUpdate.done = allItemsAreDone
            
            saveData()
            
        }
        
    }
    
    func updateIDs(forItems items: [Item]) {
        
        var id = 1
        
        var subItems = [Item]()
        
        for item in items {
                
            // ID and Level before new IDs are set
            let oldID = Int(item.id)
            let subItemLevel = Int(item.level + 1)
            
            // Reset array and load subitems based on item info before it is changed.
            subItems = []
            subItems = loadSpecificItems(forCategory: item.category!, forLevel: subItemLevel, forParentID: oldID, andParentName: item.name!, ascending: true)
            
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
        
    }
    
    func updateName(forItem itemToUpdate: Item, withNewName newName: String?) {
        
        if newName != nil && newName != "" {
            
            let subItems = loadSpecificItems(forCategory: itemToUpdate.category!, forLevel: Int(itemToUpdate.level + 1), forParentID: Int(itemToUpdate.id), andParentName: itemToUpdate.name!, ascending: true)
            
            updateParentName(forItems: subItems, withNewParentName: newName)
            
            itemToUpdate.name = newName
            
        }
        
        saveData()
        
    }
    
    func updateCategory(forItems items: [Item], withNewCategory newCategory: String) {
        
        var subItems = [Item]()
        
        for item in items {
                
            // ID and Level before new IDs are set
            let itemID = Int(item.id)
            let subItemLevel = Int(item.level + 1)
            
            // Reset array and load subitems based on item info before it is changed.
            subItems = []
            subItems = loadSpecificItems(forCategory: item.category!, forLevel: subItemLevel, forParentID: itemID, andParentName: item.name!, ascending: true)
            
            // If the old id AND name match, then the subItem's parentID is updated.
            // Matching the name AND old id makes sure that when the new IDs are set for the parents, even if they match some of the other subItems' parentID, they won't match the name, as well, so this filters them out.
            if subItems.count > 0 {
                updateCategory(forItems: subItems, withNewCategory: newCategory)
            }
            
            // After subItems taken care of, the current item's level is updated.
            item.category = newCategory
            
            saveData()
                
        }
        
    }
    
    func updateLevel(forItem item: Item) {
        
        var subItems = [Item]()
        
        // ID and Level before new IDs are set
        let itemID = Int(item.id)
        let subItemLevel = Int(item.level + 1)
        
        // Reset array and load subitems based on item info before it is changed.
        subItems = []
        subItems = loadSpecificItems(forCategory: item.category!, forLevel: subItemLevel, forParentID: itemID, andParentName: item.name!, ascending: true)
        
        // If the old id AND name match, then the subItem's parentID is updated.
        // Matching the name AND old id makes sure that when the new IDs are set for the parents, even if they match some of the other subItems' parentID, they won't match the name, as well, so this filters them out.
        if subItems.count > 0 {
            for subItem in subItems {
                updateLevel(forItem: subItem)
            }
            
        }
        
        // After subItems taken care of, the current item's level is updated.
        item.level = item.level + 1
        
        saveData()
        
    }
    
    func updateParentID(forItems items: [Item], withNewParentID newParentID: Int) {
        
        for item in items {
            item.parentID = Int64(newParentID)
        }
        
        saveData()
        
    }
    
    func updateParentName(forItems items: [Item], withNewParentName newParentName: String?) {
        
        for item in items {
            item.parentName = newParentName
        }
        
        saveData()
        
    }
    
    func toggleDoneForAllItems(doneStatus: Bool, forCategory category: String, forLevel level: Int, forParentID parentID: Int, andParentName parentName: String) {
        
        let itemsToToggle = loadSpecificItems(forCategory: category, forLevel: level, forParentID: parentID, andParentName: parentName, ascending: true)
        
        for item in itemsToToggle {
            
            item.done = doneStatus
            
        }
        
        saveData()
        
    }
    
    func move(item itemToMove: Item, toParentItem parentItem: Item) {
        
        // ****** Have to uncomment and finish this section, but for now, it does nothing when clicked from the "MoveVC"
        
        // The main Home, Errands, Work, and Other have a level of 0 and category of "none", so these have to be checked.
        let isParentLevel0 = (Int(parentItem.level) == 0) ? true : false

        let sameName = itemToMove.name!
        let oldCategory = itemToMove.category!
        let oldLevel = Int(itemToMove.level)
        let oldSubitemLevel = oldLevel + 1
        let oldID = Int(itemToMove.id)

        let newCategory = isParentLevel0 ? parentItem.name!.lowercased() : parentItem.category!
        let newLevel = Int(parentItem.level + 1)
        let newParentID = Int(parentItem.id)
        let newParentName = isParentLevel0 ? parentItem.name!.lowercased() : parentItem.name!
        let newID = loadSpecificItems(forCategory: newCategory, forLevel: Int(newLevel), forParentID: Int(newParentID), andParentName: newParentName, ascending: true).count + 1
        
        let newSubItemCategory = newCategory
        let newSubItemLevel = newLevel + 1
        let newSubItemParentID = newID

        
        // *** Subitems only need their category, level, and parentID updated.
        // *** Category and level can be updated here, but parentID has to be updated below after the itemToMove's id has been updated.
        
        
        // Update subItems for itemToMove using the old information for retrieval and new information for updating.

        let subItems = loadSpecificItems(forCategory: oldCategory, forLevel: oldSubitemLevel, forParentID: oldID, andParentName: sameName, ascending: true)
        
        for subItem in subItems {
            updateItem(forProperties: [.category, .level, .parentID], forItem: subItem, atNewLevel: newSubItemLevel, inNewCategory: newSubItemCategory, withNewParentID: newSubItemParentID, andNewParentName: nil, withNewName: nil, withNewID: nil)
        }
        
        
        // Update itemToMove: category, level, parentID, parentName, and id
        
        updateItem(forProperties: [.category, .level, .parentID, .parentName, .id], forItem: itemToMove, atNewLevel: newLevel, inNewCategory: newCategory, withNewParentID: newParentID, andNewParentName: newParentName, withNewName: nil, withNewID: newID)
        
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
        
        let subItems = loadSpecificItems(forCategory: category, forLevel: subItemLevel, forParentID: id, andParentName: name, ascending: true)
        
        for subItem in subItems {
            
            let subItemID = Int(subItem.id)
            let subItemName = subItem.name!
            let subItemLevel = Int(subItem.level)
            let furtherSubItemLevel = Int(subItem.level + 1)
            
            let furtherSubItems = loadSpecificItems(forCategory: category, forLevel: furtherSubItemLevel, forParentID: subItemID, andParentName: subItemName, ascending: true)
            
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
        
        let currentItemGroup = loadSpecificItems(forCategory: itemCategory, forLevel: itemLevel, forParentID: itemParentID, andParentName: itemParentName, ascending: true)
        
        updateIDs(forItems: currentItemGroup)
        
        addSubItemsToDeleteQueue(forCategory: itemCategory, forLevel: itemLevel, forID: itemID, andName: itemName)
        
        deleteItemsInItemsToDeleteArray()
        
    }
    
    func deleteSubItems(forItem parentItem: Item, inTable tableView: UITableView) -> UIAlertController {
        
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete all subitems", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            
            let category = parentItem.category!
            let level = Int(parentItem.level)
            let id = Int(parentItem.id)
            let name = parentItem.name!
            
            DataModel.shared.addSubItemsToDeleteQueue(forCategory: category, forLevel: level, forID: id, andName: name)
            
            DataModel.shared.deleteItemsInItemsToDeleteArray()
            
            HapticsModel.shared.hapticExecuted(as: .success)
            
            tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
        
    }
    
}















