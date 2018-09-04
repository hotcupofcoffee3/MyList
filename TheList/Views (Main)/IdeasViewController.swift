//
//  IdeasViewController.swift
//  TheList
//
//  Created by Adam Moore on 8/31/18.
//  Copyright © 2018 Adam Moore. All rights reserved.
//

import UIKit

class IdeasViewController: CategoryViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.category.numberOfRows = 2
        self.category.cellIdentifier = "cell"
        self.category.categoryDisplayed = .ideas
        
    }

}
