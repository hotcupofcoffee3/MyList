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
    
//    var currentCategory = String()
//    var currentParentName = String()
//    var currentParentID = Int()
//
//    var selectedLevel = Int()
//    var selectedCategory = String()
//    var selectedParentName = String()
//    var selectedParentID = Int()
    
    // currentItem is only used for moving if it is clicked and opened to see its children, but no children are selected.
    var currentItem: Item?
    
    // selectedItem is used every other time when an item is selected, except for, as above, when an item is opened to see its children, but no child item is selected.
    var selectedItem: Item?
    var cellIsHighlighted = false
    var highlightedIndexPath = IndexPath()
    
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentMoveVC = self.title!
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
    
    func selectItem(forIndexPath indexPath: IndexPath) {
//        selectedCategory = (currentLevel == 0) ? items[indexPath.row].name!.lowercased() : items[indexPath.row].category!
//        selectedParentName = items[indexPath.row].name!
//        selectedLevel = Int(items[indexPath.row].level) + 1
//        selectedParentID = Int(items[indexPath.row].id)
        selectedItem = items[indexPath.row]
    }
    
    func deselectItem() {
//        selectedCategory = ""
//        selectedParentName = ""
//        selectedLevel = 0
//        selectedParentID = 0
        selectedItem = nil
    }

}



// Segues

extension MoveItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MoveItemViewController
        
//        destinationVC.currentLevel = selectedLevel
//        destinationVC.currentCategory = selectedCategory
//        destinationVC.currentParentName = selectedParentName
//        destinationVC.currentParentID = selectedParentID
        destinationVC.currentItem = selectedItem
        
        // Level 1 items automatically have the parentName of the rawValue of the SelectedCategory. The rest will have a parentName that is the string of the item, so casing will be mixed.
//        let casedParentName = (currentLevel == 0) ? selectedParentName.lowercased() : selectedParentName
//
//        destinationVC.items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory, forLevel: selectedLevel, forParentID: selectedParentID, andParentName: casedParentName)
//
//        destinationVC.navigationItem.title = selectedParentName
        
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



extension MoveItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        if highlightedIndexPath == indexPath {
            cell.backgroundColor = Keywords.shared.lightGreenBackground12
        } else {
            cell.backgroundColor = Keywords.shared.lightBlueBackground
        }
        
        cell.nameLabel.text = items[indexPath.row].name!
        
        cell.numberLabel.text = "\(items[indexPath.row].id)"
//        cell.numberLabelWidth.constant = 0
        
        cell.checkboxImageWidth.constant = 0
       
        // Set up the cell's contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // Selects new item when a new cell is highlighted than was previously highlighted.
        // If highlightedIndexPath does not match the current indexPath, it deselects the old highlightedIndexPath, selects the new item at the current indexPath, and sets the highlightedIndexPath to the newly indexPath.
        
        // If the same cell that was recently selected is highlighted again, then the row is deselected and the highlightedIndexPath is set to NOTHING.
        // The didSelectRowAt is responsible for deselecting the item, as if the user longPresses, then only didHighlightRowAt gets called, so we don't want to deselect the Item, as this will send us to the child.
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
        
        if highlightedIndexPath != indexPath {
            tableView.deselectRow(at: indexPath, animated: false)
            deselectItem()
        }
        
    }
    
}






