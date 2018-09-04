//
//  WorkViewController.swift
//  TheList
//
//  Created by Adam Moore on 8/31/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class WorkViewController: CategoryAndItemViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.categoryOrItem.numberOfRows = 6
        self.categoryOrItem.viewDisplayed = .work
        
        tableView.register(UINib(nibName: Keywords.shared.cellNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
    }

}
