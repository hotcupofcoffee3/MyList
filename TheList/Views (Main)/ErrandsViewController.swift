//
//  ErrandsViewController.swift
//  TheList
//
//  Created by Adam Moore on 8/31/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class ErrandsViewController: CategoryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.category.numberOfRows = 8
        self.category.cellIdentifier = "cell"
        self.category.categoryDisplayed = .errands
        
    }

}
