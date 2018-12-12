//
//  MoveItemViewController.swift
//  MyList
//
//  Created by Adam Moore on 12/5/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class MoveItemViewController: UIViewController {
    
    var itemBeingMoved: Item?
    
    var currentMoveVC = String()
    
    var currentLevel = Int()
    
    // Used for when an item is opened to see the subItems, but no subItem is clicked.
    // This makes the opened item the CURRENT item, and allows for moving an item to that new parent item.
    var currentItem: Item?
    
    var selectedItem: Item?
    var selectedIndexPath = IndexPath()
    
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func move(_ sender: UIBarButtonItem) {
        if let newParentItem = selectedItem {

            if let itemBeingMoved = itemBeingMoved {
                
                let newParentItemName = (Int(newParentItem.level) == 0) ? newParentItem.name!.lowercased() : newParentItem.name!
                let newParentItemCategory = (Int(newParentItem.level) == 0) ? newParentItem.name!.lowercased() : newParentItem.category!
                let newParentItemLevel = Int(newParentItem.level)
                let newParentItemID = Int(newParentItem.id)
                
                let possibleSiblingItems = DataModel.shared.loadSpecificItems(forCategory: newParentItemCategory, forLevel: newParentItemLevel + 1, forParentID: newParentItemID, andParentName: newParentItemName, ascending: true)
                
                if ValidationModel.shared.isValid(itemName: itemBeingMoved.name!, forItems: possibleSiblingItems, isGrouping: false, itemsToGroup: nil) == .success {
                    let alert = ValidationModel.shared.alertForInvalidItem(doSomethingElse: nil)
                    present(alert, animated: true, completion: nil)
                } else {
                    let alert = ValidationModel.shared.alertForInvalidItem(doSomethingElse: nil)
                    present(alert, animated: true, completion: nil)
                }
                
            }
            
        } else {
            print("No item on clicking 'Move' selected.")
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        currentMoveVC = self.title!
        
        toggleMoveButton()
        
        if selectedItem == nil {
            selectedItem = currentItem
        }
        
    }
    
    func toggleMoveButton() {
        moveButton.isEnabled = (currentLevel == 0 && selectedItem == nil) ? false : true
    }
    
    func selectItem(forIndexPath indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        toggleMoveButton()
    }
    
    func deselectItem() {
        
        if currentLevel == 0 {
            selectedItem = nil
        } else {
            selectedItem = currentItem
        }
        
        toggleMoveButton()
    }

}



// *** MARK: - TableView Delegate and DataSource

extension MoveItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        let item = items[indexPath.row]
        
        if selectedIndexPath == indexPath {
            cell.backgroundColor = Keywords.shared.lightGreenBackground12
        } else {
            cell.backgroundColor = Keywords.shared.lightBlueBackground
        }
        
        cell.nameLabel.text = item.name!
        
        cell.checkboxImageWidth.constant = 0
        
        // Consolidate this information into the model
        
        var numOfSubItemsDone = Int()
        let itemName = (currentLevel == 0) ? item.name!.lowercased() : item.name!
        let itemCategory = (currentLevel == 0) ? item.name!.lowercased() : item.category!
        let subItems = DataModel.shared.loadSpecificItems(forCategory: itemCategory, forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: itemName, ascending: true)
        
        for subItem in subItems {
            numOfSubItemsDone += subItem.done ? 1 : 0
        }
        
        if subItems.count > 0 {
            cell.numberLabel.text = "\(numOfSubItemsDone)/\(subItems.count)"
            cell.numberLabelWidth.constant = 60
        } else {
            cell.numberLabel.text = ""
            cell.numberLabelWidth.constant = 0
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        
        let itemName = (currentLevel == 0) ? item.name!.lowercased() : item.name!
        let itemCategory = (currentLevel == 0) ? item.name!.lowercased() : item.category!
        let subItems = DataModel.shared.loadSpecificItems(forCategory: itemCategory, forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: itemName, ascending: true)
        
        if subItems.count > 0 {
            
            selectItem(forIndexPath: indexPath)
            
            if currentMoveVC == "moveItem1" {
                performSegue(withIdentifier: Keywords.shared.moveItem1ToMoveItem2Segue, sender: self)
            } else {
                performSegue(withIdentifier: Keywords.shared.moveItem2ToMoveItem1Segue, sender: self)
            }
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        } else {
            
            if selectedIndexPath != indexPath {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
                selectItem(forIndexPath: indexPath)
                selectedIndexPath = indexPath
            } else {
                tableView.deselectRow(at: selectedIndexPath, animated: false)
                selectedIndexPath = IndexPath()
                deselectItem()
            }
            
        }
        
        if let sItem = selectedItem {
            print("\(sItem.name!)")
        } else {
            print("There was no item in the table selected.")
        }
        
        
    }
    
}



// *** MARK: - Segues

extension MoveItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MoveItemViewController
        
        destinationVC.currentItem = selectedItem
        destinationVC.selectedItem = selectedItem
        
        if let sItem = selectedItem {
            
            destinationVC.itemBeingMoved = itemBeingMoved
            
            destinationVC.currentLevel = Int(sItem.level) + 1
            
            let casedParentName = (currentLevel == 0) ? sItem.name!.lowercased() : sItem.name!
            let category = (currentLevel == 0) ? sItem.name!.lowercased() : sItem.category!
            
            let itemsToOpen = DataModel.shared.loadSpecificItems(forCategory: category, forLevel: Int(sItem.level) + 1, forParentID: Int(sItem.id), andParentName: casedParentName, ascending: true)
            
            destinationVC.items = itemsToOpen
            
            destinationVC.itemModel.items = itemsToOpen
            
            destinationVC.navigationItem.title = sItem.name!
            
        } else {
            print("No item selected")
        }
        
        selectedIndexPath = IndexPath()
        selectedItem = nil
        
    }
    
}






