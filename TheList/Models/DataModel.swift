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
        
        if UserDefaults.standard.object(forKey: Keywords.shared.defaultCategoriesCreated) == nil {
            
            UserDefaults.standard.set(0, forKey: Keywords.shared.lastUsedID)
            
            addNewItem(name: "Home", parentID: 0)
            addNewItem(name: "Errands", parentID: 0)
            addNewItem(name: "Work", parentID: 0)
            addNewItem(name: "Other", parentID: 0)
            
            UserDefaults.standard.set(true, forKey: Keywords.shared.defaultCategoriesCreated)
            
        }
        
//        let items = loadAllItems()
//        for item in items {
//            print(item.id)
//        }
        
    }
    
    
    
    // MARK: - CREATE
    
    func saveData() {
        do {
            try context.save()
        } catch {
            print("Error saving in the Data model: \(error)")
        }
    }
    
    func assignAndSaveNextUniqueID() -> Int {
        let id = (UserDefaults.standard.object(forKey: Keywords.shared.lastUsedID) as! Int) + 1
        UserDefaults.standard.set(id, forKey: Keywords.shared.lastUsedID)
        return id
    }
    
    func addNewItem(name: String, parentID: Int) {
        
        let newID = assignAndSaveNextUniqueID()
        
        let newOrderNumber = loadSpecificItems(forParentID: parentID, ascending: true).count + 1
        
        let newItem = Item(context: context)
        newItem.name = name
        newItem.done = false
        newItem.id = Int64(newID)
        newItem.parentID = Int64(parentID)
        newItem.orderNumber = Int64(newOrderNumber)
        
        saveData()
        
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
        return loadSpecificItems(forParentID: 0, ascending: true)
    }
    
    func loadSpecificItems(forParentID parentID: Int, ascending: Bool) -> [Item] {

        var items = [Item]()

        let request: NSFetchRequest<Item> = Item.fetchRequest()

        request.predicate = NSPredicate(format: Keywords.shared.parentIDMatch, String(parentID))
        
        request.sortDescriptors = [NSSortDescriptor(key: Keywords.shared.orderNumberKey, ascending: ascending)]

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
    
//    func loadParentItem(forID id: Int, andName name: String) -> Item {
//
//        var items = [Item]()
//
//        let request: NSFetchRequest<Item> = Item.fetchRequest()
//
//        let idPredicate = NSPredicate(format: Keywords.shared.idMatch, String(id))
//
//        let namePredicate = NSPredicate(format: Keywords.shared.nameMatch, String(name))
//
//        let predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [idPredicate, namePredicate])
//
//        request.predicate = predicate
//
//        do {
//            items = try context.fetch(request)
//        } catch {
//            //            print("Error loading All Items in the Data model: \(error)")
//        }
//
//        if items.count == 0 {
//            //            print("There are no Items loaded from the Data model")
//        } else if items.count > 1 {
//            //            print("There is more than 1 Item loaded for the ID from the Data model")
//        }
//
//        return items[0]
//
//    }
    
    
    
    // MARK: - UPDATE
    
    func updateItem(forProperties itemProperties: [ItemProperty], forItem item: Item, withNewParentID newParentID: Int?, withNewName newName: String?, withNewOrderNumber newOrderNumber: Int?) {
        
        let itemToUpdate = item
        
        for property in itemProperties {
            
            switch property {
            
            case .parentID :
                itemToUpdate.parentID = Int64(newParentID!)
              
            case .name :
                updateName(forItem: itemToUpdate, withNewName: newName!)
                
            case .orderNumber :
                itemToUpdate.orderNumber = Int64(newOrderNumber!)
               
            default: break
                
            }
            
            saveData()
                
        }
        
    }
    
    func updateAllItemsAreDone(forItem: Item) {
        
        var allItemsAreDone = true
        
        let itemToUpdate = forItem
        
        let subItemParentID = Int(forItem.id)
        
        let subItems = loadSpecificItems(forParentID: subItemParentID, ascending: true)
        
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
    
    func updateDone(forItem item: Item) {
        item.done = !item.done
        saveData()
    }
    
    func updateOrderNumbers(forItems items: [Item], ascending: Bool) {
        
        var orderNumber = ascending ? 1 : items.count
        
        for item in items {
                
            item.orderNumber = Int64(orderNumber)
            orderNumber = ascending ? (orderNumber + 1) : (orderNumber - 1)
            
            saveData()
            
        }
        
    }
    
    func updateName(forItem itemToUpdate: Item, withNewName newName: String?) {
        
        if newName != nil && newName != "" {
            
            itemToUpdate.name = newName
            
        }
        
        saveData()
        
    }
    
//    func updateParentID(forItems items: [Item], withNewParentID newParentID: Int) {
//
//        for item in items {
//            item.parentID = Int64(newParentID)
//        }
//
//        saveData()
//
//    }
    
    func toggleDoneForAllItems(doneStatus: Bool, forParentID parentID: Int) {
        
        let itemsToToggle = loadSpecificItems(forParentID: parentID, ascending: true)
        
        for item in itemsToToggle {
            
            item.done = doneStatus
            
        }
        
        saveData()
        
    }
    
    func move(item itemToMove: Item, toParentItem parentItem: Item) {
        
        let oldParentID = Int(itemToMove.parentID)
        let sameID = Int(itemToMove.id)

        let newParentID = Int(parentItem.id)
        let newOrderNumber = loadSpecificItems(forParentID: newParentID, ascending: true).count + 1
        
        let newSubItemParentID = sameID

        
        // *** Subitems only need their parentID updated.
        // *** ParentID has to be updated below after the itemToMove's id has been updated.
        
        
        // Update subItems for itemToMove using the old information for retrieval and new information for updating.

        let subItems = loadSpecificItems(forParentID: sameID, ascending: true)
        
        for subItem in subItems {
            updateItem(forProperties: [.parentID], forItem: subItem, withNewParentID: newSubItemParentID, withNewName: nil, withNewOrderNumber: nil)
        }
        
        
        // Update itemToMove parentID
        
        updateItem(forProperties: [.parentID, .orderNumber], forItem: itemToMove, withNewParentID: newParentID, withNewName: nil, withNewOrderNumber: newOrderNumber)
        
        
        // Update orderNumber for the old sibling items, now that it is no longer in there.
        
        let oldSiblings = loadSpecificItems(forParentID: oldParentID, ascending: true)
        
        updateOrderNumbers(forItems: oldSiblings, ascending: true)
        
    }
    
    func group(items: [Item], intoNewItemName newItemName: String, withNewItemParentID newItemParentID: Int) {
        
        // 1: Add new Item that will be the parent of the selected Items to be grouped.
        //    Function calls saveData()
        addNewItem(name: newItemName, parentID: newItemParentID)
        
        // 2. Update the parentID based on the new Parent's ID
        let newlyCreatedParentItemID = UserDefaults.standard.object(forKey: Keywords.shared.lastUsedID) as! Int
        for item in items {
            item.parentID = Int64(newlyCreatedParentItemID)
        }
        saveData()
        
        // 3. Update order numbers
        //    Function calls saveData()
        updateOrderNumbers(forItems: items, ascending: true)
        
        
        // 5: Update the order numbers for the main are where the items were grouped and where the new Parent Item was created.
        //    Function calls saveData()
        let siblingItems = loadSpecificItems(forParentID: newItemParentID, ascending: true)
        updateOrderNumbers(forItems: siblingItems, ascending: true)
        
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
    
    
    func addSubItemsToDeleteQueue(forID id: Int) {
        
        let subItems = loadSpecificItems(forParentID: id, ascending: true)
        
        for subItem in subItems {
            
            let subItemID = Int(subItem.id)
            
            let furtherSubItems = loadSpecificItems(forParentID: subItemID, ascending: true)
            
            if !furtherSubItems.isEmpty {
            
                addSubItemsToDeleteQueue(forID: subItemID)
                
            }
            
            itemsToDeleteQueue.append(subItem)
            
        }
        
    }
    
    func deleteSpecificItem(forItem item: Item) {
        
        let itemParentID = Int(item.parentID)
        let itemID = Int(item.id)
        
        context.delete(item)
        saveData()
        
        let currentItemGroup = loadSpecificItems(forParentID: itemParentID, ascending: true)
        
        updateOrderNumbers(forItems: currentItemGroup, ascending: true)
        
        addSubItemsToDeleteQueue(forID: itemID)
        
        deleteItemsInItemsToDeleteArray()
        
    }
    
    func deleteSubItems(forItem parentItem: Item, inTable tableView: UITableView) -> UIAlertController {
        
        let alert = UIAlertController(title: "Are you sure?", message: "This will delete all subitems", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
            
            let id = Int(parentItem.id)
            
            DataModel.shared.addSubItemsToDeleteQueue(forID: id)
            
            DataModel.shared.deleteItemsInItemsToDeleteArray()
            
            HapticsModel.shared.hapticExecuted(as: .success)
            
            tableView.reloadData()
            
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        return alert
        
    }
    
}















