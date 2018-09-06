//
//  CategoryAndItemViewController.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class CategoryAndItemViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let categoryOrItem = CategoryAndItemModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryOrItem.items.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: Keywords.shared.headerIdentifier) as! HeaderView
        
        headerView.addItemDelegate = categoryOrItem
        
        headerView.reloadTableListDelegate = categoryOrItem
        
        return headerView
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        cell.nameLabel?.text = categoryOrItem.items[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if categoryOrItem.viewDisplayed != .items {
            
            performSegue(withIdentifier: categoryOrItem.typeOfSegue, sender: self)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 60
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
    }

}










