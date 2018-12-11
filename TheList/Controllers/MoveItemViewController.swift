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
    var cellIsHighlighted = false
    var highlightedIndexPath = IndexPath()
    
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func move(_ sender: UIBarButtonItem) {
        if let item = selectedItem {
            print("Level \(currentLevel): \((currentLevel == 0) ? item.name!.lowercased() : item.name!)")
            print("ParentLevel: \(Int(item.level))")
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
    }
    
    @objc func longPressGestureSelector(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state == .began {
            
            cellIsHighlighted = false
            highlightedIndexPath = IndexPath()
            
            if currentMoveVC == "moveItem1" {
                performSegue(withIdentifier: Keywords.shared.moveItem1ToMoveItem2Segue, sender: self)
            } else {
                performSegue(withIdentifier: Keywords.shared.moveItem2ToMoveItem1Segue, sender: self)
            }
            
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
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        let item = items[indexPath.row]
        
        if highlightedIndexPath == indexPath {
            cell.backgroundColor = Keywords.shared.lightGreenBackground12
        } else {
            cell.backgroundColor = Keywords.shared.lightBlueBackground
        }
        
        cell.nameLabel.text = item.name!
        
        cell.numberLabel.text = "\(item.id)"
//        cell.numberLabelWidth.constant = 0
        
        cell.checkboxImageWidth.constant = 0
        
        // Consolidate this information into the model
        
        var numOfSubItems = Int()
        var numOfSubItemsDone = Int()
        var subItems = [Item]()
        
        if currentLevel == 0 {
            
            numOfSubItems = DataModel.shared.loadSpecificItems(forCategory: item.name!.lowercased(), forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: item.name!.lowercased(), ascending: true).count
            
            subItems = DataModel.shared.loadSpecificItems(forCategory: item.name!.lowercased(), forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: item.name!.lowercased(), ascending: true)
            
        } else {
            
            numOfSubItems = DataModel.shared.loadSpecificItems(forCategory: item.category!, forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: item.name!, ascending: true).count
            
            subItems = DataModel.shared.loadSpecificItems(forCategory: item.category!, forLevel: Int(item.level) + 1, forParentID: Int(item.id), andParentName: item.name!, ascending: true)
            
        }
        
        for subItem in subItems {
            numOfSubItemsDone += subItem.done ? 1 : 0
        }
        
        if numOfSubItems > 0 {
            
            cell.numberLabel.text = "\(numOfSubItemsDone)/\(numOfSubItems)"
            cell.numberLabelWidth.constant = 60
            
        } else {
            
            cell.numberLabel.text = ""
            cell.numberLabelWidth.constant = 0
            
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // Selects new item when a new cell is highlighted than was previously highlighted.
        // If highlightedIndexPath does not match the current indexPath, it deselects the old highlightedIndexPath, selects the new item at the current indexPath, and sets the highlightedIndexPath to the newly indexPath.
        
        // If the same cell that was recently selected is highlighted again, then the row is deselected and the highlightedIndexPath is set to NOTHING.
        // The didSelectRowAt is responsible for deselecting the item from the "selectedItem" variable, as if the user longPresses, then only didHighlightRowAt gets called, so we don't want to deselect the Item, as this will send us to the child.
        // So didSelectRowAt gets called now, and since the highlightedIndexPath gets set to NOTHING, it means that the same cell was clicked on again, not just highlighted, and it deselects the row, as well as deselecting the item, so there is no item chosen.
        
        if highlightedIndexPath != indexPath {
            tableView.deselectRow(at: highlightedIndexPath, animated: false)
            selectItem(forIndexPath: indexPath)
            highlightedIndexPath = indexPath
        } else {
            tableView.deselectRow(at: highlightedIndexPath, animated: false)
            highlightedIndexPath = IndexPath()
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // If highlightedIndexPath is set back to NOTHING, then it means the cell that was already selected was clicked again, meaning it needs to deselect the row, as well as deselecting the item, so that there is not item chosen.
        
        // Otherwise, the cell is selected with this function as it normally would be.
        
        if highlightedIndexPath != indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            deselectItem()
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
            
            destinationVC.items = DataModel.shared.loadSpecificItems(forCategory: category, forLevel: Int(sItem.level) + 1, forParentID: Int(sItem.id), andParentName: casedParentName, ascending: true)
            
            destinationVC.navigationItem.title = sItem.name!
            
        } else {
            print("No item selected")
        }
        
    }
    
}






