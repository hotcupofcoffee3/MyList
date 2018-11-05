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
    
    var isCurrentlyEditing = false
    
    var isEditingSpecifics = false
    
    func toggleEditing() {
        isCurrentlyEditing = !isCurrentlyEditing
        editButton.title = isCurrentlyEditing ? "Done" : "Move"
        tableView.setEditing(isCurrentlyEditing, animated: true)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        toggleEditing()
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
        tableView.register(UINib(nibName: Keywords.shared.cellNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        itemModel.reloadItems()
        
        tableView.reloadData()
        
    }
    
    @objc func longPressGestureSelector(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
        }
    }
    
    func deleteRow(inTable tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        if itemModel.numberOfItems(forParentID: Int(itemModel.items[indexPath.row].parentID), andParentName: itemModel.items[indexPath.row].parentName!) > 0 {
            
            let alert = UIAlertController(title: "Are you sure?", message: "You have Items in this Category", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                
                DataModel.shared.deleteSpecificItem(forItem: self.itemModel.items[indexPath.row])
                
                self.itemModel.reloadItems()
                tableView.deleteRows(at: [indexPath], with: .left)
                self.hapticExecuted(as: .success)
                
            }))
            
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true, completion: nil)
            
        } else {
            
            DataModel.shared.deleteSpecificItem(forItem: itemModel.items[indexPath.row])
            
            itemModel.reloadItems()
            tableView.deleteRows(at: [indexPath], with: .left)
            hapticExecuted(as: .success)
            
        }
        
    }
    
}



extension CategoryAndItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemModel.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Keywords.shared.headerIdentifier) as! HeaderView
        
        headerView.addNewItemDelegate = itemModel
        
        headerView.reloadTableListDelegate = itemModel
        
        headerView.checkForNameDuplicateDelegate = self
        
        headerView.selectedParentID = itemModel.selectedParentID
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.deleteRow(inTable: tableView, atIndexPath: indexPath)
        
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
            
            self.itemModel.selectedItem = self.itemModel.items[indexPath.row]
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            
            let editNameAction = UIAlertAction(title: "Rename \"\(self.itemModel.items[indexPath.row].name!)\"", style: .default, handler: { (action) in
                
                self.isEditingSpecifics = true
                self.performSegue(withIdentifier: self.itemModel.editSegue, sender: self)
                
            })
            
            let editParentAction = UIAlertAction(title: "Change parent item", style: .default, handler: { (action) in
                print(self.itemModel.items[indexPath.row].parentName!)
            })
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(editNameAction)
            alert.addAction(editParentAction)
            alert.addAction(cancel)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        return [delete, edit]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        if itemModel.items[indexPath.row].done {
            cell.checkboxImageView.image = Keywords.shared.checkboxChecked
            cell.backgroundColor = Keywords.shared.lightGreenBackground12
        } else {
            cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
            cell.backgroundColor = UIColor.white
        }
        
        cell.nameLabel?.text = "\(Int(itemModel.items[indexPath.row].parentID))/\(Int(itemModel.items[indexPath.row].id)). \(itemModel.items[indexPath.row].name!)"
        
        let numOfSubItems = itemModel.numberOfItems(forParentID: Int(itemModel.items[indexPath.row].id), andParentName: itemModel.items[indexPath.row].name!)
        let numOfSubItemsDone = itemModel.numberOfItemsDone(forParentID: Int(itemModel.items[indexPath.row].id), andParentName: itemModel.items[indexPath.row].name!)
        
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
        self.itemModel.selectedItem = itemModel.items[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let numOfSubItems = itemModel.numberOfItems(forParentID: Int(itemModel.items[indexPath.row].id), andParentName: itemModel.items[indexPath.row].name!)
        
        if numOfSubItems == 0 {
            
            DataModel.shared.updateItem(forProperty: .done, forItem: itemModel.items[indexPath.row], parentID: Int(itemModel.items[indexPath.row].parentID), parentName: itemModel.items[indexPath.row].parentName!, name: nil)
            
            itemModel.reloadItems()
            
        } else {
            
            performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
            
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isCurrentlyEditing
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        let itemMoving = itemModel.items[sourceIndexPath.row]
        
        itemModel.items.remove(at: sourceIndexPath.row)
        
        itemModel.items.insert(itemMoving, at: destinationIndexPath.row)
        
        DataModel.shared.updateIDs(forItems: itemModel.items)
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let item = self.itemModel.selectedItem else { return print("There was no item selected.") }
        
        if !isEditingSpecifics {
            
            let destinationVC = segue.destination as! CategoryAndItemViewController
            
            destinationVC.navigationItem.title = "\(item.name!)"
            
            destinationVC.itemModel.selectedParentID = Int(item.id)
            
            destinationVC.itemModel.selectedParentName = item.name!
            
            destinationVC.itemModel.selectedCategory = self.itemModel.selectedCategory
            
            destinationVC.level = level + 1
            
        } else {
            
            isEditingSpecifics = false
            
            let destinationVC = segue.destination as! EditViewController
            
            destinationVC.editingCompleteDelegate = self
            
            destinationVC.selectedCategory = itemModel.selectedCategory
            
            if let item = self.itemModel.selectedItem {
                
                destinationVC.item = item
                
                destinationVC.nameToEdit = item.name!
                
                destinationVC.level = level
                
            }
            
        }
        
    }
    
}



extension CategoryAndItemViewController: CheckForNameDuplicationDelegate, HapticDelegate, EditingCompleteDelegate {
    
    func presentDuplicateNameAlert() {
        
        let alert = UIAlertController(title: "Invalid Entry", message: "You have to enter a unique name or title.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func hapticExecuted(as hapticType: UINotificationFeedbackGenerator.FeedbackType) {
        
        // Success notification haptic
        let successHaptic = UINotificationFeedbackGenerator()
        successHaptic.notificationOccurred(hapticType)
        
    }
    
    func editingComplete() {
        self.itemModel.setViewDisplayed(tableView: tableView, selectedCategory: self.title!, level: level)
        tableView.reloadData()
    }
    
}








