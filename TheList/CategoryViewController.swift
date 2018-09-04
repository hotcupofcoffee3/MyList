//
//  CategoryViewController.swift
//  TheList
//
//  Created by Adam Moore on 9/4/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let category = CategoryModel()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return category.numberOfRows
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: category.cellIdentifier, for: indexPath)
        
        cell.textLabel?.text = "\(indexPath.row + 1)"
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        performSegue(withIdentifier: category.categorySegue, sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
    }

}
