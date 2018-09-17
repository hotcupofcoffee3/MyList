//
//  CategoryAndItemViewController.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//



// TODO:

// Add function to sort by ID
// Add function to UpdateIDs based on newly moved item in the array or deleted item.
// Set up the 'editing' style and animation for the tableview.
// Set up 'moveAt' for the items in the table.



// LATER:

// Set up date.
// Add Edit VC.



import UIKit



class CategoryAndItemViewController: UIViewController {
    
    let categoryOrItem = CategoryAndItemModel()
    
    var selectedCategory = "Category And Item VC selectedCategory: Type view, no Category Selected."
    
    var isCurrentlyEditing = false
    
    func toggleEditing() {
        isCurrentlyEditing = !isCurrentlyEditing
        editButton.title = isCurrentlyEditing ? "Done" : "Edit"
        tableView.setEditing(isCurrentlyEditing, animated: isCurrentlyEditing)
    }
    
    @IBAction func edit(_ sender: UIBarButtonItem) {
        toggleEditing()
    }
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Chosen VC and TableView set, with the 'title' being set in the Storyboard
        self.categoryOrItem.setViewDisplayed(tableView: tableView, viewTitle: self.title!)
        
        // Header
        tableView.register(UINib(nibName: Keywords.shared.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Keywords.shared.headerIdentifier)
        
        // Cell
        tableView.register(UINib(nibName: Keywords.shared.cellNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if categoryOrItem.viewDisplayed == .items {
            isCurrentlyEditing = false
        }
        tableView.reloadData()
    }
    
    @objc func y(gestureRecognizer: UILongPressGestureRecognizer){
        if gestureRecognizer.state == .began {
            print("Penis")
        }
    }
    
}



extension CategoryAndItemViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (categoryOrItem.viewDisplayed == .items) ? categoryOrItem.items.count : categoryOrItem.categories.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Keywords.shared.headerIdentifier) as! HeaderView
        
        headerView.addCategoryOrItemDelegate = categoryOrItem
        
        headerView.reloadTableListDelegate = categoryOrItem
        
        headerView.checkForNameDuplicateDelegate = self
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        let x = UILongPressGestureRecognizer(target: self, action: #selector(y(gestureRecognizer:)))
        x.minimumPressDuration = 0.5
        cell.addGestureRecognizer(x)
        
//        cell.nameLabelHeight.constant = cell.nameLabel.frame.height
        
        if categoryOrItem.viewDisplayed == .items {
            
            if categoryOrItem.items[indexPath.row].done {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.nameLabel?.text = categoryOrItem.items[indexPath.row].name!
            cell.numberLabel.text = ""
            cell.numberLabelWidth.constant = 0
           
        } else {
            
            if DataModel.shared.updateAllItemsAreDone(forCategory: categoryOrItem.categories[indexPath.row].name!) {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.nameLabel?.text = categoryOrItem.categories[indexPath.row].name!
            
            let categoryName = categoryOrItem.categories[indexPath.row].name!
            let totalAmount = categoryOrItem.numberOfItems(forCategory: categoryName)
            let amountDone = categoryOrItem.numberOfItemsDone(forCategory: categoryName)
            if totalAmount > 0 {
                cell.numberLabel.text = "\(amountDone)/\(totalAmount)"
            } else {
                cell.numberLabel.text = "0"
            }
            
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if categoryOrItem.viewDisplayed != .items {
            
            selectedCategory = categoryOrItem.categories[indexPath.row].name!
            performSegue(withIdentifier: categoryOrItem.typeOfSegue, sender: self)
            
        } else {
            
            DataModel.shared.updateItem(forProperty: .done, forItem: categoryOrItem.items[indexPath.row], category: nil, name: nil)
            categoryOrItem.reloadCategoriesOrItems()
            tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            if categoryOrItem.viewDisplayed != .items {
                
                if categoryOrItem.numberOfItems(forCategory: categoryOrItem.categories[indexPath.row].name!) > 0 {
                    
                    let alert = UIAlertController(title: "Are you sure?", message: "You have Items in this Category", preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in
                        
                        DataModel.shared.deleteSpecificCategory(forCategory: self.categoryOrItem.categories[indexPath.row])
                        
                        self.categoryOrItem.reloadCategoriesOrItems()
                        self.tableView.deleteRows(at: [indexPath], with: .left)
                        self.hapticExecuted(as: .success)
                        
                    }))
                    
                    alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                    
                } else {
                    
                    DataModel.shared.deleteSpecificCategory(forCategory: categoryOrItem.categories[indexPath.row])
                    
                    categoryOrItem.reloadCategoriesOrItems()
                    tableView.deleteRows(at: [indexPath], with: .left)
                    hapticExecuted(as: .success)
                    
                }
                
            } else {
                
                DataModel.shared.deleteSpecificItem(forItem: categoryOrItem.items[indexPath.row])
                
                categoryOrItem.reloadCategoriesOrItems()
                tableView.deleteRows(at: [indexPath], with: .left)
                hapticExecuted(as: .success)
                
            }
            
        }
        
        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return isCurrentlyEditing
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
//        let selectedExercise = workout.exerciseArray[sourceIndexPath.row]
//
//        workout.exerciseArray.remove(at: sourceIndexPath.row)
//
//        workout.exerciseArray.insert(selectedExercise, at: destinationIndexPath.row)
//
//        workout.updateOrderNumbers()
//
//        tableView.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryAndItemViewController
        
        destinationVC.navigationItem.title = "\(selectedCategory)"
        
        destinationVC.categoryOrItem.selectedCategory = selectedCategory
    }
    
}



extension CategoryAndItemViewController: CheckForNameDuplicationDelegate, HapticDelegate {
    
    func presentDuplicateNameAlert() {
        
        let alert = UIAlertController(title: "Invalid Entry", message: "You have to enter a unique name or title.", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func hapticExecuted(as hapticType: UINotificationFeedbackType) {
        
        // Success notification haptic
        let successHaptic = UINotificationFeedbackGenerator()
        successHaptic.notificationOccurred(hapticType)
        
    }
    
}








