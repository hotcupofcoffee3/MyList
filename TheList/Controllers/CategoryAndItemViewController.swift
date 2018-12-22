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
    
    var editingMode: EditingMode = .none
    
    var selectedItems = [Item]()
    
    var itemToMove: Item?
    
    // Delegates called by the HeaderView
    var touchedAwayFromTextFieldDelegate: TouchedAwayFromTextFieldDelegate?
    var dismissKeyboardFromMainViewControllerDelegate: DismissKeyboardFromMainViewControllerDelegate?
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        
        switch editingMode {
            
        case .none :
            
            toggleEditingMode(for: .selecting)
            
        case .selecting :

            if selectedItems.count > 0 {
                
                
                
                let alert = UIAlertController(title: "\(selectedItems.count) items selected", message: nil, preferredStyle: .actionSheet)
                
                // Delete Items
                let delete = UIAlertAction(title: "Delete Items", style: .destructive, handler: { (action) in
                    
                    
                    
                    // *** Have to add ordered indices for the items that'll be deleted, as we need to delete the rows from the tableView, and have to add them into an array that deletes them after the itemModel and DataModel have been deleted from and updated.
                    
                    // Sort the items by orderNumber into a new itemArray.
                    // Pass the new array into the 'deleteItems()' functions from the DataModel below.
                    // Delete the rows from the table by iterating through the new array and adding each indexPath to an array that can be submitted through the 'tableView.deleteRows()' function, using (array.count - orderNumber), which will give the indexPath.row.
                    // *** May need to add a new function that does this so that the indexPath is submitted instead of simply the indexPath.row, which may not give enough information.
                    
                    
                    
                    
//                    let deleteAlert = DataModel.shared.deleteItems(itemsToDelete: self.selectedItems, inTable: self.tableView)
//                    self.present(deleteAlert, animated: true, completion: nil)
                })
                
                // Group
                let group = UIAlertAction(title: "Group Items", style: .default, handler: { (action) in
                    self.groupItems()
                })
                
                // Move
                let move = UIAlertAction(title: "Move Items", style: .default, handler: { (action) in
                    
                    
                    
                    // *** Move Items
                    
                    
                    
                })
                
                // Add More Items
                let addMoreItems = UIAlertAction(title: "Add More Items", style: .default, handler: nil)
                
                // Cancel
                let cancel = UIAlertAction(title: "Cancel Editing", style: .cancel, handler: { (action) in
                    self.toggleEditingMode(for: .none)
                })
                
                alert.addAction(delete)
                alert.addAction(group)
                alert.addAction(move)
                alert.addAction(addMoreItems)
                alert.addAction(cancel)
                
                self.present(alert, animated: true, completion: nil)
                
                // ******
                // *** Set up Action Sheet for Grouping, Deleting, and Moving here.
                // ******
                
                // - Update functions in this VC and in DataModel to have parameters to take in an array of Items and checks them, returning an alert if something fails.
                
                // - Restructure local functions to be an extension of this VC, so it is more organized. I was going to move them to the itemModel, but it may only help out a tiny bit, but a lot of reorganizing the code just for a few lines, so fuck it.
                
                // - Have "More" only show up if the Item has subItems. Otherwise, just pop up swipe alert for "Delete" to confirm is there are subItems.
                
                    // --- As such, "More" ActionSheet will contain "Delete SubItems", "Rename", and "Move", just in case.
                    // --- Leave the options still swipeable for "Rename" and "Move" because of their convenience.
                
                
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
        
        switch selectedEditingMode {
            
        case .adding :
            
            if editingMode == .selecting {
                selectedItems = []
                tableView.reloadData()
            }
            
            editButton.title = "Cancel"
            tableView.setEditing(false, animated: true)
            
        case .selecting :
            
            editButton.title = (selectedItems.count > 0) ? "Actions" : "Done"
            
            if selectedItems.count == 0 && editingMode != .none {
                tableView.reloadData()
            }
            
            // Have to set the mode here so the table reloads successfully for editing
            editingMode = selectedEditingMode
            tableView.setEditing(true, animated: true)
            
        case .none, .moving, .specifics :
            
            if editingMode == .selecting {
                selectedItems = []
//                tableView.reloadData()
            }
            editButton.title = "Edit"
            tableView.setEditing(false, animated: true)
            
        }
        
        editingMode = selectedEditingMode
        
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chosen VC and TableView set, with the 'title' being set in the Storyboard
        self.itemModel.setViewDisplayed(tableView: tableView, selectedView: self.title!)
        
        // Header
        tableView.register(UINib(nibName: Keywords.shared.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Keywords.shared.headerIdentifier)
        
        // Cell
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
        tableView.separatorStyle = .none
        
        tableView.allowsSelectionDuringEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

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
        
        if itemModel.numberOfSubItems(forParentID: Int(itemModel.items[indexPath.row].id)) > 0 {
            
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

            // *** Loading a default placeholder cell breaks here because it tries to reload the table with one less cell than was there before, but if the default is placed in place of the cells, and there is only one cell left in 'items', then it assumes that the number of new cells showing is 0, but the placeholder cell requires 1 to be left, so it crashes.
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

            let newGroupName = newGroupNameTextField.text!
           
            let currentParentID = self.itemModel.selectedParentID
            
            if ValidationModel.shared.isValid(itemName: newGroupName) != .success {
                
                self.present(ValidationModel.shared.alertForInvalidItem(doSomethingElse: {
                    
                    self.groupItems()
                    
                }), animated: true, completion: nil)
                
            } else {
                
                DataModel.shared.group(items: self.selectedItems, intoNewItemName: newGroupName, withNewItemParentID: currentParentID)
                
                self.itemModel.reloadItems()
                
                self.toggleEditingMode(for: .none)
                
                self.tableView.reloadData()
                
            }

        })

        let addMoreItemsToGroup = UIAlertAction(title: "Add More Items", style: .default, handler: nil)
        let cancelGroupingItems = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) in

            self.selectedItems = []
            self.toggleEditingMode(for: .selecting)

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
        
        // Header-specific delegate
        headerView.setEditingModeFromHeaderDelegate = self
        
        // CategoryAndItemVC-specific delegates
        self.touchedAwayFromTextFieldDelegate = headerView
        self.dismissKeyboardFromMainViewControllerDelegate = headerView
        
        headerView.selectedParentID = itemModel.selectedParentID
        
        return headerView
        
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        cell.selectionStyle = .none
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        let item = itemModel.items[indexPath.row]
        
        if editingMode == .selecting && selectedItems.count > 0 {
            
            if selectedItems.contains(item) {
                cell.setCellColorAndImageDisplay(colorSelector: .groupingSelected, doneStatus: item.done)
            } else {
                cell.setCellColorAndImageDisplay(colorSelector: .groupingUnselected, doneStatus: item.done)
            }
            
        } else {
            
            cell.setCellColorAndImageDisplay(colorSelector: .regular, doneStatus: item.done)
            
        }
        
        cell.nameLabel?.text = "\(item.name!)"
        
        let numOfSubItems = itemModel.numberOfSubItems(forParentID: Int(item.id))
        let numOfSubItemsDone = itemModel.numberOfItemsDone(forParentID: Int(item.id))
        
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
            
            self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
            
            let numberOfSubitems = self.itemModel.numberOfSubItems(forParentID: id)
            
            
            // *** DELETE
            
            let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
                
                if numberOfSubitems == 0 {
                    
                    self.deleteRow(inTable: tableView, atIndexPath: indexPath)
                    
                } else {
                    
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
                    
                    // Delete Item
                    let deleteItem = UIAlertAction(title: "Delete Item", style: .destructive, handler: { (action) in
                        
                        self.deleteRow(inTable: tableView, atIndexPath: indexPath)
                        
                    })
                    
                    // Delete SubItems
                    let deleteSubItems = UIAlertAction(title: "Delete SubItems", style: .destructive, handler: { (action) in
                        
                        // Alert confirming deletion of subItems
                        let alert = DataModel.shared.deleteSubItems(forItem: self.itemModel.items[indexPath.row], inTable: self.tableView)
                        self.present(alert, animated: true, completion: nil)
                        
                    })
                    
                    // Cancel
                    let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    
                    alert.addAction(deleteItem)
                    alert.addAction(deleteSubItems)
                    alert.addAction(cancel)
                    
                    self.present(alert, animated: true, completion: nil)
                    
                }
                
            }
            
            
            
            // *** MORE
            
            let more = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
                
                guard let selectedItem = self.itemModel.selectedItem else { return print("No item was selected in 'More'.") }
                
                let alert = UIAlertController(title: "Selected Item:", message: selectedItem.name!, preferredStyle: .actionSheet)
                
                // Delete SubItems
                let deleteSubItems = UIAlertAction(title: "Delete SubItems", style: .destructive, handler: { (action) in
                    
                    // Alert confirming deletion of subItems
                    let alert = DataModel.shared.deleteSubItems(forItem: self.itemModel.items[indexPath.row], inTable: self.tableView)
                    self.present(alert, animated: true, completion: nil)
                    
                })
                
