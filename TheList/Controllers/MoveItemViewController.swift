//
//  MoveItemViewController.swift
//  MyList
//
//  Created by Adam Moore on 12/5/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class MoveItemViewController: UIViewController {
    
    var itemsBeingMoved = [Item]()
    
    var isMainCategoryLevel = true
    
    var selectedView = String()
    
    // Used for when an item is opened to see the subItems, but no subItem is clicked.
    // This makes the opened item the CURRENT item, and allows for moving an item to that new parent item.
    var currentItem: Item?
    
    var selectedItem: Item?
    var selectedIndexPath = IndexPath()
    
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    @IBOutlet weak var labelForItemBeingMoved: UILabel!
    
    @IBOutlet weak var textFieldForNewParentItem: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var moveButton: UIBarButtonItem!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func move(_ sender: UIBarButtonItem) {
        
        if let selectedItem = selectedItem {
            
            var alertMessage = String()
            
            if itemsBeingMoved.count == 1 {
                alertMessage = "Move: \(itemsBeingMoved[0].name!)\n\nTo: \(selectedItem.name!)"
            } else {
                alertMessage = "Move: \(itemsBeingMoved.count) items\n\nTo: \(selectedItem.name!)"
            }
            
            
            
            let alert = UIAlertController(title: nil, message: alertMessage, preferredStyle: .alert)
            
            let yes = UIAlertAction(title: "Yes", style: .destructive) { (action) in
                self.moveItem()
            }
            
            let no = UIAlertAction(title: "No", style: .cancel, handler: nil)
            
            alert.addAction(yes)
            alert.addAction(no)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            print("There was no item selected to move, so something messed up.")
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
        tableView.separatorStyle = .none
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        selectedView = self.title!
        
        toggleMoveButton()
        
        if selectedItem == nil {
            selectedItem = currentItem
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        selectedView = self.title!
        
        toggleMoveButton()
        
        if selectedItem == nil {
            selectedItem = currentItem
        }
        
        labelForItemBeingMoved.text = (itemsBeingMoved.count == 1) ? "\(itemsBeingMoved[0].name!)" : "\(itemsBeingMoved.count) items"
        textFieldForNewParentItem.text = selectedItem?.name! ?? ""
        
    }
    
    func toggleMoveButton() {
        moveButton.isEnabled = (isMainCategoryLevel && selectedItem == nil) ? false : true
    }
    
    func selectItem(forIndexPath indexPath: IndexPath) {
        selectedItem = items[indexPath.row]
        textFieldForNewParentItem.text = selectedItem?.name! ?? ""
        toggleMoveButton()
    }
    
    func deselectItem() {
        selectedItem = isMainCategoryLevel ? nil : currentItem
        textFieldForNewParentItem.text = selectedItem?.name! ?? ""
        toggleMoveButton()
    }
    
    func moveItem() {
        
        if let newParentItem = selectedItem {
            
            if ValidationModel.shared.isValidMove(forItems: itemsBeingMoved, toGoToNewParentItem: newParentItem) == .success {
                
                DataModel.shared.move(items: itemsBeingMoved, toParentItem: newParentItem)
                
                
                
                var alertMessage = String()
                
                if itemsBeingMoved.count == 1 {
                    alertMessage = "\(itemsBeingMoved[0].name!) is now in \(newParentItem.name!)"
                } else {
                    alertMessage = "\(itemsBeingMoved.count) items are now in \(newParentItem.name!)"
                }
                
                
                
                let confirmationAlert = UIAlertController(title: "Done!", message: alertMessage, preferredStyle: .alert)
                
                confirmationAlert.addAction(UIAlertAction(title: "Ok", style: .default) { (action) in
                    
                    self.dismiss(animated: true, completion: nil)
                    
                })
                
                present(confirmationAlert, animated: true, completion: {
                
                    // *** Add a timer that goes off and dismisses the VC
                
                })
                
            } else {
                let alert = ValidationModel.shared.alertForInvalidItem(doSomethingElse: nil)
                present(alert, animated: true, completion: nil)
            }
            
        } else {
            print("No item on clicking 'Move' selected.")
        }
        
    }

}



// *** MARK: - TableView Delegate and DataSource

extension MoveItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        cell.selectionStyle = .none
        
        let item = items[indexPath.row]
        
        if selectedIndexPath == indexPath {
            cell.setCellColorAndImageDisplay(colorSelector: .movingSelected, doneStatus: nil)
        } else {
            cell.setCellColorAndImageDisplay(colorSelector: .movingUnselected, doneStatus: nil)
        }
        
        
        
        var itemIsMatch = false
        
        for possibleMatchingItem in itemsBeingMoved {
            if possibleMatchingItem == item {
                itemIsMatch = true
            }
        }
        
        if itemIsMatch {
            cell.nameLabel.textColor = UIColor.darkGray
        } else {
            cell.nameLabel.textColor = UIColor.darkText
        }
        
        cell.nameLabel.text = item.name!
        
        cell.checkboxImageWidth.constant = 0
        
        // Consolidate this information into the model
        
        var numOfSubItemsDone = Int()

        let subItems = DataModel.shared.loadSpecificItems(forParentID: Int(item.id), ascending: true)
        
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
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = items[indexPath.row]
        
        
        
        var itemIsMatch = false
        
        for possibleMatchingItem in itemsBeingMoved {
            if possibleMatchingItem == item {
                itemIsMatch = true
            }
            
        }
        
        
        
        if itemIsMatch {
            
            let alertMessage = (itemsBeingMoved.count == 1) ? "This item is the one being moved." : "This is one of the items being moved."
            
            let alert = UIAlertController(title: "Invalid Selection", message: alertMessage, preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            let subItems = DataModel.shared.loadSpecificItems(forParentID: Int(item.id), ascending: true)
            
            if subItems.count > 0 {
                
                selectItem(forIndexPath: indexPath)
                
                if selectedView == SelectedView.move1.rawValue {
                    performSegue(withIdentifier: Keywords.shared.move1ToMove2Segue, sender: self)
                } else {
                    performSegue(withIdentifier: Keywords.shared.move2ToMove1Segue, sender: self)
                }
                
            } else {
                
                if selectedIndexPath != indexPath {
                    selectItem(forIndexPath: indexPath)
                    selectedIndexPath = indexPath
                } else {
                    selectedIndexPath = IndexPath()
                    deselectItem()
                }
                
            }
            
            tableView.reloadData()
            
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
            
            destinationVC.isMainCategoryLevel = false
            
            destinationVC.itemsBeingMoved = itemsBeingMoved
            
            let itemsToOpen = DataModel.shared.loadSpecificItems(forParentID: Int(sItem.id), ascending: false)
            
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








