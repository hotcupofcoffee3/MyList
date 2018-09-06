//
//  ErrandsViewController.swift
//  TheList
//
//  Created by Adam Moore on 8/31/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class ErrandsViewController: CategoryAndItemViewController {

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.categoryOrItem.numberOfRows = 8
        self.categoryOrItem.viewDisplayed = .errands
        self.categoryOrItem.table = tableView
        
        tableView.register(UINib(nibName: Keywords.shared.cellNibName, bundle: nil), forCellReuseIdentifier: Keywords.shared.categoryAndItemCellIdentifier)
        
        tableView.register(UINib(nibName: Keywords.shared.headerNibName, bundle: nil), forHeaderFooterViewReuseIdentifier: Keywords.shared.headerIdentifier)
        
    }

}
