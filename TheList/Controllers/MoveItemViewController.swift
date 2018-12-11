//
//  MoveItemViewController.swift
//  MyList
//
//  Created by Adam Moore on 12/5/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class MoveItemViewController: UIViewController {
    
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
        if let item = selectedItem {
//            print("Level \(currentLevel): \((Int(item.level) == 0) ? item.name!.lowercased() : item.name!)")
//            print("ParentLevel: \(Int(item.level))")
            
            let itemName = (Int(item.level) == 0) ? item.name!.lowercased() : item.name!
            itemModel.items = items
            
            
            // Need to make the clicking of the item from the main view a variable that is sent here, so there is an item that is being moved.
            // Need to check on the isValidName function to see why it is saying that you can add an item with the same name in the same area, as it seems like the check is loading the siblings of the one being clicked in the move area, because when an item is clicked within a parent, in otherwords, a sibling that matches, it SHOULD check to see if there is a matching item INSIDE that clicked item, but it isn't.
            // All of these checks need to be made in the 'move()' function in the DataModel, and maybe a different 'isValidName' function needs to be in the MoveVC, or maybe a modification of the function in the itemModel to make it take a parameter???
            // Either way, the alerts are popping up, just not quite right.
            // Also, maybe clean up the 'items' and 'itemModel' variables in the MoveVC so that there aren't two different instances of the variable 'items' that are being thrown around, as the 'itemModel.items' is the standard one that is used in the main area, but the local 'items' variable is the one used mostly here, so they are disconnected from the 'isValidName()' function that uses the 'itemModel's instance of 'items' to run its function, which is why there is no parameter needed for it. But that is throwing things off for me in the MoveVC, since it uses a different instance of 'items' that has been set locally.
            
            
            if itemModel.isValidName(forItemName: itemName) == .success {
                print(item.name!)
                let alert = UIAlertController(title: "Good!", message: "You can add it!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            } else {
                print(item.name!)
                let alert = UIAlertController(title: "Nope!", message: "You canNOT add it!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Shit", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Try again", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
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
        if let item = selectedItem {
            print("Level \(currentLevel): \((currentLevel == 0) ? item.name!.lowercased() : item.name!)")
            print("ParentLevel: \(Int(item.level))")
        } else {
            print("There was no 'selectedItem' when the view appeared.")
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






