//
//  CategoryAndItemViewController.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class CategoryAndItemViewController: UIViewController {
    
    let itemModel = ItemModel()
    
    var level = 1
    
    var editingMode: EditingMode = .none
    
    var itemsToGroup = [Item]()
    
    var itemToMove: Item?
    
    // Delegates called by the HeaderView
    var touchedAwayFromTextFieldDelegate: TouchedAwayFromTextFieldDelegate?
    var dismissKeyboardFromMainViewControllerDelegate: DismissKeyboardFromMainViewControllerDelegate?
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        
        switch editingMode {
            
        case .none :

            toggleEditingMode(for: .sorting)
            
        case .grouping :
            
            if itemsToGroup.count > 0 {
                groupItems()
            } else {
                toggleEditingMode(for: .none)
            }
            
        case .adding :
            
            dismissKeyboardFromMainViewControllerDelegate?.dismissKeyboardFromMainViewController()
            toggleEditingMode(for: .none)
            
        default:

            toggleEditingMode(for: .none)
            
        }
        
    }
    
    func toggleEditingMode(for selectedEditingMode: EditingMode) {
        
//        print("Selected Editing Mode: \(selectedEditingMode)")
//        print("Current Editing Mode: \(editingMode)")
        
        switch selectedEditingMode {
            
        case .adding :
            
            if editingMode == .grouping {
                itemsToGroup = []
                tableView.reloadData()
            }
            
            editButton.title = "Cancel"
            tableView.setEditing(false, animated: true)
            
        case .sorting :
            
            editButton.title = "Done"
            
            // Have to set the mode here so the table reloads successfully for editing
            editingMode = selectedEditingMode
            tableView.setEditing(true, animated: true)
            
        case .grouping :
            
            editButton.title = (itemsToGroup.count > 0) ? "Group" : "Done"
            
        case .none, .moving, .specifics :
            
            if editingMode == .grouping {
                itemsToGroup = []
                tableView.reloadData()
            }
            editButton.title = "Sort"
            tableView.setEditing(false, animated: true)
            
        }
        
        editingMode = selectedEditingMode
        
//        print("New Editing Mode: \(editingMode)\n")
        
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chosen VC and TableView set, with the 'title' being set in the Storyboard
        self.itemModel.setViewDisplayed(tableView: tableView, selectedCategory: self.title!, level: level)
        
        // Header
        tableView.register(UINib(nibName: Keywords.shared.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Keywords.shared.headerIdentifier)
        
        // Cell
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        resetEditingMode()
        toggleEditingMode(for: .none)
        
        itemModel.reloadItems()
        
        tableView.reloadData()
        
    }
    
    @objc func longPressGestureSelector(gestureRecognizer: UILongPressGestureRecognizer) {
        if editingMode == .none {
            if gestureRecognizer.state == .began {
                performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
            }
        }
    }
    
    func deleteRow(inTable tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        if itemModel.numberOfSubItems(forParentID: Int(itemModel.items[indexPath.row].id), andParentName: itemModel.items[indexPath.row].name!) > 0 {
            
            let alert = UIAlertController(title: "Are you sure?", message: "You have SubItems in this Item", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                
                DataModel.shared.deleteSpecificItem(forItem: self.itemModel.items[indexPath.row])
                
                self.itemModel.reloadItems()
                
                tableView.deleteRows(at: [indexPath], with: .left)
                
                HapticsModel.shared.hapticExecuted(as: .success)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            DataModel.shared.deleteSpecificItem(forItem: itemModel.items[indexPath.row])
            
            itemModel.reloadItems()
            
            tableView.deleteRows(at: [indexPath], with: .left)
            
            HapticsModel.shared.hapticExecuted(as: .success)
            
        }
        
    }
    
    func groupItems() {
        
        let groupAlert = UIAlertController(title: "Group?", message: "Enter a new Group Name for the selected items", preferredStyle: .alert)

        groupAlert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "New Group Name"
        })

        let newGroupNameTextField = groupAlert.textFields![0] as UITextField

        let groupItems = UIAlertAction(title: "Group Items", style: .destructive, handler: { (action) in

            var newGroupName = newGroupNameTextField.text!

            let currentCategory = self.itemModel.selectedCategory
            let currentLevel = self.itemModel.level
            let currentParentID = self.itemModel.selectedParentID
            let currentParentName = self.itemModel.selectedParentName
            
            let currentLevelItems = DataModel.shared.loadSpecificItems(forCategory: currentCategory.rawValue, forLevel: currentLevel, forParentID: currentParentID, andParentName: currentParentName, ascending: true)
            
            for currentItem in currentLevelItems {
                
                if self.itemsToGroup.contains(currentItem) {
                    continue
                } else if currentItem.name == newGroupNameTextField.text {
                    newGroupName = "\(self.itemsToGroup[0].name!)"
                    
                    
                    
                    // In the meantime, this alert will signify that the name was a duplicate, and the new name set was one that was the first one in the group.
                    // Need to check for duplicates and ask for a different name.
                    
                    
                    let alert = UIAlertController(title: "Duplicate Name", message: "Since the name was a duplicate, the group was named \"\(self.itemsToGroup[0].name!)\".", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    
                    
                }
            }

            if newGroupName == "" {
                newGroupName = self.itemsToGroup[0].name!
            }
            
            DataModel.shared.group(items: self.itemsToGroup, intoNewItemName: newGroupName, forCategory: currentCategory, atLevel: currentLevel, withNewItemParentID: currentParentID, andNewItemParentName: currentParentName)
            
            self.itemModel.reloadItems()
            
            self.toggleEditingMode(for: .none)
            
            self.tableView.reloadData()
            
        })

        let addMoreItemsToGroup = UIAlertAction(title: "Add More Items", style: .default, handler: nil)
        let cancelGroupingItems = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in
            
            self.toggleEditingMode(for: .none)
            
        })

        groupAlert.addAction(groupItems)
        groupAlert.addAction(addMoreItemsToGroup)
        groupAlert.addAction(cancelGroupingItems)

        self.present(groupAlert, animated: true, completion: nil)
        
    }
    
}



