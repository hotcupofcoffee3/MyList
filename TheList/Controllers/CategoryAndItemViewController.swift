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
    
    var viewType: ChosenVC?
    
    var selectedParentID = Int()
   
    var selectedItem: Item?
    
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
        self.itemModel.setViewDisplayed(tableView: tableView, viewTitle: self.title!)
        
        // Header
        tableView.register(UINib(nibName: Keywords.shared.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Keywords.shared.headerIdentifier)
        
        // Cell
        tableView.register(UINib(nibName: Keywords.shared.cellNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if itemModel.viewDisplayed == .subItems {
            isCurrentlyEditing = false
            selectedParentID = itemModel.selectedParentID
        }
        
        tableView.reloadData()
        
    }
    
    @objc func longPressGestureSelector(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            if itemModel.viewDisplayed != .subItems {
                performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
            }
        }
    }
    
    func deleteRow(inTable tableView: UITableView, atIndexPath indexPath: IndexPath) {
        
        if itemModel.viewDisplayed != .subItems {
            
            if itemModel.numberOfItems(forCategory: itemModel.categories[indexPath.row].name!) > 0 {
                
                let alert = UIAlertController(title: "Are you sure?", message: "You have Items in this Category", preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                    
                    DataModel.shared.deleteSpecificCategory(forCategory: self.itemModel.categories[indexPath.row])
                    
                    self.itemModel.reloadCategoriesOrItems()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    self.hapticExecuted(as: .success)
                    
                }))
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                
                present(alert, animated: true, completion: nil)
                
            } else {
                
                DataModel.shared.deleteSpecificCategory(forCategory: itemModel.categories[indexPath.row])
                
                itemModel.reloadCategoriesOrItems()
                tableView.deleteRows(at: [indexPath], with: .left)
                hapticExecuted(as: .success)
                
            }
            
        } else {
            
            DataModel.shared.deleteSpecificItem(forItem: itemModel.item[indexPath.row])
            
            itemModel.reloadCategoriesOrItems()
            tableView.deleteRows(at: [indexPath], with: .left)
            hapticExecuted(as: .success)
            
        }
        
    }
    
}



extension CategoryAndItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (itemModel.viewDisplayed == .item) ? itemModel.item.count : itemModel.categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Keywords.shared.headerIdentifier) as! HeaderView
        
        headerView.addCategoryOrItemDelegate = itemModel
        
        headerView.reloadTableListDelegate = itemModel
        
        headerView.checkForNameDuplicateDelegate = self
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { (action, indexPath) in
            self.deleteRow(inTable: tableView, atIndexPath: indexPath)
        }
        
        let edit = UITableViewRowAction(style: .normal, title: "More") { (action, indexPath) in
            self.isEditingSpecifics = true
            
            if self.itemModel.viewDisplayed != .item {
                self.selectedCategory = self.itemModel.categories[indexPath.row].name!
            } else {
                self.selectedItem = self.itemModel.item[indexPath.row]
            }
            
            self.performSegue(withIdentifier: self.itemModel.editSegue, sender: self)
        }
        
        return [delete, edit]
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureSelector(gestureRecognizer:)))
        
        longPress.minimumPressDuration = 0.5
        cell.addGestureRecognizer(longPress)
        
        if itemModel.viewDisplayed == .item {
            
            if itemModel.item[indexPath.row].done {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.nameLabel?.text = itemModel.item[indexPath.row].name!
            cell.numberLabel.text = ""
            cell.numberLabelWidth.constant = 0
           
        } else {
            
            if itemModel.categories[indexPath.row].done {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.nameLabel?.text = itemModel.categories[indexPath.row].name!
            
            let categoryName = itemModel.categories[indexPath.row].name!
            let totalAmount = itemModel.numberOfItems(forCategory: categoryName)
            let amountDone = itemModel.numberOfItemsDone(forCategory: categoryName)
            if totalAmount > 0 {
                cell.numberLabel.text = "\(amountDone)/\(totalAmount)"
            } else {
                cell.numberLabel.text = ""
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if itemModel.viewDisplayed != .item {
            selectedCategory = itemModel.categories[indexPath.row].name!
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if itemModel.viewDisplayed != .item {
            
            let categoryName = itemModel.categories[indexPath.row].name!
            let numberOfItemsInCategory = itemModel.numberOfItems(forCategory: categoryName)
            
            if numberOfItemsInCategory > 0 {
                selectedCategory = categoryName
                performSegue(withIdentifier: itemModel.typeOfSegue, sender: self)
            } else {
                DataModel.shared.toggleDone(forCategory: categoryName)
            }
            
        } else {

            DataModel.shared.updateItem(forProperty: .done, forItem: itemModel.item[indexPath.row], category: nil, name: nil)
            itemModel.reloadCategoriesOrItems()
            
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isCurrentlyEditing
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if itemModel.viewDisplayed != .item {
            
            let categoryMoving = itemModel.categories[sourceIndexPath.row]
            
            itemModel.categories.remove(at: sourceIndexPath.row)
            
            itemModel.categories.insert(categoryMoving, at: destinationIndexPath.row)
            
            DataModel.shared.updateIDs(forViewDisplayed: itemModel.viewDisplayed, forCategories: itemModel.categories, orForItems: nil, forSelectedCategory: nil)
            
            tableView.reloadData()
            
        } else {
            
            let itemMoving = itemModel.item[sourceIndexPath.row]
            
            itemModel.item.remove(at: sourceIndexPath.row)
            
            itemModel.item.insert(itemMoving, at: destinationIndexPath.row)
            
            DataModel.shared.updateIDs(forViewDisplayed: itemModel.viewDisplayed, forCategories: nil, orForItems: itemModel.item, forSelectedCategory: DataModel.shared.loadSpecificCategory(named: selectedCategory))
            
            tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if !isEditingSpecifics {
            
            let destinationVC = segue.destination as! CategoryAndItemViewController
            
            destinationVC.navigationItem.title = "\(selectedCategory)"
            
            destinationVC.itemModel.selectedCategory = selectedCategory
            
            destinationVC.categoryType = itemModel.viewDisplayed
            
        } else {
            
            isEditingSpecifics = false
            
            let destinationVC = segue.destination as! EditViewController
            
            destinationVC.editingCompleteDelegate = self
            
            destinationVC.typeBeingEdited = itemModel.viewDisplayed
            
            if itemModel.viewDisplayed != .item {
                
                destinationVC.nameToEdit = selectedCategory
                
            } else {
                
                if let item = selectedItem {
                    
                    destinationVC.item = item
                    
                    destinationVC.nameToEdit = item.name!
                    
                    destinationVC.categoryToEdit = item.category!
                    
                    if let type = categoryType {
                        destinationVC.categoryType = type
                    } else {
                        print("Something went wrong with setting the Category Type for the edit screen from the Items VC.")
                    }
                    
                }
                
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
        self.itemModel.setViewDisplayed(tableView: tableView, viewTitle: self.title!)
        tableView.reloadData()
    }
    
}








