//
//  CategoryAndItemViewController.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit



class CategoryAndItemViewController: UIViewController {
    
    let categoryOrItem = CategoryAndItemModel()
    
    var selectedCategory = "Category And Item VC selectedCategory: Type view, no Category Selected."
    
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
        tableView.reloadData()
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
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        if categoryOrItem.viewDisplayed == .items {
            
            cell.nameLabel?.text = categoryOrItem.items[indexPath.row].name!
            
            if categoryOrItem.items[indexPath.row].done {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.accessoryType = .none
            
        } else {
            
            if categoryOrItem.allItemsAreDone(forCategory: categoryOrItem.categories[indexPath.row].name!) {
                cell.checkboxImageView.image = Keywords.shared.checkboxChecked
                cell.backgroundColor = Keywords.shared.lightGreenBackground12
            } else {
                cell.checkboxImageView.image = Keywords.shared.checkboxEmpty
                cell.backgroundColor = UIColor.white
            }
            
            cell.nameLabel?.text = categoryOrItem.categories[indexPath.row].name!
            cell.accessoryType = .disclosureIndicator
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if categoryOrItem.viewDisplayed != .items {
            
            selectedCategory = categoryOrItem.categories[indexPath.row].name!
            
            performSegue(withIdentifier: categoryOrItem.typeOfSegue, sender: self)
            
        } else {
            
            DataModel.shared.toggleDone(forItem: categoryOrItem.items[indexPath.row])
            categoryOrItem.reloadCategoriesOrItems()
            tableView.reloadData()
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
        
    }
    
}



// MARK: - Segue

extension CategoryAndItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! CategoryAndItemViewController
        
        destinationVC.navigationItem.title = "Items"
        
        destinationVC.categoryOrItem.selectedCategory = selectedCategory
    }
    
}








