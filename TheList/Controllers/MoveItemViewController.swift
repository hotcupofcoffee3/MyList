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
    var currentCategory = String()
    var currentParentName = String()
    var currentParentID = Int()
    
    var selectedLevel = Int()
    var selectedCategory = String()
    var selectedParentName = String()
    var selectedParentID = Int()
    
    var newlySelectedItem: Item?
    var cellIsSelected = false
    var selectedIndexPath = IndexPath()
    
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
            
            if currentMoveVC == "moveItem1" {
                performSegue(withIdentifier: Keywords.shared.moveItem1ToMoveItem2Segue, sender: self)
            } else {
                performSegue(withIdentifier: Keywords.shared.moveItem2ToMoveItem1Segue, sender: self)
            }
            
        }
    }
    
    func selectItem(forIndexPath indexPath: IndexPath) {
        selectedCategory = (currentLevel == 0) ? items[indexPath.row].name!.lowercased() : items[indexPath.row].category!
        selectedParentName = items[indexPath.row].name!
        selectedLevel = Int(items[indexPath.row].level) + 1
        selectedParentID = Int(items[indexPath.row].id)
    }
    
    func deselectItem() {
        selectedCategory = ""
        selectedParentName = ""
        selectedLevel = 0
        selectedParentID = 0
    }

}



// Segues

extension MoveItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MoveItemViewController
        
        destinationVC.currentLevel = selectedLevel
        destinationVC.currentCategory = selectedCategory
        destinationVC.currentParentName = selectedParentName
        destinationVC.currentParentID = selectedParentID
        
        // Level 1 items automatically have the parentName of the rawValue of the SelectedCategory. The rest will have a parentName that is the string of the item, so casing will be mixed.
        let casedParentName = (currentLevel == 0) ? selectedParentName.lowercased() : selectedParentName
        
        destinationVC.items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory, forLevel: selectedLevel, forParentID: selectedParentID, andParentName: casedParentName)
        
        destinationVC.navigationItem.title = selectedParentName
        
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
        
        
        cell.backgroundColor = Keywords.shared.lightBlueBackground
        
        cell.nameLabel.text = items[indexPath.row].name!
        
        cell.numberLabel.text = "\(items[indexPath.row].id)"
//        cell.numberLabelWidth.constant = 0
        
        cell.checkboxImageWidth.constant = 0
       
        // Set up the cell's contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        // Maybe make it check if the selected cell is the same index path that was selected, and if so, do nothing.
        // Otherwise, deselect the cell that was the selectedIndexPath???
        
        // At this point, the long press is not selecting any cell if it wasn't already clicked on to be selected.
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        cellIsSelected = (selectedIndexPath == indexPath) ? false : true

        if cellIsSelected {
            selectItem(forIndexPath: indexPath)
            selectedIndexPath = indexPath
        } else {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
            deselectItem()
        }

    }
    
}
