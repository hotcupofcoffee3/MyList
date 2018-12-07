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
    var itemModel = ItemModel()
    var items = DataModel.shared.loadDefaultItems()
    
    var newlySelectedItemName = String()
    
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
        
        destinationVC.navigationItem.title = newlySelectedItemName
        
        destinationVC.currentLevel = currentLevel + 1
        
    }
    
}



extension MoveItemViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: Keywords.shared.categoryAndItemCellIdentifier, for: indexPath) as! CategoryAndItemTableViewCell
        
        cell.nameLabel.text = items[indexPath.row].name!
        
        // Set up the cell's contents
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        newlySelectedItemName = "\(items[indexPath.row].name!) \(currentLevel)"
        
        if currentMoveVC == "moveItem1" {
            performSegue(withIdentifier: Keywords.shared.moveItem1ToMoveItem2Segue, sender: self)
        } else {
            performSegue(withIdentifier: Keywords.shared.moveItem2ToMoveItem1Segue, sender: self)
        }
        
    }
    
}
