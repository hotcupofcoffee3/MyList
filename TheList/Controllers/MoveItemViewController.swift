//
//  MoveItemViewController.swift
//  MyList
//
//  Created by Adam Moore on 12/5/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class MoveItemViewController: UIViewController {
    
    var currentMoveVC = String()
    var currentLevel = Int()
    var currentCategory = String()
    var currentParentName = String()
    var currentParentID = Int()
    
    var selectedLevel = Int()
    var selectedCategory = String()
    var selectedParentName = String()
    var selectedParentID = Int()
    
    var newlySelectedItem: Item?
    
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: Keywords.shared.categoryAndItemNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        currentMoveVC = self.title!
    }

}



// Segues

extension MoveItemViewController {
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let destinationVC = segue.destination as! MoveItemViewController
        
        destinationVC.currentLevel = selectedLevel
        destinationVC.currentCategory = selectedCategory
        destinationVC.currentParentName = selectedParentName
        destinationVC.currentParentID = selectedParentID
        
        let casedParentName = (currentLevel == 0) ? selectedParentName.lowercased() : selectedParentName
        
        destinationVC.items = DataModel.shared.loadSpecificItems(forCategory: selectedCategory, forLevel: selectedLevel, forParentID: selectedParentID, andParentName: casedParentName)
        
        destinationVC.navigationItem.title = selectedParentName
        
    }
    
}



extension MoveItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        cell.backgroundColor = Keywords.shared.lightBlueBackground
        
        cell.nameLabel.text = items[indexPath.row].name!
        
        cell.numberLabel.text = "\(items[indexPath.row].id)"
//        cell.numberLabelWidth.constant = 0
        
        cell.checkboxImageWidth.constant = 0
       
        // Set up the cell's contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategory = (currentLevel == 0) ? items[indexPath.row].name!.lowercased() : items[indexPath.row].category!
        
        selectedParentName = items[indexPath.row].name!
        selectedLevel = Int(items[indexPath.row].level) + 1
        selectedParentID = Int(items[indexPath.row].id)
        
        if currentMoveVC == "moveItem1" {
            performSegue(withIdentifier: Keywords.shared.moveItem1ToMoveItem2Segue, sender: self)
        } else {
            performSegue(withIdentifier: Keywords.shared.moveItem2ToMoveItem1Segue, sender: self)
        }
        
    }
    
}