extension CategoryAndItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModel.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Keywords.shared.headerIdentifier) as! HeaderView
        
        // itemModel-specific delegates
        headerView.isValidNameDelegate = itemModel
        headerView.addNewItemDelegate = itemModel
        headerView.reloadTableListDelegate = itemModel
        
        // General invalid name alert, which should probably be in the 'itemModel'
        headerView.presentInvalidNameAlertDelegate = self
        
        // Header-specific delegates
        headerView.textFieldIsActiveDelegate = self
        headerView.textFieldIsSubmittedDelegate = self
        headerView.setEditingModeForDismissingKeyboardDelegate = self
        
        // CategoryAndItemVC-specific delegates
        self.touchedAwayFromTextFieldDelegate = headerView
        self.dismissKeyboardFromMainViewControllerDelegate = headerView
        
        headerView.selectedParentID = itemModel.selectedParentID
        
        return headerView
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        let item = itemModel.items[indexPath.row]
        
        if editingMode == .grouping {
            
            if item.done {
                cell.checkboxImageView.image = Keywords.shared.blueCheck
            } else {
                cell.checkboxImageView.image = Keywords.shared.blueEmptyCheckbox
            }
            
            if itemsToGroup.contains(item) {
                cell.backgroundColor = Keywords.shared.lightBlueBackground
            } else {
                cell.backgroundColor = UIColor.white
            }
            
        } else {
            
            if item.done {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
        }
        
//        cell.nameLabel?.text = "\(item.parentID). \(item.name!)"
        
        cell.nameLabel?.text = "\(item.name!)"
        
        let numOfSubItems = itemModel.numberOfSubItems(forParentID: Int(item.id), andParentName: item.name!)
        let numOfSubItemsDone = itemModel.numberOfItemsDone(forParentID: Int(item.id), andParentName: item.name!)
        
        if numOfSubItems > 0 {
            
            cell.numberLabel.text = "\(numOfSubItemsDone)/\(numOfSubItems)"
            cell.numberLabelWidth.constant = 60
            
        } else {
            
            cell.numberLabel.text = ""
            cell.numberLabelWidth.constant = 0
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return UITableViewCell.EditingStyle.none
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    // Edit Actions For Row
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if editingMode == .none {
            
            let id = Int(self.itemModel.items[indexPath.row].id)
            let name = self.itemModel.items[indexPath.row].name!
            let category = self.itemModel.items[indexPath.row].category!
            let level = Int(self.itemModel.items[indexPath.row].level)
            let parentID = Int(self.itemModel.items[indexPath.row].parentID)
            let parentName = self.itemModel.items[indexPath.row].parentName!
            let numberOfSubitems = self.itemModel.numberOfSubItems(forParentID: id, andParentName: name)
            
            
            
            // *** DELETE
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
                
                self.deleteRow(inTable: tableView, atIndexPath: indexPath)
                
            }
            
            
            
            // *** MORE
            
            let more = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
                
                self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
                
                
                // Edit Name
                let editName = UIAlertAction(title: "Edit Name", style: .default, handler: { (action) in
                    
                    self.editingMode = .specifics
                    
                    self.performSegue(withIdentifier: self.itemModel.editSegue, sender: self)
                    
                })
                
                
                // Move
                let move = UIAlertAction(title: "Move", style: .default, handler: { (action) in
                    
                    self.editingMode = .moving
                    
                    self.itemToMove = self.itemModel.items[indexPath.row]
                    
                    self.performSegue(withIdentifier: self.itemModel.moveSegue, sender: self)
                    
                })
                
                
                // Group
                let group = UIAlertAction(title: "Group", style: .default, handler: { (action) in
                    
                    self.toggleEditingMode(for: .grouping)
                    
                    self.editButton.title = (self.itemsToGroup.count == 0) ? "Done" : "Group"
                    
                    self.tableView.reloadData()
                    
                })
                
                
                // Uncheck All
                let uncheckAll = UIAlertAction(title: "Uncheck All", style: .default, handler: { (action) in
                    
                    DataModel.shared.toggleDoneForAllItems(doneStatus: false, forCategory: category, forLevel: level, forParentID: parentID, andParentName: parentName)
                    
                    self.itemModel.reloadItems()
                    tableView.reloadData()
                    
                })
                
                
                // Delete SubItems
                let deleteSubItems = UIAlertAction(title: "Delete SubItems", style: .destructive, handler: { (action) in
                    
                    let alert = DataModel.shared.deleteSubItems(forItem: self.itemModel.items[indexPath.row], inTable: self.tableView)
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
                
                // Cancel
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                
                // Alert compilation
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                
                alert.addAction(editName)
                alert.addAction(move)
                alert.addAction(group)
                alert.addAction(uncheckAll)
                
                if numberOfSubitems > 0 {
                    alert.addAction(deleteSubItems)
                }
                
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
            }
            
            return [delete, more]
            
        } else {
            
            return []
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        
        if editingMode == .adding {
            touchedAwayFromTextFieldDelegate?.touchedAwayFromTextField()
        }
        
        self.itemModel.selectedItem = itemModel.items[indexPath.row]
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = itemModel.items[indexPath.row]
        
        if editingMode == .grouping {
            
            if itemsToGroup.contains(item) {
                for i in 0..<itemsToGroup.count {
                    if itemsToGroup[i] == item {
                        itemsToGroup.remove(at: i)
                        break
                    }
                }
            } else {
                itemsToGroup.append(item)
            }
            
            toggleEditingMode(for: .grouping)
            
        } else {
            
            let numOfSubItems = itemModel.numberOfSubItems(forParentID: Int(item.id), andParentName: item.name!)
            
            // If there are no subitems for the item clicked, then toggle the "Done" status of the item.
            if numOfSubItems == 0 {
                
                DataModel.shared.updateItem(forProperty: .done, forItem: item, parentID: Int(item.parentID), parentName: item.parentName!, name: nil)
                
                itemModel.reloadItems()
                
            // Otherwise, go to the subitems
            } else {
                
                performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return editingMode == .sorting
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemMoving = itemModel.items[sourceIndexPath.row]
        
        itemModel.items.remove(at: sourceIndexPath.row)
        
        itemModel.items.insert(itemMoving, at: destinationIndexPath.row)

        DataModel.shared.updateIDs(forItems: itemModel.items)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
//    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, success) in
//
//            print("Closeted")
//
//        }
//
////        deleteAction.image = UIImage(named: "tick")
////        deleteAction.backgroundColor = UIColor.purple
//
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//
//    }
    
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let modifyAction = UIContextualAction(style: .destructive, title: "Update") { (action, view, success) in
//            print("Updated")
//        }
//
////        modifyAction.image = UIImage(named: "hammer")
//        modifyAction.backgroundColor = UIColor.blue
//
//        return UISwipeActionsConfiguration(actions: [modifyAction])
//
//    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let item = self.itemModel.selectedItem else { return print("There was no item selected.") }
        
        if editingMode == .none {
            
            let destinationVC = segue.destination as! CategoryAndItemViewController
            
            destinationVC.navigationItem.title = "\(item.name!)"
            
            destinationVC.itemModel.selectedParentID = Int(item.id)
            
            destinationVC.itemModel.selectedParentName = item.name!
            
            destinationVC.itemModel.selectedCategory = self.itemModel.selectedCategory
            
            destinationVC.level = level + 1
            
        } else if editingMode == .specifics {

//            editingMode = .none
            
            let destinationVC = segue.destination as! EditViewController
            
            destinationVC.editingCompleteDelegate = self
            
            destinationVC.selectedCategory = itemModel.selectedCategory
            
            if let item = self.itemModel.selectedItem {
                
                destinationVC.item = item
                
                destinationVC.nameToEdit = item.name!
                
                destinationVC.level = level
                
            }
            
        } else if editingMode == .moving {
            
            let navVC = segue.destination as! UINavigationController
            
            let destinationVC = navVC.topViewController as! MoveItemViewController
            
            destinationVC.itemBeingMoved = itemToMove
            
        }
        
    }
    
}



extension CategoryAndItemViewController: PresentInvalidNameAlertDelegate, EditingCompleteDelegate, TextFieldIsActiveDelegate, TextFieldIsSubmittedDelegate, SetEditingModeForDismissingKeyboardDelegate {
    
    func presentInvalidNameAlert(withErrorMessage errorMessage: ItemNameCheck) {
        
        let alert = UIAlertController(title: "Invalid Entry", message: errorMessage.rawValue, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
    
    // Editing delegate
    func editingComplete() {
        self.itemModel.setViewDisplayed(tableView: tableView, selectedCategory: self.title!, level: level)
        tableView.reloadData()
    }
    
    
    
    // Header-specific delegate methods declared
    func textFieldIsActive() {
        toggleEditingMode(for: .adding)
    }
    
    func textFieldIsSubmitted() {
        toggleEditingMode(for: .none)
    }
    
    func setEditingModeForDismissingKeyboard() {
        toggleEditingMode(for: .none)
    }
    
}