//                // Group
//                let group = UIAlertAction(title: "Group Items", style: .default, handler: { (action) in
//
//                    self.toggleEditingMode(for: .grouping)
//
//                })
                
                // Cancel
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
//                alert.addAction(group)
                
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
        
        if editingMode == .selecting {
            
            if selectedItems.contains(item) {
                for i in 0..<selectedItems.count {
                    if selectedItems[i] == item {
                        selectedItems.remove(at: i)
                        break
                    }
                }
            } else {
                selectedItems.append(item)
            }
            
            toggleEditingMode(for: .selecting)
            
        } else {
            
            let numOfSubItems = itemModel.numberOfSubItems(forParentID: Int(item.id))
            
            // If there are no subitems for the item clicked, then toggle the "Done" status of the item.
            if numOfSubItems == 0 {
                
                DataModel.shared.updateDone(forItem: item)
                
                itemModel.reloadItems()
                
                // Otherwise, go to the subitems
            } else {
                
                performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return editingMode == .selecting
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemMoving = itemModel.items[sourceIndexPath.row]
        
        itemModel.items.remove(at: sourceIndexPath.row)
        
        itemModel.items.insert(itemMoving, at: destinationIndexPath.row)

        DataModel.shared.updateOrderNumbers(forItems: itemModel.items, ascending: false)
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        
        // *** RENAME
        
        let rename = UIContextualAction(style: .destructive, title: "Rename") { (action, view, success) in

            self.editingMode = .specifics
            
            self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
            
            self.performSegue(withIdentifier: self.itemModel.editSegue, sender: self)

        }

        // *** MOVE
        
        let move = UIContextualAction(style: .destructive, title: "Move") { (action, view, success) in
            
            self.editingMode = .moving
            
            self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
            
            self.itemToMove = self.itemModel.items[indexPath.row]
            
            self.performSegue(withIdentifier: self.itemModel.moveSegue, sender: self)
            
        }
        
//        rename.image = UIImage(named: "tick")
//        move.image = UIImage(named: "tick")
        rename.backgroundColor = UIColor.darkGray
        move.backgroundColor = UIColor.orange

        return UISwipeActionsConfiguration(actions: [rename, move])

    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let item = self.itemModel.selectedItem else { return print("There was no item selected for the segue.") }
        
        if editingMode == .none {
            
            let destinationVC = segue.destination as! CategoryAndItemViewController
            
            destinationVC.navigationItem.title = "\(item.name!)"
            
            destinationVC.itemModel.selectedParentID = Int(item.id)
            
            destinationVC.itemModel.selectedView = self.itemModel.selectedView
            
        } else if editingMode == .specifics {

//            editingMode = .none
            
            let destinationVC = segue.destination as! EditViewController
            
            destinationVC.editingCompleteDelegate = self
            
            destinationVC.selectedView = itemModel.selectedView
            
            if let item = self.itemModel.selectedItem {
                
                destinationVC.item = item
                
                destinationVC.nameToEdit = item.name!
                
            }
            
        } else if editingMode == .moving {
            
            let navVC = segue.destination as! UINavigationController
            
            let destinationVC = navVC.topViewController as! MoveItemViewController
            
            destinationVC.itemBeingMoved = itemToMove
            
        }
        
    }
    
}



extension CategoryAndItemViewController: PresentInvalidNameAlertDelegate, EditingCompleteDelegate, SetEditingModeFromHeaderDelegate {
    
    func presentInvalidNameAlert() {
        present(ValidationModel.shared.alertForInvalidItem(doSomethingElse: nil), animated: true, completion: nil)
    }
    
    
    
    // Editing delegate
    func editingComplete() {
        self.itemModel.setViewDisplayed(tableView: tableView, selectedView: self.title!)
        tableView.reloadData()
    }
    
    
    
    // Header-specific delegate method declared
    
    func setEditingModeFromHeader(forEditingMode editingMode: EditingMode) {
        toggleEditingMode(for: editingMode)
    }
    
}








