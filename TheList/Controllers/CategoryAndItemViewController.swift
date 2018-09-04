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
        
        return categoryOrItem.numberOfRows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        if indexPath.row == 0 {
            
            cell.nameLabel?.text = "Whole Foods Market"
            
        } else {
            
            cell.nameLabel?.text = "\(indexPath.row + 1)"
            
        }
        
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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

}










